library custom_widget;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_widget.dart';
import 'package:intl/intl.dart';

// Get date format based on localization
DateFormat getDateFormat(BuildContext context) {
  return DateFormat(
    "MMMM yyyy",
    "id_ID",
  );
}

// Get current date
DateTime currentDate = DateTime.now();

// Get last tree month from now
List<String>? getFilteredMonth({
  required BuildContext context,
  int rangeOfMonth = 5,
}) {
  final filteredMonth = <String>[];
  for (var i = 0; i < rangeOfMonth; i++) {
    filteredMonth.add(
      getDateFormat(context).format(
        DateTime(currentDate.year, currentDate.month - i),
      ),
    );
  }
  return filteredMonth;
}

// Get initial month (current month)
String? initialMonth(BuildContext context) {
  return getDateFormat(context)
      .format(DateTime(currentDate.year, currentDate.month))
      .toString();
}

// Default height for bottomSheet is half the screenSize
// To make bottomSheet to expand according to your content dynamically
// use Wrap for it
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
                    fontSize: 20,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: AppColors.black,
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
                          fontSize: 16,
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
