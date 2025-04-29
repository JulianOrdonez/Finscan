import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanService {
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<String?> pickAndScanReceipt() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile == null) return null;

    final File imageFile = File(pickedFile.path);
    final InputImage inputImage = InputImage.fromFile(imageFile);

    final RecognizedText recognizedText = await _textRecognizer.processImage(
      inputImage,
    );

    return recognizedText.text;
  }

  Future<String?> pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return null;

    final File imageFile = File(pickedFile.path);
    final InputImage inputImage = InputImage.fromFile(imageFile);

    final RecognizedText recognizedText = await _textRecognizer.processImage(
      inputImage,
    );

    return recognizedText.text;
  }

  // Un método simple para extraer posible información útil del texto escaneado
  Map<String, dynamic> extractReceiptInfo(String text) {
    // Implementación básica - esto sería mejorado con algoritmos más avanzados
    double? amount;
    String? title;

    // Intentar encontrar el valor total
    final RegExp amountRegex = RegExp(
      r'total[\s:]*(\d+[.,]\d{2})',
      caseSensitive: false,
    );
    final match = amountRegex.firstMatch(text);
    if (match != null) {
      String amountStr = match.group(1)!.replaceAll(',', '.');
      amount = double.tryParse(amountStr);
    }

    // Tomar la primera línea como posible nombre del establecimiento
    final lines = text.split('\n');
    if (lines.isNotEmpty) {
      title = lines.first.trim();
    }

    return {'title': title ?? 'Gasto escaneado', 'amount': amount ?? 0.0};
  }

  void dispose() {
    _textRecognizer.close();
  }
}
