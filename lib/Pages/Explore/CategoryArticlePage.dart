import 'package:blog_app/Model/Category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CategoryArticlePage extends StatefulWidget {
  CategoryArticlePage({required this.category});
  Category category;

  @override
  State<CategoryArticlePage> createState() => _CategoryArticlePageState();
}

class _CategoryArticlePageState extends State<CategoryArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Column()),
    );
  }
}
