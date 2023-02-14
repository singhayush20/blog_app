import 'dart:developer';

import 'package:blog_app/Pages/login_and_auth/LoginPage.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/provider/CategoryProvider.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
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
        title: Text("Settings"),
      ),
      body: SettingsList(
        lightTheme: SettingsThemeData(
          settingsListBackground: scaffoldColor,
          settingsSectionBackground: Color.fromARGB(255, 52, 52, 52),
          dividerColor: Colors.white,
          titleTextColor: Colors.white,
          settingsTileTextColor: Colors.yellow,
          tileDescriptionTextColor: Colors.amberAccent,
          leadingIconsColor: Colors.orangeAccent,
        ),
        sections: [
          SettingsSection(
            // titlePadding: EdgeInsets.all(20),
            title: Text(
              'App Settings',
              style: TextStyle(),
            ),
            tiles: [
              SettingsTile(
                title: Text(
                  'Logout',
                  style: TextStyle(
                      // color: Colors.white,
                      ),
                ),
                description: Text(
                  'Sign out from the application',
                  style: TextStyle(
                      // color: Colors.white70,
                      ),
                ),
                leading: Icon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  // color: Colors.white,
                ),
                onPressed: (BuildContext context) {
                  _sharedPreferences.clear();
                  categoryProvider.clear();
                  //set it to not started, so that if the user logs out and re-login using
                  //some other id without closing the app, again the same flow can be followed
                  // widget.provider.loadingStatus = LoadingStatus.NOT_STARTED;
                  Get.offAll(
                    () => LoginPage(),
                  );
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
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
