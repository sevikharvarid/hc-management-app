library custom_widget;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_list_view.dart';
import 'package:hc_management_app/shared/widgets/custom_widget/custom_widget.dart';
import 'package:hc_management_app/shared/widgets/text_field/input_text_field_default.dart';

class DropdownWithSearchWidget extends StatefulWidget {
  final String? label, textHint, bottomSheetLabel, accessibilityId;
  final GestureTapCallback? onTap;
  final TextEditingController searchController;
  final double? width, height;

  const DropdownWithSearchWidget({
    Key? key,
    this.label,
    this.accessibilityId,
    this.width,
    this.height,
    required this.textHint,
    required this.bottomSheetLabel,
    required this.searchController,
    required this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => DropdownWithSearchPageState();
}

class DropdownWithSearchPageState extends State<DropdownWithSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      excludeSemantics: true,
      label: widget.label ??
          widget.textHint ??
          widget.bottomSheetLabel ??
          widget.accessibilityId,
      child: SizedBox(
        height: widget.height ?? SizeUtils.baseWidthHeight44,
        width: widget.width ?? MediaQuery.of(context).size.width * 0.43,
        child: TextFormField(
          readOnly: true,
          onTap: widget.onTap,
          controller: widget.searchController,
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: SizeUtils.baseTextSize14,
          ),
          decoration: InputDecoration(
            filled: true,
            isDense: true,
            hintText: widget.textHint ?? '',
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: SizeUtils.basePaddingMargin12,
            ),
            suffixIcon: SizedBox(
                height: SizeUtils.baseWidthHeight44,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.black,
                )),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.neutral5, width: 1),
              borderRadius:
                  BorderRadius.circular(SizeUtils.baseRoundedCorner * 5),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.neutral5, width: 1),
              borderRadius:
                  BorderRadius.circular(SizeUtils.baseRoundedCorner * 5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.neutral5, width: 1),
              borderRadius:
                  BorderRadius.circular(SizeUtils.baseRoundedCorner * 5),
            ),
          ),
        ),
      ),
    );
  }
}

Widget openDropdownMenuWithSearch({
  required BuildContext? context,
  required String? searchHint,
  required String? bottomSheetTitle,
  required String? emptyMessage,
  required int? itemCount,
  required TextEditingController searchController,
  required Widget Function(BuildContext context, int index)? itemBuilder,
  Widget? searchWidget,
  bool? withButton = false,
  bool? isButtonActive = false,
  Function()? onButtonTap,
  required ScrollController scrollController,
}) {
  var height = MediaQuery.of(context!).size.height;
  return LayoutBuilder(
    builder: (context, constraint) {
      return Container(
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: constraint.maxHeight > height * 0.6
                  ? height * 0.6
                  : constraint.maxHeight,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              //   Header
              Container(
                height: SizeUtils.baseWidthHeight56,
                padding: const EdgeInsets.symmetric(
                  horizontal: SizeUtils.basePaddingMargin16,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          bottomSheetTitle!,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          searchController.clear();
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: AppColors.black,
                        ),
                      ),
                    ]),
              ),
              customHorizontalDivider(height: SizeUtils.baseWidthHeight1),

              searchWidget ??
                  Container(
                    margin: const EdgeInsets.all(SizeUtils.basePaddingMargin16),
                    child: InputTextFieldDefault(
                      hint: searchHint,
                      inputType: TextInputType.text,
                      height: SizeUtils.baseWidthHeight44,
                      hintFontSize: SizeUtils.baseWidthHeight14,
                      controller: searchController,
                      onChanged: (String value) {},
                      onEditComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      suffixWidget: Container(
                          width: SizeUtils.baseWidthHeight16,
                          height: SizeUtils.baseWidthHeight16,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.close,
                            color: AppColors.black,
                          )),
                    ),
                  ),

              // Data list
              Flexible(
                child: Container(
                  margin:
                      const EdgeInsets.only(top: SizeUtils.basePaddingMargin8),
                  child: NotificationListener<ScrollNotification>(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          CustomListView(
                            shrinkWrap: true,
                            withHorizontalDivider: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: itemCount!,
                            itemBuilder: itemBuilder,
                            emptyMessage: emptyMessage!,
                          ),
                          // if (isPaginating)
                          //   Container(
                          //     margin: const EdgeInsets.only(
                          //       left: SizeUtils.basePaddingMargin18,
                          //       right: SizeUtils.basePaddingMargin18,
                          //       bottom: SizeUtils.basePaddingMargin18,
                          //     ),
                          //     child: loadingProgress(),
                          //   ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              withButton!
                  ? CustomButton(
                      margin: SizeUtils.basePaddingMargin16,
                      title: "Finish",
                      action: onButtonTap,
                      withIcon: false,
                      active: isButtonActive,
                    )
                  : const SizedBox(),
            ]),
          ),
        ),
      );
    },
  );
}

Widget loadingProgress() => const SizedBox(
      height: SizeUtils.basePadding * 4,
      child: Center(
        child: SizedBox(
          height: SizeUtils.baseWidthHeight30,
          width: SizeUtils.baseWidthHeight30,
          child: CircularProgressIndicator(),
        ),
      ),
    );
