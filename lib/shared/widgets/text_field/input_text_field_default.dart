import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';

class InputTextFieldDefault extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint, errorMessage, accessibilityId;
  final TextInputType? inputType;
  final VoidCallback? onEditComplete;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatter;
  final FocusNode? focusNode;
  final VoidCallback? onFieldSubmitted;
  final VoidCallback? onPressedSuffixIcon;
  final double? width, height, hintFontSize;
  final TextCapitalization textCapitalization;
  final bool? enabled;
  final bool? autoFocus;
  final EdgeInsetsGeometry? margin;
  final bool? filled;
  final Color? fillColor;
  final Color? textColor;
  final bool? withSuffixIcon, readOnly;
  final Widget? suffixWidget;
  final GestureTapCallback? onTap;
  final bool? isTyping;
  final TextInputAction? textInputAction;

  const InputTextFieldDefault({
    super.key,
    required this.controller,
    required this.hint,
    this.inputType,
    this.accessibilityId,
    this.inputFormatter,
    this.onEditComplete,
    this.errorMessage,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.onFieldSubmitted,
    this.onPressedSuffixIcon,
    this.width,
    this.height,
    this.hintFontSize,
    this.textCapitalization = TextCapitalization.none,
    this.enabled,
    this.autoFocus,
    this.margin,
    this.filled,
    this.fillColor,
    this.textColor,
    this.withSuffixIcon = true,
    this.readOnly = false,
    this.suffixWidget,
    this.onTap,
    this.isTyping = false,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      onSetText: (text) {
        controller!.text = text;
      },
      excludeSemantics: true,
      label: accessibilityId ?? hint,
      child: Container(
        margin: margin,
        width: width ?? MediaQuery.of(context).size.width,
        height: height,
        child: Container(
          child: TextFormField(
            controller: controller,
            keyboardType: inputType,
            enabled: enabled ?? true,
            autofocus: autoFocus ?? false,
            inputFormatters: inputFormatter,
            textCapitalization: textCapitalization,
            textInputAction: textInputAction,
            maxLines: 1,
            style: TextStyle(color: textColor, height: 1),
            onEditingComplete: onEditComplete ??
                () {
                  FocusScope.of(context).unfocus();
                },
            validator: validator ??
                (value) {
                  if (value == null || value.isEmpty) {
                    return errorMessage;
                  }

                  return null;
                },
            onChanged: onChanged ?? (value) {},
            readOnly: readOnly!,
            onTap: onTap,
            decoration: InputDecoration(
                isDense: true,
                hintText: "$hint",
                filled: filled,
                fillColor: fillColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: SizeUtils.basePaddingMargin12,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(SizeUtils.baseRoundedCorner * 5),
                  borderSide: BorderSide(color: AppColors.lightRed, width: 1),
                ),
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
                  borderRadius:
                      BorderRadius.circular(SizeUtils.baseRoundedCorner * 5),
                  borderSide: BorderSide(color: AppColors.primary, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(SizeUtils.baseRoundedCorner * 5),
                  borderSide: BorderSide(color: AppColors.grey100!, width: 2),
                ),
                hintStyle: TextStyle(
                  color: AppColors.grey400,
                  fontSize: hintFontSize ?? SizeUtils.baseTextSize12,
                  fontWeight: FontWeight.normal,
                ),
                errorStyle: TextStyle(
                  color: AppColors.lightRed,
                  fontSize: SizeUtils.baseTextSize12,
                  fontWeight: FontWeight.normal,
                ),
                labelStyle: TextStyle(
                    color: AppColors.grey200,
                    fontWeight: FontWeight.normal,
                    fontSize: SizeUtils.baseTextSize14),
                errorMaxLines: 2,
                suffixIcon: suffixWidget ??
                    Semantics(
                      label: "Search",
                      onTap: () {
                        // Todo navigate to search page
                      },
                      child: Container(
                          width: SizeUtils.baseWidthHeight16,
                          height: SizeUtils.baseWidthHeight16,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.search,
                            color: AppColors.black,
                          )),
                    )),
            focusNode: focusNode,
            onFieldSubmitted: (String value) {
              if (onFieldSubmitted != null) {
                onFieldSubmitted!();
              }
            },
          ),
        ),
      ),
    );
  }
}
