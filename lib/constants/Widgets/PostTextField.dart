import 'package:blog_app/constants/Themes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class PostTextField extends StatelessWidget {
  PostTextField(
      {required this.labelText,
      required this.hintText,
      required this.textController});

  final TextEditingController textController;
  final labelText, hintText;
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textAlign: TextAlign.start,
      textCapitalization: TextCapitalization.sentences,
      controller: textController,
      style: TextStyle(
        fontSize: 15.sp,
        color: Colors.red,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: Colors.red,
      decoration: inputFormFieldBoxDecoration.copyWith(
        hintText: hintText,
        label: Text(labelText),
        hintStyle: const TextStyle(
          color: Colors.black,
        ),
        labelStyle: TextStyle(
          fontSize: 15.sp,
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.green,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.greenAccent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
