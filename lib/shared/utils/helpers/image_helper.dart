import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';

// Future<File> addCustomWatermark(File imageFile) async {
//   final Uint8List imageBytes = await imageFile.readAsBytes();
//   final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
//   final ui.FrameInfo frameInfo = await codec.getNextFrame();
//   final ui.Image originalImage = frameInfo.image;

//   final recorder = ui.PictureRecorder();
//   final canvas = Canvas(recorder);
//   final paint = Paint();

//   // Gambar gambar asli
//   canvas.drawImage(originalImage, Offset.zero, paint);

//   // Fungsi menggambar teks dengan posisi tertentu
//   void drawText(Canvas canvas, String text, double x, double y, TextStyle style) {
//     final textPainter = TextPainter(
//       text: TextSpan(text: text, style: style),
//       textDirection: TextDirection.ltr,
//     );
//     textPainter.layout();
//     textPainter.paint(canvas, Offset(x, y));
//   }

//   // Gaya teks
//   const TextStyle styleBlueSmall = TextStyle(color: Colors.blueAccent, fontSize: 150);
//   const TextStyle styleBoldLarge = TextStyle(color: Colors.blue, fontSize: 150, fontWeight: FontWeight.bold);
//   const TextStyle styleRed = TextStyle(color: Colors.red, fontSize: 150, fontWeight: FontWeight.bold);
//   const TextStyle styleVisit = TextStyle(color: Colors.blue, fontSize: 150, fontWeight: FontWeight.bold);

//   // Ukuran gambar
//   final int imgWidth = originalImage.width;
//   final int imgHeight = originalImage.height;
//   const double padding = 20;

//   // Posisi teks
//   drawText(canvas, "Nama : xxxxxxx", padding, imgHeight - 180, styleBlueSmall);
//   drawText(canvas, "Nama Toko", padding, imgHeight - 150, styleBoldLarge);
//   drawText(canvas, "Alamat : xxxxxxxxxxxxxxxxxxxxxx", padding, imgHeight - 120, styleBlueSmall);
//   drawText(canvas, "Tanggal xx-xx-xxx", imgWidth - 250, imgHeight - 180, styleBlueSmall);
//   drawText(canvas, "Jam xx:xx:xx", imgWidth - 250, imgHeight - 150, styleBlueSmall);
//   drawText(canvas, "isi Keterangan di table user", padding, imgHeight - 90, styleRed);
//   drawText(canvas, "Visit S7win", imgWidth - 180, imgHeight - 90, styleVisit);

//   // Convert canvas ke gambar
//   final img = await recorder.endRecording().toImage(imgWidth, imgHeight);
//   final ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
//   final Uint8List pngBytes = byteData!.buffer.asUint8List();

//   // Simpan ke file sementara
//   final tempDir = await getTemporaryDirectory();
//   final File tempFile = File("${tempDir.path}/custom_watermarked.png");
//   await tempFile.writeAsBytes(pngBytes);

//   return tempFile;
// }

Future<File> addCustomWatermark(File imageFile, String? currentAddress,String? notes,String? userName,String? storeName) async {
  final Uint8List imageBytes = await imageFile.readAsBytes();
  final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  final ui.Image originalImage = frameInfo.image;

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final paint = Paint();

  // Gambar asli
  canvas.drawImage(originalImage, Offset.zero, paint);

  // Fungsi menggambar teks dengan posisi tertentu
  void drawText(
      Canvas canvas, String text, double x, double y, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x, y));
  }

  // Ukuran gambar
  final int imgWidth = originalImage.width;
  final int imgHeight = originalImage.height;
  const double padding = 60;
  const double lineSpacing = 180; // Jarak antar teks lebih besar

  // Ukuran font besar untuk watermark
  const double fontSize = 150;

  // Format tanggal dan jam sekarang
  String formattedDate = intl.DateFormat('dd/MM/yyyy').format(DateTime.now());
  String formattedTime = intl.DateFormat('HH:mm').format(DateTime.now());

  // Gaya teks
  const TextStyle styleBlueSmallAddress =
      TextStyle(color: Colors.white, fontSize: 150);
  const TextStyle styleBlueSmallTanggal =
      TextStyle(color: Colors.white, fontSize: 150);
  const TextStyle styleBlueSmallJam =
      TextStyle(color: Colors.white, fontSize: 200);

  const TextStyle styleBlueSmall =
      TextStyle(color: Colors.white, fontSize: fontSize);
  const TextStyle styleBoldLarge = TextStyle(
      color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold);
  const TextStyle styleRed = TextStyle(
      color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold);
  const TextStyle styleVisit = TextStyle(
      color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.bold);

// Ukuran maksimal teks sebelum mulai menggambar
  double maxWidthImage = imgWidth - (20 * padding);
  double addressHeight =
      calculateTextHeight(currentAddress!, maxWidthImage, styleBlueSmall);

// Naikkan posisi awal sesuai panjang alamat agar tetap dalam gambar
  double startY = imgHeight - 1000 - addressHeight;
  drawText(canvas, "Nama : $userName", padding, startY, styleBlueSmall);
  startY += lineSpacing;
  drawText(canvas, "Nama Toko :$storeName", padding, startY, styleBoldLarge);
  startY += lineSpacing;

// Gambar alamat dengan wrapping
  double usedHeight = drawWrappedText(
      canvas, currentAddress, padding, startY, maxWidthImage, styleBlueSmall);
  startY += usedHeight + lineSpacing;

// Sekarang "isi keterangan" tetap terlihat karena startY sudah disesuaikan
  drawWrappedText(canvas, "$notes", padding, startY, maxWidthImage,styleRed);
  
  // Posisi untuk waktu & tanggal di kanan bawah
  double startXRight = imgWidth - 1000;
  double startYRight = imgHeight - 800;
  //* Tanggal
  drawText(
      canvas, formattedDate, startXRight, startYRight, styleBlueSmallTanggal);
  startYRight += lineSpacing;
  //* jam
  drawText(canvas, formattedTime, startXRight, startYRight, styleBlueSmallJam);
  startYRight += lineSpacing;
  drawText(canvas, "Visit S7win", startXRight, startYRight, styleVisit);

  // Convert canvas ke gambar
  final img = await recorder.endRecording().toImage(imgWidth, imgHeight);
  final ByteData? byteData =
      await img.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List pngBytes = byteData!.buffer.asUint8List();

  // Simpan ke file sementara
  final tempDir = await getTemporaryDirectory();
  final File tempFile = File("${tempDir.path}/custom_watermarked.png");
  await tempFile.writeAsBytes(pngBytes);

  return tempFile;
}

// Fungsi untuk menggambar teks dengan wrapping otomatis dan menghitung tinggi total
double drawWrappedText(Canvas canvas, String text, double x, double y,
    double maxWidth, TextStyle style) {
  final textSpan = TextSpan(text: text, style: style);
  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
    maxLines: null,
  );

  textPainter.layout(maxWidth: maxWidth);

  double currentY = y;
  for (var line in textPainter.text!.toPlainText().split('\n')) {
    final linePainter = TextPainter(
      text: TextSpan(text: line, style: style),
      textDirection: TextDirection.ltr,
    );
    linePainter.layout(maxWidth: maxWidth);
    linePainter.paint(canvas, Offset(x, currentY));
    currentY += linePainter.height; // Pindah ke baris berikutnya
  }

  return currentY - y; // Mengembalikan tinggi total teks yang digambar
}

double calculateTextHeight(String text, double maxWidth, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    maxLines: null, // Mengizinkan teks panjang untuk wrapping
  );

  textPainter.layout(maxWidth: maxWidth);
  return textPainter.height; // Mengembalikan tinggi total teks setelah dibungkus
}

