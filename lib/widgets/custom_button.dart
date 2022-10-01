import 'package:cash_driver/constants.dart';
import 'package:cash_driver/utils/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    required this.onPressed,
    required this.buttonText,
    this.isLoading = false,
  });

  final Function()? onPressed;
  final String buttonText;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0.w, 4.h),
            blurRadius: 4.r,
            color: Colors.black.withOpacity(0.25),
          )
        ],
      ),
      child: RawMaterialButton(
        elevation: 2,
        fillColor: const Color(0xFF0D2516),
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: SizedBox(
          height: 50.h,
          width: 300.w,
          child: Center(
            child: isLoading
                ? spinKit(color: kButtonTextColor)
                : Text(buttonText, style: kBodyStyle3),
          ),
        ),
      ),
    );
  }
}
