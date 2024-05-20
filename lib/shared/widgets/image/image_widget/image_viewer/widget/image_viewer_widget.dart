import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/image/image_network_rectangle.dart';
import 'package:hc_management_app/shared/widgets/image/image_widget/image_viewer/bloc/image_viewer_cubit.dart';
import 'package:hc_management_app/shared/widgets/image/image_widget/image_viewer/bloc/image_viewer_state.dart';

class ImageViewerWidget extends StatefulWidget {
  final String? titleText;
  final String? labelTextDownload;
  final String? nameFileDownload;
  final Widget? contentDescription;
  final bool isStaticContentPhotos;
  final Alignment alignmentPhotos;

  const ImageViewerWidget({
    super.key,
    this.labelTextDownload,
    this.nameFileDownload,
    this.contentDescription,
    this.isStaticContentPhotos = false,
    required this.titleText,
    required this.alignmentPhotos,
  });

  @override
  State<ImageViewerWidget> createState() => ImageViewerWidgetState();
}

class ImageViewerWidgetState extends State<ImageViewerWidget> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ImageViewerCubit>();

    return BlocConsumer<ImageViewerCubit, ImageViewerState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ImageViewerLoading) {
            return Container();
          }
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              title: Text(widget.titleText!),
            ),
            body: (cubit.imagesUrl.length == 1)
                ? singleImage(cubit)
                : multipleImages(cubit),
            bottomNavigationBar: customBottomNavigationBar(cubit),
          );
        });
  }

  Widget singleImage(ImageViewerCubit cubit) {
    return Center(
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        scaleEnabled: true,
        panEnabled: true,
        clipBehavior: Clip.none,
        child: Container(
          margin: const EdgeInsets.only(
            bottom: SizeUtils.basePaddingMargin16,
          ),
          child: ImageNetworkRectangle(
            imageUrl: cubit.imagesUrl[0],
            boxFit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget multipleImages(ImageViewerCubit cubit) {
    var data = cubit.imagesUrl;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // image
          SizedBox(
            height: SizeUtils.baseWidthHeight485,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              controller: cubit.pageController,
              itemCount: data.length,
              onPageChanged: (index) {
                cubit.changeImage(
                  index: index,
                  isPageController: true,
                  isScrollController: widget.isStaticContentPhotos,
                );
              },
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  panEnabled: false,
                  clipBehavior: Clip.none,
                  child: Container(
                    child: ImageNetworkRectangle(
                      imageUrl: cubit.imagesUrl[index],
                      boxFit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),

          // if (cubit.ujpProofList.isNotEmpty)
          //   Container(
          //     margin: const EdgeInsets.all(SizeUtils.basePaddingMargin16),
          //     padding: const EdgeInsets.all(SizeUtils.basePaddingMargin16),
          //     decoration: BoxDecoration(
          //       color: AppColors.grey250,
          //       borderRadius: BorderRadius.circular(SizeUtils.baseRoundedCorner),
          //     ),
          //     child: Column(
          //       children: [
          //         SubmissionDetail(
          //           label: language.labelCategory,
          //           child: TextHeading6(
          //             longText:
          //                 cubit.ujpProofList[cubit.currentIndex!].category,
          //             weight: FontWeight.w500,
          //             height: 1.3,
          //           ),
          //         ),
          //         SubmissionDetail(
          //           label: language.labelNominal,
          //           child: TextHeading6(
          //             longText: cubit.ujpProofList[cubit.currentIndex!].nominal,
          //             weight: FontWeight.w500,
          //             height: 1.3,
          //           ),
          //         ),
          //         SubmissionDetail(
          //           label: language.labelDescription,
          //           child: TextHeading6(
          //             longText: cubit.ujpProofList[cubit.currentIndex!].notes,
          //             weight: FontWeight.w500,
          //             height: 1.3,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),

          if (!widget.isStaticContentPhotos) contentPhotosWidget(cubit),
        ],
      ),
    );
  }

  Widget? customBottomNavigationBar(ImageViewerCubit cubit) {
    var data = cubit.imagesUrl;

    if (widget.isStaticContentPhotos) {
      return Container(
        color: AppColors.white,
        child: Wrap(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(
                horizontal: SizeUtils.basePaddingMargin16,
              ),
              child: Text(
                "${cubit.currentIndex! + 1}/${data.length}",
                style: GoogleFonts.nunito(
                  fontSize: SizeUtils.baseTextSize12,
                  color: AppColors.black60,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            contentPhotosWidget(cubit),
          ],
        ),
      );
    }

    // if (widget.labelTextDownload != null && widget.nameFileDownload != null) {
    //   return ButtonInfoOutlineLg(
    //     margin: 16,
    //     title: widget.labelTextDownload,
    //     action: () {
    //       cubit.downloadImage(nameDownload: widget.nameFileDownload!);
    //     },
    //     active: cubit.isActiveButton,
    //     withIcon: true,
    //     icon: Container(
    //       margin: const EdgeInsets.only(right: SizeUtils.basePaddingMargin8),
    //       child: ImageSvgAssetRectangle(
    //         imageUrl: "assets/icons/ic_insert.svg",
    //       ),
    //     ),
    //   );
    // }

    return null;
  }

  Widget contentPhotosWidget(ImageViewerCubit cubit) {
    var data = cubit.imagesUrl;

    return Container(
      height: SizeUtils.baseWidthHeight70,
      alignment: widget.alignmentPhotos,
      margin: const EdgeInsets.only(
        top: SizeUtils.basePaddingMargin8,
        bottom: SizeUtils.basePaddingMargin32,
        left: SizeUtils.basePaddingMargin16,
      ),
      child: ListView.builder(
        controller: cubit.scrollController,
        itemCount: data.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              cubit.changeImage(index: index);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                (cubit.currentIndex == index)
                    ? Container(
                        width: SizeUtils.baseWidthHeight70,
                        height: SizeUtils.baseWidthHeight70,
                        margin: const EdgeInsets.only(
                            right: SizeUtils.basePaddingMargin6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 3,
                            color: AppColors.blue50,
                          ),
                          borderRadius: BorderRadius.circular(
                            SizeUtils.baseRoundedCorner,
                          ),
                        ),
                      )
                    : Container(),
                Container(
                  margin: const EdgeInsets.only(
                    right: SizeUtils.basePaddingMargin6,
                  ),
                  decoration: BoxDecoration(
                    border: (cubit.currentIndex == index)
                        ? Border.all(
                            width: 1,
                            color: AppColors.blue50,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(
                      SizeUtils.baseRoundedCorner,
                    ),
                  ),
                  width: SizeUtils.baseWidthHeight66,
                  height: SizeUtils.baseWidthHeight66,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      SizeUtils.baseRoundedCorner,
                    ),
                    child: ImageNetworkRectangle(
                      imageUrl: cubit.imagesUrl[index],
                      boxFit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                (cubit.currentIndex != index)
                    ? Container(
                        margin: const EdgeInsets.only(
                          right: SizeUtils.basePaddingMargin6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey60,
                          borderRadius: BorderRadius.circular(
                            SizeUtils.baseRoundedCorner,
                          ),
                        ),
                        width: SizeUtils.baseWidthHeight66,
                        height: SizeUtils.baseWidthHeight66,
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
