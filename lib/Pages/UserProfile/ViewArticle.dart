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

  ViewArticle({required this.post, required this.sharedPreferences});

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
                  // child: Image.asset('images/category_default.jpg'),
                  // child: Image.network(
                  //   'https://imagedbspringboot.blob.core.windows.net/imagecontainer/image_picker8167626668264245641.jpg',
                  // ),
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
                alignment: Alignment.center,
                child: TextButton(
                  child: Text('Load Comments'),
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
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
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