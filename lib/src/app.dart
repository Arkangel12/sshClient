import 'package:flutter/material.dart';
import 'package:sshclient/src/screens/sshClientApp.dart';

class SSHCtrl extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter SSH',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: SSHClientApp(),
  );
}