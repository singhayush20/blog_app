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
import 'package:loader_overlay/loader_overlay.dart';
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

  final TextEditingController _commentController = TextEditingController();
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
        ),
      ),
      body: LoaderOverlay(
        overlayWidget: Container(
          height: 50,
          width: 50,
          child: const DataLoadingIndicator(),
        ),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.01,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.02,
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
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
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
                        tag:
                            'imageHero', // Ensure the tag is unique across screens
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                20), // Add rounded corners
                            border: Border.all(
                              color: Colors.black, // Set the border color
                              width: 2, // Set the border width
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange[100] ?? Colors.orange,
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://blogimagesa.blob.core.windows.net/imagecontainer/${widget.post.image}',
                              placeholder: (context, url) => Center(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: const DataLoadingIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Image.asset('images/placeholder_image.jpg'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        color: const Color.fromARGB(255, 8, 66, 194),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Published On: ${_dateFormatter.format(widget.post.addDate)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: const Color.fromARGB(219, 242, 239, 239),
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10), // Add some vertical spacing
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width * 0.05,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white, // Set the background color
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          widget.post.content,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.blue,
                                    fontSize: 15.sp,
                                  ), // Use an appropriate text style
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PostTextField(
                          labelText: 'Your comment here...',
                          hintText: 'Comment...',
                          textController: _commentController,
                        ),
                        const SizedBox(height: 10), // Add some vertical spacing
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Adjust as needed
                            children: [
                              Text(
                                'Post',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.check,
                                  color: Colors.orange,
                                ),
                                onPressed: () async {
                                  if (_commentController.text
                                      .trim()
                                      .isNotEmpty) {
                                    context.loaderOverlay.show();
                                    bool result =
                                        await _commentService.writeComment(
                                      token: widget.sharedPreferences
                                          .getString(BEARER_TOKEN)!,
                                      userid: widget.sharedPreferences
                                          .getInt(USER_ID)!,
                                      postid: widget.post.postId,
                                      content: _commentController.text.trim(),
                                    );
                                    context.loaderOverlay.hide();
                                    log('comment result: $result');
                                    if (result) {
                                      await _loadComments();
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: height * 0.05,
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          child: Text(
                            'More Comments',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                              color: Colors.blue, // Change to match your design
                            ),
                          ),
                          onPressed: () async {
                            await _loadComments();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_loadingStatus == LoadingStatus.LOADING)
                        Center(
                          child: Container(
                            height: 50,
                            width: 50,
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.3),
                            child: const DataLoadingIndicator(),
                          ),
                        )
                      else if (_comments != null && _comments!.isNotEmpty)
                        Column(
                          children: [
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: height * 0.01),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 235, 226,
                                        247), // Use the provided scaffold color
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      _comments![index].content,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .black, // Change to match your design
                                      ),
                                    ),
                                    subtitle: Text(
                                      "${_comments![index].user.firstName} ${_comments![index].user.lastName}",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255,
                                            232,
                                            92,
                                            32), // Change to match your design
                                      ),
                                    ),
                                    leading: Container(
                                      width: 30,
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 33, 37,
                                            243), // Change to match your design
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 2,
                                  thickness: 3,
                                  color: Colors.purpleAccent,
                                );
                              },
                              itemCount: _comments!.length,
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                          ],
                        )
                      else
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'No Comments',
                            style: TextStyle(
                              fontSize: 15.sp,
                              color:
                                  Colors.black, // Change to match your design
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
