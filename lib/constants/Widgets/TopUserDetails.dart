import 'package:blog_app/Pages/UserProfile/WriteArticlePage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class TopUserDetails extends StatelessWidget {
  const TopUserDetails({
    Key? key,
    required this.height,
    required Map<String, dynamic>? userDetails,
  })  : _userDetails = userDetails,
        super(key: key);

  final double height;
  final Map<String, dynamic>? _userDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black, width: 0.5, style: BorderStyle.solid),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 184, 231, 237),
              Color.fromARGB(255, 169, 218, 241),
            ],
          ),
          color: Color.fromARGB(255, 39, 80, 176),
        ),
        height: height * 0.1,
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.penToSquare,
                    size: 12.sp,
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
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${_userDetails!['data']['id']}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
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