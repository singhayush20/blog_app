import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ItemTile extends StatelessWidget {
  ItemTile({required this.title, required this.subtitle});

  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black, width: 2, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 183, 241, 210),
              Color.fromARGB(255, 160, 234, 164),
            ],
          ),
        ),
        child: ListTile(
          title: Text(
            '$title',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${subtitle}',
            style: TextStyle(
              fontSize: 15.sp,
            ),
          ),
        ),
      );
    });
  }
}
