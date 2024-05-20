library custom_image;

import 'package:equatable/equatable.dart';

abstract class ImagePickerEvent extends Equatable {
  const ImagePickerEvent() : super();
}

class ImagePickerStarted extends ImagePickerEvent {
  @override
  List<Object> get props => [];
}

class OpenImagePicker extends ImagePickerEvent {
  final int? index;
  final bool? camera;
  const OpenImagePicker({
    this.index,
    this.camera,
  });
  @override
  List<Object> get props => [];
}

class DeletePickedImage extends ImagePickerEvent {
  final int? index;
  const DeletePickedImage({this.index});
  @override
  List<Object> get props => [];
}

class ClearPickedImage extends ImagePickerEvent {
  @override
  List<Object> get props => [];
}
