import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path/path.dart' as p;

enum CompressStatus { idle, picking, ready, compressing, done, error }

class CompressState {
  final File? originalFile;
  final File? compressedFile;
  final int? originalBytes;
  final int? compressedBytes;
  final double quality; // 0.0 - 1.0
  final CompressStatus status;
  final String? errorMessage;

  const CompressState({
    this.originalFile,
    this.compressedFile,
    this.originalBytes,
    this.compressedBytes,
    this.quality = 0.7,
    this.status = CompressStatus.idle,
    this.errorMessage,
  });

  bool get hasImage => originalFile != null;

  double? get reductionPercent {
    if (originalBytes == null || compressedBytes == null) return null;
    if (originalBytes == 0) return null;
    final saved = originalBytes! - compressedBytes!;
    return saved <= 0 ? 0 : (saved / originalBytes!) * 100;
  }

  CompressState copyWith({
    File? originalFile,
    File? compressedFile,
    int? originalBytes,
    int? compressedBytes,
    double? quality,
    CompressStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CompressState(
      originalFile: originalFile ?? this.originalFile,
      compressedFile: compressedFile ?? this.compressedFile,
      originalBytes: originalBytes ?? this.originalBytes,
      compressedBytes: compressedBytes ?? this.compressedBytes,
      quality: quality ?? this.quality,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final compressControllerProvider =
    StateNotifierProvider<CompressController, CompressState>(
  (ref) => CompressController(),
);

class CompressController extends StateNotifier<CompressState> {
  CompressController() : super(const CompressState());

  final ImagePicker _picker = ImagePicker();

  Future<void> pickFromGallery() async {
    await _pick(ImageSource.gallery);
  }

  Future<void> pickFromCamera() async {
    await _pick(ImageSource.camera);
  }

  Future<void> _pick(ImageSource source) async {
    try {
      state = state.copyWith(status: CompressStatus.picking, clearError: true);
      final picked = await _picker.pickImage(source: source, imageQuality: 100);
      if (picked == null) {
        state = state.copyWith(status: CompressStatus.idle);
        return;
      }
      final file = File(picked.path);
      final bytes = await file.length();
      state = CompressState(
        originalFile: file,
        compressedFile: null,
        originalBytes: bytes,
        compressedBytes: null,
        quality: state.quality,
        status: CompressStatus.ready,
      );
    } catch (e) {
      state = state.copyWith(
        status: CompressStatus.error,
        errorMessage: 'Failed to pick image: $e',
      );
    }
  }

  void updateQuality(double quality) {
    state = state.copyWith(quality: quality, clearError: true);
  }

  Future<void> compress() async {
    if (state.originalFile == null) return;
    try {
      state = state.copyWith(status: CompressStatus.compressing, clearError: true);

      final tempDir = await getTemporaryDirectory();
      final targetPath = p.join(
        tempDir.path,
        'compressed_${DateTime.now().millisecondsSinceEpoch}${p.extension(state.originalFile!.path)}',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        state.originalFile!.absolute.path,
        targetPath,
        quality: (state.quality * 100).clamp(1, 100).toInt(),
      );

      if (result == null) {
        throw Exception('Compression returned null file');
      }

      final compressedFile = File(result.path);
      final compressedBytes = await compressedFile.length();

      state = state.copyWith(
        compressedFile: compressedFile,
        compressedBytes: compressedBytes,
        status: CompressStatus.done,
      );
    } catch (e) {
      state = state.copyWith(
        status: CompressStatus.error,
        errorMessage: 'Compression failed: $e',
      );
    }
  }

  Future<bool> saveToDownloads() async {
    if (state.compressedFile == null) return false;
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        state = state.copyWith(
          status: CompressStatus.error,
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

      final downloadsDir = Directory(p.join(dir.path, 'CompressX'));
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      final fileName = p.basename(state.compressedFile!.path);
      final target = File(p.join(downloadsDir.path, fileName));
      await state.compressedFile!.copy(target.path);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: CompressStatus.error,
        errorMessage: 'Failed to save file: $e',
      );
      return false;
    }
  }

  Future<void> shareCompressed() async {
    if (state.compressedFile == null) return;
    try {
      await Share.shareXFiles([XFile(state.compressedFile!.path)]);
    } catch (e) {
      state = state.copyWith(
        status: CompressStatus.error,
        errorMessage: 'Failed to share file: $e',
      );
    }
  }
}

