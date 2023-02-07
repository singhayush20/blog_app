import 'package:blog_app/Pages/UserProfile/MyArticlesPage.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/Widgets/CustomLoadingIndicator.dart';
import 'package:blog_app/constants/Widgets/ItemTile.dart';
import 'package:blog_app/constants/Widgets/TopUserDetails.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:blog_app/network_util/API.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  SharedPreferences? _sharedPreferences;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final API _api;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Map<String, dynamic>? _userDetails;
  late Future<void> _initialData;
  Future<void> _initUserData() async {
    _sharedPreferences = await SharedPreferences.getInstance();

    final result = await _api.getUserProfileData(
        email: _sharedPreferences!.getString(EMAIL),
        token: _sharedPreferences!.getString(BEARER_TOKEN));
    setState(() {
      _userDetails = result;
    });
  }

  Future<void> _refreshUserData() async {
    final result = await _api.getUserProfileData(
        email: _sharedPreferences!.getString(EMAIL),
        token: _sharedPreferences!.getString(BEARER_TOKEN));
    setState(() {
      _userDetails = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  void _initializePrefs() async {
    _api = API();
    _initialData = _initUserData();
  }

  final AppBar _appBar = AppBar(
    title: Text("Profile"),
  );
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final height = MediaQuery.of(context).size.height -
        _appBar.preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom -
        kBottomNavigationBarHeight;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _appBar,
      body: FutureBuilder(
        future: _initialData,
        builder: (BuildContext context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              {
                return Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: CustomLoadingIndicator(),
                  ),
                );
              }
            case ConnectionState.done:
              {
                if (_userDetails != null && _userDetails!['code'] == '2000') {
                  return RefreshIndicator(
                    onRefresh: _refreshUserData,
                    key: _refreshIndicatorKey,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.05,
                            ),
                            //Image
                            Container(
                              height: height * 0.2,
                              alignment: Alignment.center,
                              child: FittedBox(
                                child: CircleAvatar(
                                  radius: 500,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: ClipOval(
                                    child: Image.asset(
                                        'images/DefaultProfileImage.jpg'),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            //Top user details
                            TopUserDetails(
                                height: height, userDetails: _userDetails),
                            //Details
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                    child: Text(
                                      'My Articles',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w800,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.to(
                                        MyArticlesPage(),
                                      );
                                    },
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.userPen,
                                        size: 12.sp,
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Update profile',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w800,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.bottomSheet(
                                            _updateProfileBottomSheet(),
                                            persistent: true,
                                            backgroundColor: Color.fromARGB(
                                                255, 177, 251, 240),
                                            elevation: 5,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            barrierColor: Colors.black54,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                ItemTile(
                                  title: "Name",
                                  subtitle:
                                      '${_userDetails!['data']['firstName']} ${_userDetails!['data']['lastName']}',
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ItemTile(
                                  title: "About",
                                  subtitle: '${_userDetails!['data']['about']}',
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ItemTile(
                                  title: "Email",
                                  subtitle: '${_userDetails!['data']['email']}',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: _refreshUserData,
                    key: _refreshIndicatorKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 100,
                              child:
                                  Image.asset('images/category_default.jpg')),
                          Container(
                            height: 100,
                            alignment: Alignment.center,
                            child: Text(
                              'No Data',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ]),
                  );
                }
              }
          }
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget _updateProfileBottomSheet() {
    _firstNameController.text = _userDetails!['data']['firstName'];
    _lastNameController.text = _userDetails!['data']['lastName'];
    _aboutController.text = _userDetails!['data']['about'];
    return LoaderOverlay(
      overlayWidget: Center(
        child: Container(
          height: 100,
          width: 100,
          child: CustomLoadingIndicator(),
        ),
      ),
      disableBackButton: true,
      overlayWholeScreen: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            child: LayoutBuilder(builder: (context, dialogConstraints) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            height: dialogConstraints.maxHeight * 0.2,
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: _firstNameController,
                              obscureText: false,
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'First Name cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              decoration: fieldDecoration(
                                  label: "First Name",
                                  icon: FontAwesomeIcons.user),
                            ),
                          ),
                          Container(
                            height: dialogConstraints.maxHeight * 0.2,
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: _lastNameController,
                              obscureText: false,
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Last Name cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              decoration: fieldDecoration(
                                  label: "Last Name",
                                  icon: FontAwesomeIcons.user),
                            ),
                          ),
                          Container(
                            height: dialogConstraints.maxHeight * 0.3,
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: _aboutController,
                              obscureText: false,
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              maxLines: 2,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Description cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              decoration: fieldDecoration(
                                  label: "Description",
                                  icon: FontAwesomeIcons.addressCard),
                            ),
                          ),
                          SizedBox(
                            height: dialogConstraints.maxHeight * 0.05,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                context.loaderOverlay.show();
                                Map<String, dynamic> result =
                                    await _api.updateUserProfile(
                                        userid: _userDetails!['data']['id'],
                                        firstName: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                        about: _aboutController.text,
                                        token: _sharedPreferences!
                                            .getString(BEARER_TOKEN));
                                context.loaderOverlay.hide();
                                if (result['code'] == '2000') {
                                  await _refreshUserData();
                                  Get.back();
                                  Get.snackbar(
                                      "Success", "Profile updated successfully",
                                      snackPosition: SnackPosition.BOTTOM);
                                } else {
                                  Get.snackbar(
                                      "Failed!", "Could not update profile!",
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                              }
                            },
                            child: Text(
                              'Update Details',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
