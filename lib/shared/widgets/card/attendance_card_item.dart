import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';

class AttendanceCardItem extends StatelessWidget {
  final String? attendanceDate;
  final String? startDayTime;
  final String? endDayTime;
  final String? typeAbsence;

  const AttendanceCardItem({
    super.key,
    this.attendanceDate,
    this.startDayTime,
    this.endDayTime,
    this.typeAbsence,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      height: 130,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color:
                Colors.grey.withOpacity(0.3), // Warna bayangan (shadow color)
            spreadRadius: 2, // Jarak penyebaran bayangan
            blurRadius: 2, // Jarak blur bayangan
            offset: const Offset(0, 2), // Perpindahan bayangan dari kontainer
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            attendanceDate!,
            style: GoogleFonts.nunito(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          spaceHeight(height: SizeUtils.basePaddingMargin16),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: typeAbsence == "in"
                        ? AppColors.redButton
                        : AppColors.blue70,
                    size: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        typeAbsence == "in" ? "Jam Masuk" : "Jam Keluar",
                        style: GoogleFonts.nunito(
                          color: AppColors.black,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        startDayTime!,
                        style: GoogleFonts.nunito(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              spaceWidth(width: SizeUtils.basePaddingMargin80),
              Row(
                children: [
                  // Icon(
                  //   Icons.location_on,
                  //   color: AppColors.redButton,
                  //   size: 50,
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Toko",
                        style: GoogleFonts.nunito(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        endDayTime!,
                        style: GoogleFonts.nunito(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
