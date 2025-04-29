import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:stores_app/external/theme/app_colors.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(50),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),

            height: 200,
            width: 200,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotate,

              colors: const [
                AppColors.mainColor,
                AppColors.mainColor,
                AppColors.mainColor,
              ],

              // colors: const [Colors.white,Colors.white,Colors.white,],
              strokeWidth: 2,
            ),
          ),
        ],
      ),
    );
  }
}
