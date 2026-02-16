import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

enum ResizeStatus { idle, picking, ready, processing, done, error }

class ResizeState {
  final File? originalFile;
  final File? resizedFile;
  final int? originalWidth;
  final int? originalHeight;
  final int? targetWidth;
  final int? targetHeight;
  final bool maintainAspect;
  final ResizeStatus status;
  final String? errorMessage;

  const ResizeState({
    this.originalFile,
    this.resizedFile,
    this.originalWidth,
    this.originalHeight,
    this.targetWidth,
    this.targetHeight,
    this.maintainAspect = true,
    this.status = ResizeStatus.idle,
    this.errorMessage,
  });

  bool get hasImage => originalFile != null;

  ResizeState copyWith({
    File? originalFile,
    File? resizedFile,
    int? originalWidth,
    int? originalHeight,
    int? targetWidth,
    int? targetHeight,
    bool? maintainAspect,
    ResizeStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ResizeState(
      originalFile: originalFile ?? this.originalFile,
      resizedFile: resizedFile ?? this.resizedFile,
      originalWidth: originalWidth ?? this.originalWidth,
      originalHeight: originalHeight ?? this.originalHeight,
      targetWidth: targetWidth ?? this.targetWidth,
      targetHeight: targetHeight ?? this.targetHeight,
      maintainAspect: maintainAspect ?? this.maintainAspect,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final resizeControllerProvider =
    StateNotifierProvider<ResizeController, ResizeState>(
  (ref) => ResizeController(),
);

class ResizeController extends StateNotifier<ResizeState> {
  ResizeController() : super(const ResizeState());

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      state = state.copyWith(status: ResizeStatus.picking, clearError: true);
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (picked == null) {
        state = state.copyWith(status: ResizeStatus.idle);
        return;
      }
      final file = File(picked.path);
      // We don't have direct intrinsic size here; user will input custom size.
      state = ResizeState(
        originalFile: file,
        resizedFile: null,
        maintainAspect: state.maintainAspect,
        status: ResizeStatus.ready,
      );
    } catch (e) {
      state = state.copyWith(
        status: ResizeStatus.error,
        errorMessage: 'Failed to pick image: $e',
      );
    }
  }

  void updateWidth(String value) {
    final w = int.tryParse(value);
    state = state.copyWith(targetWidth: w);
  }

  void updateHeight(String value) {
    final h = int.tryParse(value);
    state = state.copyWith(targetHeight: h);
  }

  void updateMaintainAspect(bool value) {
    state = state.copyWith(maintainAspect: value);
  }

  Future<void> resize() async {
    if (state.originalFile == null) return;
    final width = state.targetWidth;
    final height = state.targetHeight;
    if (width == null && height == null) {
      state = state.copyWith(
        status: ResizeStatus.error,
        errorMessage: 'Please enter width or height',
      );
      return;
    }
    try {
      state = state.copyWith(status: ResizeStatus.processing, clearError: true);
      final tempDir = await getTemporaryDirectory();
      final targetPath = p.join(
        tempDir.path,
        'resized_${DateTime.now().millisecondsSinceEpoch}${p.extension(state.originalFile!.path)}',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        state.originalFile!.absolute.path,
        targetPath,
        minWidth: width ?? 0,
        minHeight: height ?? 0,
      );
      if (result == null) {
        throw Exception('Resize returned null file');
      }
      final resized = File(result.path);
      state = state.copyWith(
        resizedFile: resized,
        status: ResizeStatus.done,
      );
    } catch (e) {
      state = state.copyWith(
        status: ResizeStatus.error,
        errorMessage: 'Resize failed: $e',
      );
    }
  }

  Future<bool> saveToDownloads() async {
    if (state.resizedFile == null) return false;
    try {
      final statusPerm = await Permission.storage.request();
      if (!statusPerm.isGranted) {
        state = state.copyWith(
          status: ResizeStatus.error,
          errorMessage: 'Storage permission denied',
        );
        return false;
      }

      Directory? dir;
      if (Platform.isAndroid) {
        dir = await getExternalStorageDirectory();
      } else {
        dir = await getApplicationDocumentsDirectory();
      }
      if (dir == null) return false;

      final outDir = Directory(p.join(dir.path, 'CompressX'));
      if (!await outDir.exists()) {
        await outDir.create(recursive: true);
      }

      final fileName = p.basename(state.resizedFile!.path);
      final target = File(p.join(outDir.path, fileName));
      await state.resizedFile!.copy(target.path);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: ResizeStatus.error,
        errorMessage: 'Failed to save resized image: $e',
      );
      return false;
    }
  }

  Future<void> shareResized() async {
    if (state.resizedFile == null) return;
    try {
      await Share.shareXFiles([XFile(state.resizedFile!.path)]);
    } catch (e) {
      state = state.copyWith(
        status: ResizeStatus.error,
        errorMessage: 'Failed to share image: $e',
      );
    }
  }
}

