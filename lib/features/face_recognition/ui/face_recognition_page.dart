import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:hc_management_app/features/face_recognition/components/FacePainter.dart';
import 'package:hc_management_app/features/face_recognition/components/camera_header.dart';
import 'package:hc_management_app/features/face_recognition/services/camera.service.dart';
import 'package:hc_management_app/features/face_recognition/services/face_detector_service.dart';
import 'package:hc_management_app/features/face_recognition/services/locator/locator.dart';
import 'package:hc_management_app/features/face_recognition/services/ml_service.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';

class TakePicture extends StatefulWidget {
  const TakePicture({Key? key}) : super(key: key);

  @override
  TakePictureState createState() => TakePictureState();
}

class TakePictureState extends State<TakePicture> {
  String? imagePath;
  Face? faceDetected;
  Size? imageSize;

  bool _detectingFaces = false;
  bool pictureTaken = false;

  bool _initializing = false;

  bool _saving = false;
  bool _bottomSheetVisible = false;

  // service injection
  final FaceDetectorService _faceDetectorService =
      locator<FaceDetectorService>();
  final CameraService _cameraService = locator<CameraService>();
  final MLService _mlService = locator<MLService>();

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  _start() async {
    setState(() => _initializing = true);
    await _mlService.initialize();
    await _cameraService.initialize();
    _faceDetectorService.initialize();
    setState(() => _initializing = false);

    _frameFaces();
  }

  Future<bool> onShot() async {
    if (faceDetected == null) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('No face detected!'),
          );
        },
      );
      return false;
    } else {
      _saving = true;
      await Future.delayed(const Duration(milliseconds: 200));
      XFile? file = await _cameraService.takePicture();
      imagePath = file!.path;

      setState(() {
        _bottomSheetVisible = true;
        pictureTaken = true;
      });

      return true;
    }
  }

  _frameFaces() {
    imageSize = _cameraService.getImageSize();

    _cameraService.cameraController?.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        if (_detectingFaces) return;
        _detectingFaces = true;
        try {
          await _faceDetectorService.detectFacesFromImage(image);

          if (_faceDetectorService.faces.isNotEmpty) {
            setState(() {
              faceDetected = _faceDetectorService.faces.first;
            });

            if (_saving) {
              _mlService.setCurrentPrediction(image, faceDetected);
              setState(() {
                _saving = false;
              });
            }
          } else {
            setState(() {
              faceDetected = null;
            });
          }
          _detectingFaces = false;
        } catch (e) {
          debugPrint('$e');
          _detectingFaces = false;
        }
      }
    });
  }

  _onBackPressed() {
    Navigator.of(context).pop();
  }

  _reload() {
    setState(() {
      _bottomSheetVisible = false;
      pictureTaken = false;
    });
    _start();
  }

  @override
  Widget build(BuildContext context) {
    const double mirror = math.pi;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    late Widget body;
    if (_initializing) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!_initializing && pictureTaken) {
      body = SizedBox(
        width: width,
        height: height,
        child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(mirror),
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.file(File(imagePath!)),
            )),
      );
    }

    if (!_initializing && !pictureTaken) {
      body = Transform.scale(
        scale: 1.0,
        child: AspectRatio(
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          child: OverflowBox(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: SizedBox(
                width: width,
                height:
                    width * _cameraService.cameraController!.value.aspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    CameraPreview(_cameraService.cameraController!),
                    CustomPaint(
                      painter: FacePainter(
                          face: faceDetected, imageSize: imageSize!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
        body: Stack(
          children: [
            body,
            CameraHeader(
              "Ambil Foto",
              onBackPressed: _onBackPressed,
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: !_bottomSheetVisible
            ? CustomButton(
                borderColor: AppColors.primary,
                backgroundColor: MaterialStateProperty.all(
                  AppColors.purple,
                ),
                title: "Ambil Foto",
                action: onShot,
                withIcon: false,
                active: true,
              )
            : CustomButton(
                borderColor: AppColors.primary,
                backgroundColor: MaterialStateProperty.all(
                  AppColors.purple,
                ),
                title: "Kirim Data",
                action: () {
                  Navigator.pop(context, imagePath);
                },
                withIcon: false,
                active: true,
              ));
  }
}
