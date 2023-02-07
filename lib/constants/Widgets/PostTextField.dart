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
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: Colors.red,
      decoration: InputDecoration(
        label: Text(labelText),
        icon: Icon(
          FontAwesomeIcons.pen,
          size: 12.sp,
          color: Colors.black,
        ),
        labelStyle: TextStyle(
          fontSize: 15.sp,
          color: Color.fromARGB(255, 4, 56, 146),
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: Color.fromARGB(255, 152, 240, 217),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 6, 37, 122),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
