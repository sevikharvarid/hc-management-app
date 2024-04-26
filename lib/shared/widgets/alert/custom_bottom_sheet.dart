import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/utils/helpers/month_pickers.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_widget.dart';

class CustomBottomSheet {
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
      builder: (context) => LayoutBuilder(
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
                            vertical: SizeUtils.basePaddingMargin16,
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
                          child: SvgPicture.asset(
                            titleIcon!,
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
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: withCloseButton ?? false,
                          child: IconButton(
                            alignment: Alignment.centerRight,
                            icon: Icon(Icons.close, color: AppColors.black),
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
                      margin: EdgeInsets.only(
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
    );
  }

  Future<void> openRequestTypePicker(
    BuildContext context,
    String bottomSheetLabel,
    TextEditingController controller,
    List<String> stringList,
  ) async {
    return showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: true,
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
                  Text(
                    bottomSheetLabel,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close, color: AppColors.black),
                  ),
                ],
              ),
            ),
            customHorizontalDivider(height: SizeUtils.baseWidthHeight1),

            //Reason List
            Container(
              padding:
                  const EdgeInsets.only(bottom: SizeUtils.basePaddingMargin16),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: stringList.length,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => const Divider(
                  height: SizeUtils.baseWidthHeight1,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    highlightColor: AppColors.shadeBlue,
                    onTap: () {
                      controller.text = stringList[index];
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: controller.text == stringList[index]
                          ? AppColors.shadeBlue
                          : AppColors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: SizeUtils.basePaddingMargin16,
                        vertical: SizeUtils.basePaddingMargin8,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          controller.text = stringList[index];
                          Navigator.pop(context);
                        },
                        child: Text(
                          stringList[index],
                          style: GoogleFonts.nunito(
                            fontWeight: controller.text == stringList[index]
                                ? FontWeight.w500
                                : FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: SizeUtils.baseWidthHeight200),
          ],
        ),
      ),
    );
  }

  Future<void> openCustomMonthPicker({
    required BuildContext? context,
    required String? bottomSheetLabel,
    required TextEditingController? controller,
  }) async {
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
                  Text(
                    bottomSheetLabel!,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  )
                ],
              ),
            ),
            customHorizontalDivider(height: 1),

            // Month picker list
            Container(
              margin: const EdgeInsets.only(top: SizeUtils.basePaddingMargin8),
              padding: const EdgeInsets.only(
                bottom: SizeUtils.basePaddingMargin16,
              ),
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    customHorizontalDivider(height: 1),
                itemCount: getFilteredMonth(context: context)!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    highlightColor: AppColors.shadeBlue,
                    onTap: () {
                      controller.text =
                          getFilteredMonth(context: context)![index];
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: controller!.text ==
                              getFilteredMonth(context: context)![index]
                          ? AppColors.shadeBlue
                          : AppColors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: SizeUtils.basePaddingMargin16,
                        vertical: SizeUtils.basePaddingMargin10,
                      ),
                      child: GestureDetector(
                        // here using gesture detector because on test project
                        // cannot detect when just using listview
                        onTap: () {
                          controller.text =
                              getFilteredMonth(context: context)![index];
                          Navigator.pop(context);
                        },
                        child: Text(
                          getFilteredMonth(context: context)![index],
                          style: GoogleFonts.nunito(
                            fontWeight: controller.text ==
                                    getFilteredMonth(context: context)![index]
                                ? FontWeight.w500
                                : FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
