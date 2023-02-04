import 'dart:developer';

import 'package:blog_app/Pages/login_and_auth/LoginPage.dart';
import 'package:blog_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            // titlePadding: EdgeInsets.all(20),
            title: Text('App Settings'),
            tiles: [
              SettingsTile(
                title: Text('Logout'),
                description: Text('Sign out from your account'),
                leading: Icon(FontAwesomeIcons.arrowRightFromBracket),
                onPressed: (BuildContext context) {
                  _sharedPreferences.clear();
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
          // SettingsSection(
          //   // titlePadding: EdgeInsets.all(20),
          //   title: Text('Section 2'),
          //   tiles: [
          //     SettingsTile(
          //       title: Text('Security'),
          //       description: Text('Fingerprint'),
          //       leading: Icon(Icons.lock),
          //       onPressed: (BuildContext context) {},
          //     ),
          //     SettingsTile.switchTile(
          //       title: Text('Use fingerprint'),
          //       leading: Icon(Icons.fingerprint),
          //       initialValue: true,
          //       onToggle: (value) {},
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
