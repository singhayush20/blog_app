import 'dart:developer';

import 'package:blog_app/Model/Comment.dart';
import 'package:blog_app/Model/Post2.dart';
import 'package:blog_app/Service/CommentService.dart';
import 'package:blog_app/constants/Themes.dart';
import 'package:blog_app/constants/Widgets/DataLoadingIndicator.dart';
import 'package:blog_app/constants/Widgets/PhotoPreview.dart';
import 'package:blog_app/constants/Widgets/PostTextField.dart';
import 'package:blog_app/constants/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ExploreViewArticle extends StatefulWidget {
  Post2 post;
  SharedPreferences sharedPreferences;
  ExploreViewArticle({required this.post, required this.sharedPreferences});

  @override
  State<ExploreViewArticle> createState() => _ExploreViewArticleState();
}

class _ExploreViewArticleState extends State<ExploreViewArticle> {
  String? date;
  late final DateFormat _dateFormatter;
  final CommentService _commentService = CommentService();
  LoadingStatus _loadingStatus = LoadingStatus.NOT_STARTED;

  List<Comment>? _comments;

  TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _dateFormatter = DateFormat('yyyy-MM-dd');
  }

  Future<void> _loadComments() async {
    setState(() {
      _loadingStatus = LoadingStatus.LOADING;
    });
    var result = await _commentService.getAllCommentsForPost(
        token: widget.sharedPreferences.getString(BEARER_TOKEN) ?? 'null',
        postid: widget.post.postId);
    setState(() {
      _comments = result;
      _loadingStatus = LoadingStatus.COMPLETED;
      _commentController.text = '';
    });
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                child: Text(
                  widget.post.title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
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
                    color: Color.fromARGB(255, 190, 236, 227),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://imagedbspringboot.blob.core.windows.net/imagecontainer/${widget.post.image}',
                      placeholder: (context, url) => Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: DataLoadingIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset('images/category_default.jpg'),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
              Container(
                color: Color.fromARGB(255, 97, 137, 224),
                child: Text(
                  'Added on: ${_dateFormatter.format(widget.post.addDate)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Container(
                color: Color.fromARGB(255, 227, 246, 243),
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                child: Text(
                  widget.post.content,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
                    ),
                  ),
                  onPressed: () async {
                    await _loadComments();
                  },
                ),
              ),
              (_comments != null &&
                      _comments!.isNotEmpty &&
                      _loadingStatus != LoadingStatus.LOADING)
                  ? Column(children: [
                      ListTile(
                        title: PostTextField(
                          labelText: 'Your comment here...',
                          hintText: 'Comment...',
                          textController: _commentController,
                        ),
                        trailing: IconButton(
                          icon: Icon(FontAwesomeIcons.check),
                          onPressed: () async {
                            if (_commentController.text.trim().isNotEmpty) {
                              bool result = await _commentService.writeComment(
                                token: widget.sharedPreferences
                                    .getString(BEARER_TOKEN)!,
                                userid:
                                    widget.sharedPreferences.getInt(USER_ID)!,
                                postid: widget.post.postId,
                                content: _commentController.text.trim(),
                              );
                              log('comment result: $result');
                              if (result) {
                                await _loadComments();
                              }
                            }
                          },
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: ((context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: height * 0.01,
                            ),
                            decoration: listTileDecoration,
                            child: ListTile(
                              title: Text(
                                _comments![index].content,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                _comments![index].user.firstName +
                                    " " +
                                    _comments![index].user.lastName,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              leading: Text(
                                '${index + 1}.',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                        separatorBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: width * 0.3,
                            ),
                            height: 2,
                            color: Colors.black,
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
                          child: DataLoadingIndicator(),
                        )
                      : (_comments != null && _comments!.isEmpty)
                          ? Container(
                              child: Text(
                                'No Comments',
                                style: TextStyle(
                                  fontSize: 15.sp,
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
