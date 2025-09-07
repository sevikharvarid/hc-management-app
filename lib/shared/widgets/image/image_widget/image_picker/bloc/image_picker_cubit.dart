import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/utils/helpers/image_helper.dart';
import 'package:hc_management_app/shared/widgets/image/image_widget/image_picker/bloc/image_picker_state.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCubit extends Cubit<ImagePickerState> {
  late List<File>? pickedImageFile = [];
  late List<String>? pickedImageName = [];
  late List<bool>? pickedImageIsUploading = [];
  GeneralHelper generalHelper = GeneralHelper();

  ImagePickerCubit() : super(ImagePickerInitial()) {
    pickedImageFile = [];
    pickedImageName = [];
    pickedImageIsUploading = [];
  }

  void setPickedImage(List<File>? pickedImage) {
    emit(ImagePickerInitial());
    if (pickedImage != null) {
      pickedImageFile = pickedImage;
      pickedImageIsUploading!.clear();
      pickedImageName!.clear();

      List<bool> loadingState =
          List.generate(pickedImage.length, (index) => false);
      List<String> fileName = List.generate(
        pickedImage.length,
        (index) => pickedImage[index].path.split('scaled_').last,
      );

      pickedImageIsUploading!.addAll(loadingState);
      pickedImageName!.addAll(fileName);
    }

    emit(ImagePickerLoaded());
  }

  Future<void> openImagePicker({
    bool? camera,
    int? index,
    int? quality,
    String? userName,
    String? storeName,
    String? notes,
    String? userAddress,
    CameraDevice? preferredCameraDevice,
  }) async {
    try {
      emit(ImagePickerInitial());
      final pickedImage = await generalHelper.pickImage(
        camera: camera!,
      );

      if (pickedImage != null) {
        var compressImage = pickedImage;

        if (!camera) {
          if (!generalHelper.validateImageSize(file: compressImage)) {
            emit(ImagePickerRejected(
                fileName: compressImage.path.split('/').last));
            return;
          }
        }

        if (!generalHelper.validateImageSize(file: compressImage)) {
          emit(ImagePickerRejected(
              fileName: compressImage.path.split('/').last));
          return;
        }

       

        final watermarkedImage = await addCustomWatermark(
            compressImage, userAddress, notes, userName, storeName);

        final convertedImage = await generalHelper.compressAndConvertToJPG(
          file: watermarkedImage,
          quality: quality,
        );


        compressImage = convertedImage!;

        String fileName = compressImage.path.split('scaled_').last;

        if (index == null || (index == 0 && pickedImageFile!.isEmpty)) {
          pickedImageIsUploading!.add(true);
        } else {
          pickedImageIsUploading![index] = true;
        }

        emit(ImagePickerUploading());

        await Future.delayed(const Duration(milliseconds: 100), () {
          if (index == null || (index == 0 && pickedImageFile!.isEmpty)) {
            pickedImageName!.add(fileName);
            pickedImageFile = List.from(pickedImageFile!);
            pickedImageFile!.add(compressImage);
            pickedImageIsUploading!.last = false;
          } else {
            pickedImageName![index] = fileName;
            pickedImageFile![index] = compressImage;
            pickedImageIsUploading![index] = false;
          }
        });
        emit(ImagePickerUploaded());
      }
    } catch (e) {
      log("ERROR :$e");
    }
  }

  Future<void> deleteImage({int? index}) async {
    emit(ImagePickerDeleting());

    pickedImageName!.removeAt(index!);
    pickedImageFile!.removeAt(index);
    pickedImageIsUploading!.removeAt(index);

    emit(ImagePickerDeleted());
  }

  Future<void> clearImage() async {
    emit(ImagePickerDeleting());

    pickedImageName!.clear();
    pickedImageFile!.clear();
    pickedImageIsUploading!.clear();

    emit(ImagePickerDeleted());
  }
}
