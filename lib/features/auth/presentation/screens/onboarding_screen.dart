import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stylish_app/app/app_router.dart';
import 'package:stylish_app/core/theme/app_colors.dart';
import 'package:stylish_app/core/theme/app_text_styles.dart';
import 'package:stylish_app/core/theme/app_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": AppAssets.onboarding1,
      "title": "Choose Products",
      "subtitle": "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint."
    },
    {
      "image": AppAssets.onboarding2,
      "title": "Make Payment",
      "subtitle": "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint."
    },
    {
      "image": AppAssets.onboarding3,
      "title": "Get Your Order",
      "subtitle": "Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRouter.getStartedRoute,
                      (route) => false,
                ),
                child: Text(
                  'Skip',
                  style: AppTextStyles.font14BlackRegular,
                ),
              ),
            ),
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (_, i) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SVG Image
                        Flexible(
                          child: SvgPicture.asset(
                            onboardingData[i]['image']!,
                            fit: BoxFit.contain,
                            height: 250.h,
                            width: 250.w,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        // Title
                        Text(
                          onboardingData[i]['title']!,
                          style: AppTextStyles.font24BlackBold,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        // Subtitle
                        Text(
                          onboardingData[i]['subtitle']!,
                          style: AppTextStyles.font14GreyRegular,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom Navigation (Dots + Buttons)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  _currentPage > 0
                      ? TextButton(
                    onPressed: () => _controller.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn,
                    ),
                    child: Text(
                      'Prev',
                      style: AppTextStyles.font14GreyRegular,
                    ),
                  )
                      : const SizedBox(width: 50),

                  // Page Indicator
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.mediumGrey,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),

                  // Next / Get Started Button
                  TextButton(
                    onPressed: () {
                      if (_currentPage == onboardingData.length - 1) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRouter.getStartedRoute,
                              (route) => false,
                        );
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: Text(
                      _currentPage == onboardingData.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: AppTextStyles.font14BlackRegular
                          .copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}