import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/utils/helpers/general_helpers.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/custom_date_picker/custom_date_picker.dart';
import 'package:hc_management_app/shared/widgets/image/image_asset_button.dart';
import 'package:hc_management_app/shared/widgets/image/image_file_rectangle.dart';
import 'package:hc_management_app/shared/widgets/image/image_memory_rectangle.dart';
import 'package:hc_management_app/shared/widgets/image/image_network_rectangle.dart';
import 'package:hc_management_app/shared/widgets/image/image_svg_asset_rectangle.dart';


Widget customHorizontalDivider({
  double? height,
  Color? color,
  double? thickness,
}) {
  return Divider(
    height: height,
    color: color ?? AppColors.grey400,
    thickness: thickness,
  );
}


showDetailImage({
  required BuildContext? context,
  required String? imageUrl,
  File? imagePath,
  bool? isImageFile = false,
  bool? isImageMemory = false,
  double size = 0.96,
}) {
  return showModalBottomSheet(
    context: context!,
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
        maxChildSize: size,
        minChildSize: size,
        initialChildSize: size,
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
                    Text("Detail Foto",
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
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  panEnabled: false,
                  clipBehavior: Clip.none,
                  child: isImageFile!
                      ? ImageFileRectangle(
                          width: MediaQuery.of(context).size.width,
                          imageUrl: imagePath,
                          alignment: Alignment.center,
                          boxFit: BoxFit.cover,
                        )
                      : isImageMemory!
                          ? ImageMemoryRectangle(
                              width: MediaQuery.of(context).size.width,
                              imageUrl: imageUrl,
                              alignment: Alignment.center,
                              boxFit: BoxFit.cover,
                            )
                          : ImageNetworkRectangle(
                              width: MediaQuery.of(context).size.width,
                              imageUrl: imageUrl,
                              alignment: Alignment.center,
                              boxFit: BoxFit.cover,
                            ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> openCustomDatePicker(
  BuildContext context,
  String bottomSheetLabel,
  TextEditingController controller, {
  bool isDateRange = false,
  DateTime? firstDate,
  DateTime? lastDate,
  List<Month>? enableDays,
  Function(bool)? closeDatePicker,
}) async {
  GeneralHelper generalHelper = GeneralHelper();
  List<DateTime> initialDate = [];
  if (controller.text.isNotEmpty) {
    var listOfDate = controller.text.split(" - ");
    initialDate.clear();
    if (listOfDate.length > 1) {
      initialDate = [
        generalHelper.convertStringToDate(
          dateFormat: "dd MMMM yyyy",
          stringDate: listOfDate[0],
        )!,
        generalHelper.convertStringToDate(
          dateFormat: "dd MMMM yyyy",
          stringDate: listOfDate[1],
        )!,
      ];
    } else {
      initialDate = [
        generalHelper.convertStringToDate(
          dateFormat: "dd MMMM yyyy",
          stringDate: controller.text,
        )!,
      ];
    }
  }

  // Default height for bottomSheet is half the screenSize
  // To make bottomSheet to expand according to your content dynamically
  // use Wrap for it
  return showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    enableDrag: false,
    barrierColor: AppColors.grey600?.withOpacity(0.6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeUtils.baseRoundedCorner),
        topRight: Radius.circular(SizeUtils.baseRoundedCorner),
      ),
    ),
    builder: (context) => SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Wrap(
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
                Text(bottomSheetLabel),
                ImageAssetButton(
                  width: SizeUtils.baseWidthHeight30,
                  height: SizeUtils.baseWidthHeight30,
                  imageUrl: "assets/icons/ic_close.svg",
                  action: () {
                    if (closeDatePicker != null) {
                      closeDatePicker(true);
                    }

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          customHorizontalDivider(height: 1),

          // Custom date picker
          CustomDatePicker(
            config: setCustomDatePickerConfig(context,
                isDateRange: isDateRange,
                firstDate: firstDate,
                lastDate: lastDate,
                enableDays: enableDays),
            initialValue: initialDate,
            onValueChanged: (date) {
              if (!isDateRange) {
                controller.text = generalHelper.convertSingleOrRangeDate(
                  value: date,
                )!;
                Navigator.pop(context);
              } else {
                if (date.length > 1) {
                  Future.delayed(const Duration(seconds: 1)).then(
                    (_) {
                      controller.text = generalHelper.convertSingleOrRangeDate(
                        value: date,
                      )!;
                      Navigator.pop(context);
                    },
                  );
                }
              }
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}

class Month extends Equatable {
  final int? id;
  final int? day;

  const Month({required this.id, required this.day});

  @override
  List<Object?> get props => [id, day];
}

Future<void> showCustomBottomSheet({
  required BuildContext context,
  required String? title,
  double? maxHeight,
  Widget? bodyContent,
  Widget? bottomContent,
  bool? withCloseButton,
  String? titleIcon,
  bool? withHeaderLine,
  bool? canPop,
  EdgeInsetsGeometry? marginBodyContent,
}) async {
  final screenHeight = MediaQuery.of(context).size.height;

  return showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeUtils.baseRoundedCorner),
        topRight: Radius.circular(SizeUtils.baseRoundedCorner),
      ),
    ),
    enableDrag: false,
    isDismissible: false,
    isScrollControlled: true,
    builder: (context) => PopScope(
      canPop: canPop ?? true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxHeight ?? screenHeight * 0.6,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: (withHeaderLine ?? false)
                        ? const EdgeInsets.symmetric(
                            horizontal: SizeUtils.basePaddingMargin16,
                          )
                        : const EdgeInsets.only(
                            top: SizeUtils.basePaddingMargin24,
                            left: SizeUtils.basePaddingMargin16,
                            right: SizeUtils.basePaddingMargin16,
                            bottom: SizeUtils.basePaddingMargin16,
                          ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: titleIcon != null,
                          child: ImageSvgAssetRectangle(
                            imageUrl: titleIcon,
                            width: SizeUtils.baseWidthHeight22,
                            height: SizeUtils.baseWidthHeight22,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: titleIcon != null
                                ? const EdgeInsets.symmetric(
                                    horizontal: SizeUtils.basePaddingMargin16,
                                  )
                                : EdgeInsets.zero,
                            child: Text(
                              title!,
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: withCloseButton ?? false,
                          child: IconButton(
                            alignment: Alignment.centerRight,
                            icon: const ImageSvgAssetRectangle(
                              width: SizeUtils.baseWidthHeight14,
                              height: SizeUtils.baseWidthHeight14,
                              alignment: Alignment.centerRight,
                              imageUrl: "assets/icons/ic_close.svg",
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: withHeaderLine ?? false,
                    child: customHorizontalDivider(
                      color: AppColors.grey300,
                      height: SizeUtils.baseWidthHeight2,
                    ),
                  ),

                  // Body content
                  Flexible(
                    child: Container(
                      margin: marginBodyContent ??
                          EdgeInsets.only(
                            top: (withHeaderLine ?? false)
                                ? SizeUtils.basePaddingMargin8
                                : 0,
                            right: SizeUtils.basePaddingMargin16,
                            left: titleIcon != null
                                ? SizeUtils.basePaddingMargin53
                                : SizeUtils.basePaddingMargin16,
                          ),
                      padding: const EdgeInsets.only(
                        bottom: SizeUtils.basePaddingMargin14,
                      ),
                      child: bodyContent,
                    ),
                  ),

                  // Bottom content
                  Column(
                    children: [
                      customHorizontalDivider(
                        color: AppColors.grey300,
                        height: 1,
                      ),
                      bottomContent ?? const SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

AppBar customAppBar({
  required String? title,
  required String? subTitle,
  required int indexTabController,
  required TabController controller,
  required List<String> labelTab,
  required int items,
  ValueChanged<int>? onTap,
  SystemUiOverlayStyle? systemUiOverlayStyle,
  Widget? leading,
}) {
  return AppBar(
    // centerTitle: true,
    backgroundColor: AppColors.transparent,
    iconTheme: IconThemeData(color: AppColors.black),
    leading: leading,
    systemOverlayStyle: systemUiOverlayStyle ?? SystemUiOverlayStyle.dark,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        spaceHeight(
          height: 8,
        ),
        Text(
          subTitle!,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(SizeUtils.baseWidthHeight56),
      child: Semantics(
        label: "tab-bar-submission",
        onTap: () {
          controller.animateTo(1);
        },
        child: ExcludeSemantics(
          child: TabBar(
            controller: controller,
            labelPadding: EdgeInsets.zero,
            indicatorColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
                horizontal: SizeUtils.basePaddingMargin8),
            tabs: [
              for (int i = 0; i < items; i++) ...[
                Container(
                  margin: indexTabController == i
                      ? EdgeInsets.zero
                      : const EdgeInsets.only(
                          top: SizeUtils.basePaddingMargin8),
                  height: indexTabController == i
                      ? SizeUtils.baseWidthHeight40
                      : SizeUtils.baseWidthHeight32,
                  decoration: BoxDecoration(
                    color: indexTabController == i
                        ? AppColors.white
                        : AppColors.shadeBlue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(SizeUtils.baseRoundedCorner),
                      topRight: Radius.circular(SizeUtils.baseRoundedCorner),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      labelTab[i],
                      style: GoogleFonts.nunito(
                        color: indexTabController == i
                            ? AppColors.primary
                            : AppColors.third,
                        fontWeight: indexTabController == i
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ]
            ],
            onTap: onTap,
          ),
        ),
      ),
    ),
  );
}
