import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PersonalFeedPage extends StatefulWidget {
  const PersonalFeedPage({super.key});

  @override
  State<PersonalFeedPage> createState() => _PersonalFeedPageState();
}

class _PersonalFeedPageState extends State<PersonalFeedPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    log('Personal feed init called');
  }

  @override
  void dispose() {
    log('personal feed dispose called');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    log('Building Personal feed page');
    return Scaffold(
      appBar: AppBar(
        title: Text("Feed"),
      ),
      body: Center(child: Text('Feed')),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
