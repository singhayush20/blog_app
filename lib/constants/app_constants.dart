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
