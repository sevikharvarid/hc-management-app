library custom_image;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/widgets/image/image_widget/image_viewer/bloc/image_viewer_state.dart';

class ImageViewerCubit extends Cubit<ImageViewerState> {
  List<String> imagesUrl = [];
  // List<UJPProof> ujpProofList = [];
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();
  GeneralHelper generalHelper = GeneralHelper();
  int? currentIndex;
  bool isActiveButton = true;

  ImageViewerCubit() : super(ImageViewerLoading());

  FutureOr<void> initImageViewer({
    int? index,
    List<String>? images,
    // List<UJPProof>? ujpProof,
  }) async {
    emit(ImageViewerLoading());
    pageController = PageController(initialPage: index ?? 0);

    currentIndex = index ?? 0;
    if (images != null) {
      imagesUrl.addAll(images);
    }
    // if (ujpProof != null) {
    //   ujpProofList.addAll(ujpProof);
    // }

    emit(ImageViewerInitial());
  }

  FutureOr<void> changeImage({
    required int index,
    bool isPageController = false,
    bool? isScrollController,
  }) {
    emit(ImageViewerLoading());
    currentIndex = index;

    if (isPageController == false) {
      pageController.animateToPage(
        currentIndex!,
        duration: const Duration(milliseconds: 1),
        curve: Curves.linear,
      );
    }

    if (isScrollController == true) {
      // var data = imagesUrl.isNotEmpty ? imagesUrl : ujpProofList;
      var data = imagesUrl;

      if (currentIndex! >= 0 && currentIndex! < data.length) {
        scrollController.animateTo(
          currentIndex! * 50 + (20 * currentIndex!.toDouble()),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }

    emit(ImageChanged());
  }
}
