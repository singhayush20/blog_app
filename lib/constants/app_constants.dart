import 'package:blog_app/constants/Themes.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

const String domain = "https://e8bc-14-139-240-85.in.ngrok.io";
const String domain2 = "e8bc-14-139-240-85.in.ngrok.io";
const BEARER_TOKEN = "BEARER TOKEN";
const IS_LOGGED_IN = "isLoggedIn";
const Bearer = "Bearer ";
const USER_ID = "userId";
const EMAIL = "email";
const CODE = "code";
const STATUS = "status";
const MESSAGE = "message";

enum LoadingStatus { NOT_STARTED, LOADING, COMPLETED }

enum AccountType { ADMIN, NORMAL }

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

class DataLoadingIndicator extends StatelessWidget {
  const DataLoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      child: const LoadingIndicator(
        indicatorType: Indicator.lineScale,
        colors: [
          Colors.purple,
          // Colors.indigo,
          // Colors.blue,
          // Colors.green,
          // Colors.red,
        ],

        /// Optional, The color collections
        strokeWidth: 0.5,
      ),
    );
  }
}
