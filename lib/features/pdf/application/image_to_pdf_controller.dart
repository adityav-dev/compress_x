import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

enum ImageToPdfStatus { idle, picking, ready, generating, done, error }

class ImageToPdfState {
  final List<File> images;
  final File? pdfFile;
  final ImageToPdfStatus status;
  final String paperSize; // 'A4', 'A5', 'Letter'
  final String orientation; // 'Portrait', 'Landscape'
  final double margin;
  final String? errorMessage;

  const ImageToPdfState({
    this.images = const [],
    this.pdfFile,
    this.status = ImageToPdfStatus.idle,
    this.paperSize = 'A4',
    this.orientation = 'Portrait',
    this.margin = 8,
    this.errorMessage,
  });

  bool get hasImages => images.isNotEmpty;

  ImageToPdfState copyWith({
    List<File>? images,
    File? pdfFile,
    ImageToPdfStatus? status,
    String? paperSize,
    String? orientation,
    double? margin,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ImageToPdfState(
      images: images ?? this.images,
      pdfFile: pdfFile ?? this.pdfFile,
      status: status ?? this.status,
      paperSize: paperSize ?? this.paperSize,
      orientation: orientation ?? this.orientation,
      margin: margin ?? this.margin,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final imageToPdfControllerProvider =
    StateNotifierProvider<ImageToPdfController, ImageToPdfState>(
  (ref) => ImageToPdfController(),
);

class ImageToPdfController extends StateNotifier<ImageToPdfState> {
  ImageToPdfController() : super(const ImageToPdfState());

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    try {
      state = state.copyWith(
        status: ImageToPdfStatus.picking,
        clearError: true,
      );
      final picked = await _picker.pickMultiImage(imageQuality: 100);
      if (picked.isEmpty) {
        state = state.copyWith(status: ImageToPdfStatus.idle);
        return;
      }
      final files = picked.map((x) => File(x.path)).toList();
      state = state.copyWith(
        images: files,
        pdfFile: null,
        status: ImageToPdfStatus.ready,
      );
    } catch (e) {
      state = state.copyWith(
        status: ImageToPdfStatus.error,
        errorMessage: 'Failed to pick images: $e',
      );
    }
  }

  void removeAt(int index) {
    final images = [...state.images]..removeAt(index);
    state = state.copyWith(images: images);
  }

  void updatePaperSize(String value) {
    state = state.copyWith(paperSize: value);
  }

  void updateOrientation(String value) {
    state = state.copyWith(orientation: value);
  }

  void updateMargin(double value) {
    state = state.copyWith(margin: value);
  }

  Future<void> generatePdf() async {
    if (state.images.isEmpty) return;
    try {
      state = state.copyWith(
        status: ImageToPdfStatus.generating,
        clearError: true,
      );

      final pdf = pw.Document();

      final pageFormat = _pageFormatFor(
        state.paperSize,
        state.orientation,
      );

      final margin = state.margin;

      for (final imgFile in state.images) {
        final bytes = await imgFile.readAsBytes();
        final image = pw.MemoryImage(bytes);
        pdf.addPage(
          pw.Page(
            pageFormat: pageFormat,
            margin: pw.EdgeInsets.all(margin),
            build: (context) {
              return pw.Center(
                child: pw.Image(
                  image,
                  fit: pw.BoxFit.contain,
                ),
              );
            },
          ),
        );
      }

      final outputDir = await getTemporaryDirectory();
      final outPath = p.join(
        outputDir.path,
        'images_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      final file = File(outPath);
      await file.writeAsBytes(await pdf.save());

      state = state.copyWith(
        pdfFile: file,
        status: ImageToPdfStatus.done,
      );
    } catch (e) {
      state = state.copyWith(
        status: ImageToPdfStatus.error,
        errorMessage: 'Failed to generate PDF: $e',
      );
    }
  }

  Future<bool> saveToDownloads() async {
    if (state.pdfFile == null) return false;
    try {
      final statusPerm = await Permission.storage.request();
      if (!statusPerm.isGranted) {
        state = state.copyWith(
          status: ImageToPdfStatus.error,
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

      final fileName = p.basename(state.pdfFile!.path);
      final target = File(p.join(outDir.path, fileName));
      await state.pdfFile!.copy(target.path);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: ImageToPdfStatus.error,
        errorMessage: 'Failed to save PDF: $e',
      );
      return false;
    }
  }

  Future<void> sharePdf() async {
    if (state.pdfFile == null) return;
    try {
      await Share.shareXFiles([XFile(state.pdfFile!.path)]);
    } catch (e) {
      state = state.copyWith(
        status: ImageToPdfStatus.error,
        errorMessage: 'Failed to share PDF: $e',
      );
    }
  }

  PdfPageFormat _pageFormatFor(String paper, String orientation) {
    PdfPageFormat format;
    switch (paper) {
      case 'A5':
        format = PdfPageFormat.a5;
        break;
      case 'Letter':
        format = PdfPageFormat.letter;
        break;
      case 'A4':
      default:
        format = PdfPageFormat.a4;
        break;
    }
    if (orientation == 'Landscape') {
      format = format.landscape;
    }
    return format;
  }
}

