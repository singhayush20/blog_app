import 'package:blog_app/Model/User.dart';
import 'package:blog_app/Pages/UserProfile/WriteArticlePage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../Themes.dart';

class TopUserDetails extends StatelessWidget {
  const TopUserDetails({
    Key? key,
    required this.height,
    required User? userDetails,
  })  : _userDetails = userDetails,
        super(key: key);

  final double height;
  final User? _userDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: profileBox1Decoration,
        height: height * 0.1,
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.penToSquare,
                    size: 12.sp,
                    color: Colors.white,
                  ),
                  TextButton(
                    child: Text(
                      'Write an article',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: () {
                      Get.to(
                        WriteArticlePage(),
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'User ID',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${_userDetails!.id}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
