import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    log('explore page init called');
  }

  @override
  void dispose() {
    log('explore page dispose called');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    log('explore page builidng');
    return Scaffold(
      appBar: AppBar(
        title: Text("Explore"),
      ),
      body: Center(child: Text('Explore')),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
