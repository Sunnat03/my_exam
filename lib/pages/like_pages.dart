import 'package:flutter/material.dart';

import '../services/remote_service.dart';

class LikePage extends StatefulWidget {
  static const String id = '/like_page';
  const LikePage({Key? key}) : super(key: key);

  @override
  State<LikePage> createState() => _LikePageState();
}

class _LikePageState extends State<LikePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RemoteService.availableBackgroundColors[RemoteService.backgroundColor],
        title:const Text("Favourite Page"),
        centerTitle: true,
      ),
    );
  }
}
