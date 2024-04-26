import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'camera.service.dart';
import 'locator/locator.dart';

class FaceDetectorService {
  final CameraService _cameraService = locator<CameraService>();

  late FaceDetector _faceDetector;

  FaceDetector get faceDetector => _faceDetector;

  List<Face> _faces = [];

  List<Face> get faces => _faces;

  bool get faceDetected => _faces.isNotEmpty;

  void initialize() {
    _faceDetector = FaceDetector(
        options:
            FaceDetectorOptions(performanceMode: FaceDetectorMode.accurate));
  }

/*  Future<void> detectFacesFromImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    InputImageRotation imageRotation = _cameraService.cameraRotation ?? InputImageRotation.rotation0deg;
    var imageFormat = (Platform.isIOS) ? InputImageFormat.bgra8888 : InputImageFormat.yuv420;

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: imageFormat,
      planeData: image.planes.map(
            (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList(),
    );

    InputImage firebaseVisionImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );

    _faces = await _faceDetector.processImage(firebaseVisionImage);
  }*/

  Future<void> detectFacesFromImage(CameraImage image) async {
    // get image format
    // final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // print("object $format");
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS

    InputImageRotation imageRotation = _cameraService.cameraRotation ?? InputImageRotation.rotation0deg;

    // if (format == null || (Platform.isAndroid && format != InputImageFormat.nv21) || (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    var format = (Platform.isIOS) ? InputImageFormat.bgra8888 : InputImageFormat.yuv420;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    // if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    // compose InputImage using bytes
    InputImage firebaseVisionImage =  InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: imageRotation, // used only in Android
        format: format, // used only in iOS
        // bytesPerRow: plane.bytesPerRow, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );

    _faces = await _faceDetector.processImage(firebaseVisionImage);
    print(_faces.length.toString());
  }


  dispose() {
    _faceDetector.close();
  }
}
