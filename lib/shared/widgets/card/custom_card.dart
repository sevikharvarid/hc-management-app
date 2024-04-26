import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hc_management_app/shared/utils/constant/app_colors.dart';
import 'package:hc_management_app/shared/widgets/atom/spacer.dart';
import 'package:hc_management_app/shared/widgets/button/custom_button.dart';

class CustomCard extends StatelessWidget {
  final Function()? action;
  final bool? withButton;

  const CustomCard({
    super.key,
    this.action,
    this.withButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: withButton! ? 150 : 120,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: 230,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    "Kunjungan",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      color: AppColors.redText,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  "Thu, 28 Juli 2022",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey40,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            spaceHeight(height: 20),
            Expanded(
              flex: 2,
              child: Text(
                " 09:00:00",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black60,
                  fontSize: 30,
                ),
              ),
            ),
            withButton!
                ? Expanded(
                    flex: 2,
                    child: CustomButton(
                      borderColor: AppColors.purple,
                      backgroundColor: MaterialStateProperty.all(
                        AppColors.purple,
                      ),
                      title: "Check In",
                      action: action,
                      withIcon: false,
                      active: true,
                    ),
                  )
                : const SizedBox(),
            spaceHeight(height: 5),
          ],
        ),
      ),
    );
  }
}
