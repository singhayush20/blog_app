import 'package:blog_app/constants/Themes.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingIndicator(
        strokeWidth: 0.5,
        indicatorType: Indicator.ballPulse,
        colors: [
          appBarColor,
        ],
      ),
    );
  }
}
