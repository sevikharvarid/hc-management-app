import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:hc_management_app/features/face_recognition/services/image_converter.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart';

List kUserFaceData = [];

class MLService {
  Interpreter? _interpreter;
  double threshold = 0.8;

  List _predictedData = [];
  List get predictedData => _predictedData;

  Future initialize() async {
    try {
      final options = InterpreterOptions();

      // Use XNNPACK Delegate
      if (Platform.isAndroid) {
        options.addDelegate(XNNPackDelegate());
      }

      // Use GPU Delegate
      // doesn't work on emulator
      // if (Platform.isAndroid) {
      //   options.addDelegate(GpuDelegateV2());
      // }

      // Use Metal Delegate
      if (Platform.isIOS) {
        options.addDelegate(GpuDelegate());
      }
      _interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite',
          options: options);
    } catch (e) {
      debugPrint('Failed to load model.');
      debugPrint(e.toString());
    }
  }

  void setCurrentPrediction(CameraImage cameraImage, Face? face) {
    if (_interpreter == null) throw Exception('Interpreter is null');
    if (face == null) throw Exception('Face is null');
    List input = _preProcess(cameraImage, face);

    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));

    _interpreter?.run(input, output);
    output = output.reshape([192]);

    _predictedData = List.from(output);
  }

  Future<bool?> predict() async {
    return _searchResult(_predictedData);
  }

  List _preProcess(CameraImage image, Face faceDetected) {
    imglib.Image croppedImage = _cropFace(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, size: 112);

    Float32List imageAsList = imageToByteListFloat32(img);
    return imageAsList;
  }

  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = _convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(convertedImage,
        x: x.round(), y: y.round(), width: w.round(), height: h.round());
  }

  imglib.Image _convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    var img1 = imglib.copyRotate(img, angle: -90);
    return img1;
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getLuminance(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getLuminance(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getLuminance(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  ///dummy user
  Future<bool?> _searchResult(List predictedData) async {
    double minDist = 999;
    double currDist = 0.0;

    currDist = _euclideanDistance(kUserFaceData, predictedData);
    if (currDist <= threshold && currDist < minDist) {
      minDist = currDist;
      Fluttertoast.showToast(msg: 'minDist: $currDist');

      return true;
    }

    Fluttertoast.showToast(msg: 'Face is not match, try again');

    return false;
  }

  double _euclideanDistance(List? e1, List? e2) {
    if (e1 == null || e2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  void setPredictedData(value) {
    _predictedData = value;
  }

  dispose() {}
}
