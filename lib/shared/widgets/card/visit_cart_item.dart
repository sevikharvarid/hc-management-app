import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/utils/constant/size_utils.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';

class VisitCardItem extends StatelessWidget {
  final String? attendanceDateIn;
  final String? attendanceDateOut;
  final String? soNumber;
  final String? storeName;
  final String? storeCode;
  final String? startDateTime;
  final String? endDateTime;

  const VisitCardItem({
    super.key,
    this.attendanceDateIn,
    this.attendanceDateOut,
    this.soNumber,
    this.storeName,
    this.storeCode,
    this.startDateTime,
    this.endDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      height: 150,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tgl In : ${attendanceDateIn!}',
                    style: GoogleFonts.nunito(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                  Text(
                    'Tgl Out : ${attendanceDateOut!}',
                    style: GoogleFonts.nunito(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
              // const Spacer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      storeCode ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      storeName ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          spaceHeight(height: SizeUtils.basePaddingMargin16),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.blue70,
                    size: 45,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jam Masuk",
                        style: GoogleFonts.nunito(
                          color: AppColors.black,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        startDateTime!,
                        style: GoogleFonts.nunito(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              spaceWidth(width: SizeUtils.basePaddingMargin10),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: AppColors.redButton,
                    size: 45,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jam Keluar",
                        style: GoogleFonts.nunito(
                          color: AppColors.black,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        endDateTime!,
                        style: GoogleFonts.nunito(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              spaceWidth(width: SizeUtils.basePaddingMargin20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_calendar_sharp,
                    color: AppColors.green,
                    size: 30,
                  ),
                  Text(
                    soNumber!,
                    style: GoogleFonts.nunito(
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
