library custom_image;

import 'package:equatable/equatable.dart';

abstract class ImagePickerState extends Equatable {
  const ImagePickerState();
}

class ImagePickerInitial extends ImagePickerState {
  @override
  List<Object> get props => [];
}

class ImagePickerLoaded extends ImagePickerState {
  @override
  List<Object> get props => [];
}

class ImagePickerRejected extends ImagePickerState {
  final String? fileName;
  const ImagePickerRejected({this.fileName});
  @override
  List<Object> get props => [];
}

class ImagePickerUploading extends ImagePickerState {
  @override
  List<Object?> get props => [];
}

class ImagePickerUploaded extends ImagePickerState {
  @override
  List<Object> get props => [];
}

class ImagePickerDeleting extends ImagePickerState {
  @override
  List<Object?> get props => [];
}

class ImagePickerDeleted extends ImagePickerState {
  @override
  List<Object> get props => [];
}
