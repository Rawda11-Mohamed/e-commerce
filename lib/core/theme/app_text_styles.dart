import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stylish_app/core/theme/app_colors.dart';

class AppTextStyles {
  static TextStyle font34BlackBold = GoogleFonts.poppins(
    fontSize: 34.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static TextStyle font24BlackBold = GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static TextStyle font18BlackBold = GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static TextStyle font16BlackSemiBold = GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static TextStyle font14BlackRegular = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static TextStyle font14GreyRegular = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.mediumGrey,
  );

  static TextStyle font14WhiteRegular = GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static TextStyle font11GreyRegular = GoogleFonts.poppins(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.mediumGrey,
  );
}