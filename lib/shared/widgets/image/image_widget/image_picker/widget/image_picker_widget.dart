library custom_image;

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/button/button_danger_lg.dart';
import 'package:hc_management_app/shared/widgets/button/button_info_outline_lg.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_widget.dart';
import 'package:hc_management_app/shared/widgets/file/file_picker_progress.dart';
import 'package:hc_management_app/shared/widgets/image/image_asset_button.dart';
import 'package:hc_management_app/shared/widgets/image/image_svg_asset_rectangle.dart';
import 'package:hc_management_app/shared/widgets/image/image_widget/image_picker/bloc/image_picker_cubit.dart';
import 'package:hc_management_app/shared/widgets/image/image_widget/image_picker/bloc/image_picker_state.dart';

enum ImagePickerTypeEnum {
  single,
  multiple,
}

class ImagePickerWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final Function(List<File>? value)? onImageChanged;
  final int? minimumImage;
  final int? maximumImage;
  final int? quality;
  final bool? mandatory;
  final String? label;
  final String? accessibilityId;
  final String? imageName;
  final ImagePickerTypeEnum imagePickerType;
  final List<File>? pickedImage;
  final int? objectKey;
  final String? userName;
  final String? storeName;
  final String? notes;

  const ImagePickerWidget({
    super.key,
    this.width,
    this.height,
    required this.onImageChanged,
    this.maximumImage,
    this.minimumImage = 1,
    this.quality,
    this.mandatory = false,
    this.imagePickerType = ImagePickerTypeEnum.single,
    required this.label,
    required this.imageName,
    this.pickedImage,
    this.objectKey,
    this.accessibilityId,
    this.userName = '',
    this.storeName = '',
    this.notes = '',
  });

  @override
  State<ImagePickerWidget> createState() => ImagePickerWidgetState();
}

class ImagePickerWidgetState extends State<ImagePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ObjectKey(widget.objectKey),
      create: (context) =>
          ImagePickerCubit()..setPickedImage(widget.pickedImage),
      child: BlocConsumer<ImagePickerCubit, ImagePickerState>(
        listener: (context, state) {
          final cubit = context.read<ImagePickerCubit>();
          if (state is ImagePickerUploaded) {
            widget.onImageChanged!.call(cubit.pickedImageFile);
          }
          if (state is ImagePickerDeleted) {
            widget.onImageChanged!.call(cubit.pickedImageFile);
          }

          if (state is ImagePickerRejected) {
            showCustomBottomSheet(
              context: context,
              title: "Upload Gagal",
              titleIcon: "assets/icons/ic_caution_red.svg",
              bodyContent: Text(
                "Ukuran file lebih dari 5 MB",
                style: GoogleFonts.nunito(
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
              bottomContent: ButtonInfoOutlineLg(
                margin: SizeUtils.basePaddingMargin16,
                title: "OK",
                withIcon: false,
                active: true,
                action: () => Navigator.pop(context),
              ),
            );
          }
        },
        builder: (context, state) {
          if (widget.imagePickerType == ImagePickerTypeEnum.multiple) {
            return buildMultipleGridImage(
              context,
              imageName: widget.imageName!,
            );
          }

          return buildSingleImage(
            context: context,
            imageName: widget.imageName!,
          );
        },
      ),
    );
  }

  Widget buildMultipleGridImage(
    BuildContext context, {
    bool? rejected = false,
    String? fileName,
    String? errorMessage,
    String? imageName,
  }) {
    var cubit = context.read<ImagePickerCubit>();
    Color requiredColor = AppColors.black40;

    String imageRequirementLabel = "Maximal 5mb";
    if (widget.mandatory!) {
      imageRequirementLabel = "Maximal 5mb"
          " | Min ${widget.minimumImage}, Max ${widget.maximumImage} Foto";
    }

    if (widget.maximumImage == null) {
      imageRequirementLabel =
          "Maximal 5mb" " | Min ${widget.minimumImage} Foto";
      requiredColor = AppColors.black40;
    }

    int itemCount = cubit.pickedImageIsUploading!.length + 1;
    if (widget.maximumImage != null &&
        (cubit.pickedImageIsUploading!.length == widget.maximumImage!)) {
      itemCount = widget.maximumImage!;
    }

    if (cubit.pickedImageFile!.isNotEmpty &&
        cubit.pickedImageFile!.length < widget.minimumImage!) {
      requiredColor = AppColors.redText;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if ((widget.maximumImage == null ||
                    cubit.pickedImageIsUploading!.length <
                        widget.maximumImage!) &&
                index == 0) {
              return Container(
                margin: const EdgeInsets.only(
                  right: SizeUtils.basePaddingMargin8,
                  bottom: SizeUtils.basePaddingMargin8,
                ),
                child: imagePickerCard(context: context),
              );
            }

            // reverse picked image index for multiple image
            // if not reversed new picked image will ordered in
            // end of horizontal list
            int reversedIndex = itemCount - 1 - index;
            bool isLoading = cubit.pickedImageIsUploading![reversedIndex];

            return Semantics(
              excludeSemantics: true,
              label: "${widget.accessibilityId} - ${reversedIndex + 1}",
              child: Container(
                margin: const EdgeInsets.only(
                  right: SizeUtils.basePaddingMargin8,
                  bottom: SizeUtils.basePaddingMargin8,
                ),
                child: isLoading
                    ? const FilePickerProgress()
                    : selectedImageCard(
                        context,
                        index: reversedIndex,
                        imageName: imageName!,
                      ),
              ),
            );
          },
        ),
        Text(
          imageRequirementLabel,
          style: GoogleFonts.nunito(
            color: requiredColor,
          ),
        ),
      ],
    );
  }

  Widget buildSingleImage({
    required BuildContext context,
    String? imageName,
  }) {
    final cubit = context.read<ImagePickerCubit>();
    Color requiredColor = AppColors.black40;
    if (cubit.pickedImageFile!.isNotEmpty &&
        cubit.pickedImageFile!.length < widget.minimumImage!) {
      requiredColor = AppColors.redText;
    }

    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cubit.pickedImageFile!.isEmpty &&
                  cubit.pickedImageIsUploading!.isEmpty
              ? imagePickerCard(context: context, index: 0)
              : cubit.pickedImageIsUploading![0]
                  ? const FilePickerProgress()
                  : selectedImageCard(context, index: 0, imageName: imageName!),
          const SizedBox(height: SizeUtils.baseWidthHeight12),
          Text("Maximal 5 Mb",
              style: GoogleFonts.nunito(
                color: requiredColor,
              )),
        ],
      ),
    );
  }

  Widget imagePickerCard({
    required BuildContext context,
    int? index,
  }) {
    var cubit = context.read<ImagePickerCubit>();
    return Semantics(
      excludeSemantics: true,
      label: widget.accessibilityId,
      child: GestureDetector(
        onTap: () {
          // checking maximum image picker count
          if (widget.maximumImage != null &&
              cubit.pickedImageFile!.length < widget.maximumImage!) {
            openImagePicker(context: context, index: index);
          } else {
            openImagePicker(context: context, index: index);
          }
        },
        child: DottedBorder(
          strokeWidth: 1,
          dashPattern: const [3, 3],
          color: AppColors.neutral5,
          borderType: BorderType.RRect,
          radius: const Radius.circular(5),
          child: SizedBox(
            width: widget.width ?? SizeUtils.baseWidthHeight105,
            height: widget.height ?? SizeUtils.baseWidthHeight105,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ImageSvgAssetRectangle(
                  imageUrl: "assets/icons/ic_add_square.svg",
                  alignment: Alignment.center,
                ),
                const SizedBox(height: SizeUtils.baseWidthHeight14),
                Text(
                  "Upload",
                  style: GoogleFonts.nunito(
                    color: AppColors.black.withOpacity(0.45),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imagePickerSourceWidget({
    String? label,
    String? imageUrl,
    Function()? action,
    Color? textColor,
  }) {
    return InkWell(
      highlightColor: AppColors.shadeBlue,
      onTap: action,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SizeUtils.basePaddingMargin16,
          vertical: SizeUtils.basePaddingMargin10,
        ),
        child: GestureDetector(
          onTap: action,
          child: Row(
            children: [
              ImageSvgAssetRectangle(
                imageUrl: imageUrl,
              ),
              const SizedBox(width: SizeUtils.basePaddingMargin8),
              Text(
                label!,
                style: GoogleFonts.nunito(
                  color: textColor ?? AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> openImagePicker({
    required BuildContext context,
    bool? hasImage = false,
    int? index,
  }) {
    var cubit = context.read<ImagePickerCubit>();

    String? fileName;
    if (index != null && cubit.pickedImageFile!.isNotEmpty) {
      fileName = cubit.pickedImageName![index];
    }

    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      barrierColor: AppColors.grey600?.withOpacity(0.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeUtils.baseRoundedCorner),
          topRight: Radius.circular(SizeUtils.baseRoundedCorner),
        ),
      ),
      builder: (context) => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Wrap(children: [
          // Header
          Container(
            height: SizeUtils.baseWidthHeight56,
            padding: const EdgeInsets.symmetric(
              horizontal: SizeUtils.basePaddingMargin16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hasImage! ? "Edit" : widget.label!,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Semantics(
                  excludeSemantics: true,
                  label: "Close",
                  child: ImageAssetButton(
                    width: SizeUtils.baseWidthHeight30,
                    height: SizeUtils.baseWidthHeight30,
                    imageUrl: "assets/icons/ic_close.svg",
                    action: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
          customHorizontalDivider(height: SizeUtils.baseWidthHeight1),

          // Image picker list
          Container(
            margin: const EdgeInsets.only(top: SizeUtils.basePaddingMargin8),
            padding:
                const EdgeInsets.only(bottom: SizeUtils.basePaddingMargin16),
            child: Column(children: [
              // pick image from gallery
              imagePickerSourceWidget(
                label: "Pilih dari Gallery",
                imageUrl: "assets/icons/ic_camera.svg",
                action: () {
                  cubit.openImagePicker(
                    index: index,
                    camera: false,
                    quality: widget.quality,
                    userName: widget.userName,
                    storeName: widget.storeName,
                    notes: widget.notes,
                  );
                  Navigator.pop(context);
                },
              ),
              customHorizontalDivider(height: SizeUtils.baseWidthHeight1),

              // pick image from camera
              imagePickerSourceWidget(
                label: "Ambil Gambar",
                imageUrl: "assets/icons/ic_camera.svg",
                action: () {
                  cubit.openImagePicker(
                    index: index,
                    camera: true,
                    quality: widget.quality,
                    userName: widget.userName,
                    storeName: widget.storeName,
                    notes: widget.notes,
                  );
                  Navigator.pop(context);
                },
              ),

              // if image is picked , showing delete option
              hasImage
                  ? Column(children: [
                      customHorizontalDivider(
                        height: SizeUtils.baseWidthHeight1,
                      ),
                      imagePickerSourceWidget(
                          label: "Delete",
                          textColor: AppColors.characterDanger,
                          imageUrl: "assets/icons/ic_trash_red.svg",
                          action: () {
                            Navigator.pop(context);
                            showModalBottomSheet(
                              context: context,
                              isDismissible: true,
                              barrierColor: AppColors.grey600?.withOpacity(0.6),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    SizeUtils.baseRoundedCorner,
                                  ),
                                  topRight: Radius.circular(
                                    SizeUtils.baseRoundedCorner,
                                  ),
                                ),
                              ),
                              builder: (context) => Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                  top: SizeUtils.basePaddingMargin24,
                                  bottom: SizeUtils.basePaddingMargin16,
                                ),
                                child: Wrap(children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: SizeUtils.basePaddingMargin16,
                                    ),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.topCenter,
                                            width: SizeUtils.baseWidthHeight22,
                                            child: const ImageSvgAssetRectangle(
                                              alignment: Alignment.topCenter,
                                              imageUrl:
                                                  "assets/icons/ic_caution_red.svg",
                                            ),
                                          ),
                                          const SizedBox(
                                            width:
                                                SizeUtils.basePaddingMargin16,
                                          ),
                                          Flexible(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Hapus gambar",
                                                    style: GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: SizeUtils
                                                          .baseTextSize16,
                                                      height: 1.35,
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      vertical: SizeUtils
                                                          .basePaddingMargin16,
                                                    ),
                                                    child: Text(
                                                      // lineHeight: 1.5,

                                                      """${"Anda yaking ingin menghapus"} $fileName "?""",
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        ]),
                                  ),
                                  customHorizontalDivider(
                                      height: SizeUtils.baseWidthHeight1),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: SizeUtils.basePaddingMargin16,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal:
                                            SizeUtils.basePaddingMargin16,
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ButtonInfoOutlineLg(
                                              margin: 0,
                                              title: "Batalkan",
                                              withIcon: false,
                                              active: true,
                                              borderWidth: 1,
                                              buttonWidth:
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.43,
                                              outlineColor: AppColors.primary,
                                              textColor: AppColors.primary,
                                              action: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            ButtonDangerLg(
                                                margin: 0,
                                                title: "Ya, saya yakin",
                                                withIcon: false,
                                                active: true,
                                                buttonWidth:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.43,
                                                backgroundColor:
                                                    AppColors.characterDanger,
                                                action: () {
                                                  cubit.deleteImage(
                                                      index: index);
                                                  Navigator.pop(context);
                                                }),
                                          ]),
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          }),
                    ])
                  : const SizedBox(),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget selectedImageCard(
    BuildContext context, {
    int? index,
    String? imageName,
  }) {
    return Semantics(
      excludeSemantics: true,
      label: widget.accessibilityId,
      child: GestureDetector(
        onTap: () {
          showDetailImage(context, indexImage: index);
        },
        child: Container(
          width: widget.width ?? SizeUtils.baseWidthHeight110,
          height: widget.height ?? SizeUtils.baseWidthHeight110,
          padding: const EdgeInsets.all(SizeUtils.basePaddingMargin8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: AppColors.neutral5),
          ),
          child: Image.file(
            context.read<ImagePickerCubit>().pickedImageFile![index!],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  showDetailImage(
    BuildContext context, {
    int? indexImage,
  }) {
    var cubit = context.read<ImagePickerCubit>();
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isScrollControlled: true,
      barrierColor: AppColors.grey600?.withOpacity(0.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeUtils.baseRoundedCorner),
          topRight: Radius.circular(SizeUtils.baseRoundedCorner),
        ),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.75,
          minChildSize: 0.75,
          initialChildSize: 0.75,
          builder: (_, scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Header
                Container(
                  height: SizeUtils.baseWidthHeight56,
                  padding: const EdgeInsets.symmetric(
                    horizontal: SizeUtils.basePaddingMargin16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.label!,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w500,
                          )),
                      ImageAssetButton(
                        width: SizeUtils.baseWidthHeight30,
                        height: SizeUtils.baseWidthHeight30,
                        imageUrl: "assets/icons/ic_close.svg",
                        action: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                customHorizontalDivider(height: SizeUtils.baseWidthHeight1),

                // Body
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: SizeUtils.basePadding),
                    shrinkWrap: true,
                    children: [
                      InteractiveViewer(
                        minScale: 1,
                        maxScale: 4,
                        panEnabled: false,
                        clipBehavior: Clip.none,
                        child: cubit.pickedImageFile!.isNotEmpty &&
                                indexImage! < cubit.pickedImageFile!.length
                            ? Image.file(
                                cubit.pickedImageFile![indexImage],
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container();
                                },
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),

                // Action button
                Container(
                  color: AppColors.white,
                  padding: const EdgeInsets.all(SizeUtils.basePaddingMargin16),
                  child: ButtonInfoOutlineLg(
                    margin: 0,
                    title: "Ubah Gambar",
                    withIcon: false,
                    fontSize: SizeUtils.baseTextSize16,
                    active: true,
                    borderWidth: 1,
                    outlineColor: AppColors.primary,
                    textColor: AppColors.primary,
                    action: () {
                      Navigator.pop(context);
                      openImagePicker(
                        context: context,
                        hasImage: true,
                        index: indexImage,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
