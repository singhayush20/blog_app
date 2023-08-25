import 'package:blog_app/Model/Comment.dart';
import 'package:blog_app/Model/Post.dart';
import 'package:blog_app/Service/CommentService.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/Widgets/DataLoadingIndicator.dart';
import 'package:blog_app/constants/Widgets/PhotoPreview.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ViewArticle extends StatefulWidget {
  Post post;
  SharedPreferences sharedPreferences;

  ViewArticle({super.key, required this.post, required this.sharedPreferences});

  @override
  State<ViewArticle> createState() => _ViewArticleState();
}

class _ViewArticleState extends State<ViewArticle> {
  String? date;
  late final DateFormat _dateFormatter;
  final CommentService _commentService = CommentService();
  LoadingStatus _loadingStatus = LoadingStatus.NOT_STARTED;

  List<Comment>? _comments;
  @override
  void initState() {
    super.initState();
    _dateFormatter = DateFormat('yyyy-MM-dd');
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.post.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
          ),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                child: Text(
                  widget.post.title,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.lightBlue,
                      ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PhotoPreview(image: widget.post.image);
                        },
                      ),
                    );
                  },
                  child: Hero(
                    tag: 'imageHero',
                    child: Container(
                      height: height * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            15), // Adjust the value as needed
                        border: Border.all(
                          color: const Color.fromARGB(255, 239, 43, 43),
                          width: 3,
                        ),
                        boxShadow: [
                          const BoxShadow(
                            color: Colors.red,
                            spreadRadius: 3,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            12), // Should match the outer decoration
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://blogimagesa.blob.core.windows.net/imagecontainer/${widget.post.image}',
                          placeholder: (context, url) => Center(
                            child: Container(
                              child: Image.asset(
                                'images/placeholder_image.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Image.asset('images/placeholder_image.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
              Container(
                alignment: Alignment.centerLeft,
                color: Colors.blue, // Change to your desired background color
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Added on: ${_dateFormatter.format(widget.post.addDate)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white, // Change to your desired text color
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color:
                      Colors.white, // Change to your desired background color
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.post.content,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color:
                            Colors.black, // Change to your desired text color
                      ),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              Container(
                height: height * 0.05,
                alignment: Alignment.centerLeft,
                child: TextButton(
                  child: Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      _loadingStatus = LoadingStatus.LOADING;
                    });
                    var result = await _commentService.getAllCommentsForPost(
                        token:
                            widget.sharedPreferences.getString(BEARER_TOKEN) ??
                                'null',
                        postid: widget.post.postId);
                    setState(() {
                      _comments = result;
                      _loadingStatus = LoadingStatus.COMPLETED;
                    });
                  },
                ),
              ),
              (_comments != null &&
                      _comments!.isNotEmpty &&
                      _loadingStatus != LoadingStatus.LOADING)
                  ? Column(children: [
                      ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            margin:
                                EdgeInsets.symmetric(vertical: height * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              title: Text(
                                _comments![index].content,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              subtitle: Text(
                                '${_comments![index].user.firstName} ${_comments![index].user.lastName}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              leading: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.indigo,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 5,
                          );
                        },
                        itemCount: _comments!.length,
                      ),
                    ])
                  : (_loadingStatus == LoadingStatus.LOADING)
                      ? Container(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.symmetric(horizontal: width * 0.3),
                          child: const DataLoadingIndicator(),
                        )
                      : (_comments != null && _comments!.isEmpty)
                          ? Container(
                              child: Text(
                                'No Comments',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
