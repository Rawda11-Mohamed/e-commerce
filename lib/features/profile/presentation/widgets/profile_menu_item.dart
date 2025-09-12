import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stylish_app/core/theme/app_colors.dart';
import 'package:stylish_app/core/theme/app_text_styles.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool hasArrow;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.hasArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.black, size: 24),
                  SizedBox(width: 16.w),
                  Expanded(child: Text(text, style: AppTextStyles.font16BlackSemiBold)),
                  if (hasArrow) const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.mediumGrey),
                ],
              ),
            ),
          ),
        ),
        if (text != "Log Out") const Divider(height: 1, color: AppColors.lightGrey),
      ],
    );
  }
}