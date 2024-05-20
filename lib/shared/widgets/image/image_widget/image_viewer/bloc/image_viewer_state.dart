import 'package:equatable/equatable.dart';

abstract class ImageViewerState extends Equatable {
  const ImageViewerState();
}

class ImageViewerInitial extends ImageViewerState {
  @override
  List<Object> get props => [];
}

class ImageViewerLoading extends ImageViewerState {
  @override
  List<Object> get props => [];
}

class ImageChanged extends ImageViewerState {
  @override
  List<Object> get props => [];
}

class ImageDownloading extends ImageViewerState {
  @override
  List<Object> get props => [];
}

class ImageDownloaded extends ImageViewerState {
  @override
  List<Object> get props => [];
}
