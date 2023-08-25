import 'dart:developer';

import 'package:blog_app/Pages/login_and_auth/LoginPage.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/Widgets/CustomLoadingIndicator.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/network_util/API.dart';
import 'package:blog_app/provider/CategoryProvider.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  late SharedPreferences _sharedPreferences;
  final API _api = API();

  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  void _initializePrefs() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    log('settings: Shared Preferences obtained!');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: LoaderOverlay(
          overlayWidget: const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CustomLoadingIndicator(),
            ),
          ),
          child: SettingsList(
            lightTheme: const SettingsThemeData(
              settingsListBackground: scaffoldColor,
              settingsSectionBackground: Color.fromARGB(255, 226, 225, 225),
              dividerColor: Colors.black,
              titleTextColor: Colors.red,
              settingsTileTextColor: Colors.blue,
              tileDescriptionTextColor: Color.fromARGB(255, 122, 80, 16),
              leadingIconsColor: Color.fromARGB(255, 206, 62, 37),
            ),
            sections: [
              SettingsSection(
                title: Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 15.sp,
                  ),
                ),
                tiles: [
                  SettingsTile(
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                          // color: Colors.white,
                          ),
                    ),
                    description: const Text(
                      'Sign out from the application',
                      style: TextStyle(
                          // color: Colors.white70,
                          ),
                    ),
                    leading: const Icon(
                      FontAwesomeIcons.arrowRightFromBracket,
                      // color: Colors.white,
                    ),
                    onPressed: (BuildContext context) async {
                      context.loaderOverlay.show();
                      final Map<String, dynamic> result = await _api.logout(
                          userid: _sharedPreferences.getInt(USER_ID)!,
                          devicetoken: _sharedPreferences.getString(FCM_TOKEN)!,
                          token: _sharedPreferences.getString(BEARER_TOKEN)!);
                      context.loaderOverlay.hide();
                      if (result[CODE] == '2000') {
                        _sharedPreferences.clear();
                        categoryProvider.clear();
                        //set it to not started, so that if the user logs out and re-login using
                        //some other id without closing the app, again the same flow can be followed
                        // widget.provider.loadingStatus = LoadingStatus.NOT_STARTED;
                        Get.offAll(
                          () => const LoginPage(),
                          transition: Transition.leftToRight,
                          duration: const Duration(
                            milliseconds: 800,
                          ),
                        );
                      } else {
                        Get.snackbar("Error", "Failed to logout!");
                      }
                    },
                  ),
                  // SettingsTile.switchTile(
                  //   title: Text('Use System Theme'),
                  //   leading: Icon(Icons.phone_android),
                  //   initialValue: false,
                  //   onToggle: (value) {
                  //     // setState(() {
                  //     //   isSwitched = value;
                  //     // });
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
