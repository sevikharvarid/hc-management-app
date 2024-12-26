import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';

Widget buildTextField({
  TextEditingController? controller,
  String? hintText,
  String? label,
  Widget? suffixIcon,
  bool? obscureText = false,
  int? maxLines = 1,
  bool? isReadOnly = false,
  String? Function(String?)? validator,
  Function(String)? onFieldSubmitted,
  bool? enabled = true,
  TextInputType? keyboardType,
}) {
  return TextFormField(
    enabled: enabled,
    controller: controller,
    maxLines: maxLines,
    obscureText: obscureText!,
    readOnly: isReadOnly!,
    keyboardType: keyboardType ?? TextInputType.name,
    onFieldSubmitted: onFieldSubmitted,
    style: GoogleFonts.roboto(
      fontSize: 12,
      color: AppColors.black,
      fontWeight: FontWeight.w300,
    ),
    decoration: InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      hintText: hintText,
      hintStyle: GoogleFonts.roboto(
        fontSize: 12,
        color: AppColors.black40,
        fontWeight: FontWeight.w300,
      ),
      isDense: true,
      label: Text(label!),
      labelStyle: GoogleFonts.roboto(
        fontSize: 14,
        color: AppColors.black,
        fontWeight: FontWeight.w400,
      ),
      suffixIcon: suffixIcon,
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
            color: Colors.transparent), // Ganti warna border sesuai kebutuhan
        borderRadius: BorderRadius.circular(8), //
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: isReadOnly
                ? Colors.grey
                : AppColors.primary), // Ganti warna border sesuai kebutuhan
        borderRadius: BorderRadius.circular(8), //
      ),
      border: OutlineInputBorder(
        // Menambahkan border
        borderSide: const BorderSide(
            color: Colors.blue), // Ganti warna border sesuai kebutuhan
        borderRadius: BorderRadius.circular(
            8), // Sesuaikan radius border sesuai kebutuhan
      ),
    ),
    validator: validator ??
        (value) {
      if (value!.isEmpty) {
        return "Harap di isi terlebih dahulu";
      }
          if (value.length < 8) {
            return "Password harus lebih dari 8 karakter";
          }
      return null;
    },
  );
}
