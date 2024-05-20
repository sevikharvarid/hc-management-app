library custom_image;

import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/widgets/image/image_widget/image_picker/bloc/image_picker_event.dart';
import 'package:hc_management_app/shared/widgets/image/image_widget/image_picker/bloc/image_picker_state.dart';

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  late List<String>? encodedStringImage = [];
  late List<String>? pickedImageName = [];
  late List<bool>? pickedImageIsUploading = [];
  GeneralHelper generalHelper = GeneralHelper();

  ImagePickerBloc() : super(ImagePickerInitial()) {
    on<ImagePickerStarted>(imagePickerInitial);
    on<OpenImagePicker>(openImagePicker);
    on<DeletePickedImage>(deleteImage);
    on<ClearPickedImage>(clearImage);
  }

  FutureOr<void> imagePickerInitial(
    ImagePickerStarted event,
    Emitter<ImagePickerState> emit,
  ) async {
    emit(ImagePickerInitial());
  }

  FutureOr<void> openImagePicker(
    OpenImagePicker event,
    Emitter<ImagePickerState> emit,
  ) async {
    final pickedImage = await generalHelper.pickImage(camera: event.camera!);

    if (pickedImage != null) {
      String originalFileName = pickedImage.path.split('scaled_').last;

      emit(ImagePickerInitial());

      if (!event.camera!) {
        if (!generalHelper.validateImageSize(file: pickedImage)) {
          emit(ImagePickerRejected(fileName: originalFileName));
          return;
        }
      }

      final convertedImage =
          await generalHelper.convertImageToJpg(file: pickedImage);
      String encodedImage = base64Encode(convertedImage.readAsBytesSync());
      String fileName = convertedImage.path.split('cache-scaled_').last;

      emit(ImagePickerUploading());

      if (event.index == null ||
          (event.index == 0 && encodedStringImage!.isEmpty)) {
        pickedImageIsUploading!.add(true);
      } else {
        pickedImageIsUploading![event.index!] = true;
      }

      await Future.delayed(const Duration(seconds: 1), () {
        if (event.index == null ||
            (event.index == 0 && encodedStringImage!.isEmpty)) {
          pickedImageName!.add(fileName);
          encodedStringImage!.add(encodedImage);
          pickedImageIsUploading![encodedStringImage!.length - 1] = false;
        } else {
          pickedImageName![event.index!] = fileName;
          encodedStringImage![event.index!] = encodedImage;
          pickedImageIsUploading![event.index!] = false;
        }

        emit(ImagePickerUploaded());
      });
    }
  }

  FutureOr<void> deleteImage(
    DeletePickedImage event,
    Emitter<ImagePickerState> emit,
  ) async {
    emit(ImagePickerDeleting());

    pickedImageName!.removeAt(event.index!);
    encodedStringImage!.removeAt(event.index!);
    pickedImageIsUploading!.removeAt(event.index!);

    emit(ImagePickerDeleted());
  }

  FutureOr<void> clearImage(
    ClearPickedImage event,
    Emitter<ImagePickerState> emit,
  ) async {
    emit(ImagePickerDeleting());

    pickedImageName!.clear();
    encodedStringImage!.clear();
    pickedImageIsUploading!.clear();

    emit(ImagePickerDeleted());
  }
}
