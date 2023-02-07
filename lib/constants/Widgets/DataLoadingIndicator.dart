import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class DataLoadingIndicator extends StatelessWidget {
  const DataLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LoadingIndicator(
      indicatorType: Indicator.lineScale,
      colors: [
        Colors.purple,
        Colors.indigo,
        Colors.blue,
        Colors.green,
        Colors.red,
      ],

      /// Optional, The color collections
      strokeWidth: 0.5,
    );
  }
}
