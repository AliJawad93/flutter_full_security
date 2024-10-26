import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_full_security/flutter_full_security.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String _platformVersion = 'Unknown';
  final _flutterFullSecurityPlugin = FlutterFullSecurity();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      ProxySetting d = await _flutterFullSecurityPlugin.proxySetting;
      var e = await _flutterFullSecurityPlugin.isEmulatorDevice ??
          'Unknown platform version';
      var r = await _flutterFullSecurityPlugin.isRootedDevice ??
          'Unknown platform version';
      log("message getsettings : ${d.host} , ${d.port}");
      log("message getsettings : ${d.host} , ${d.port}");
      log("message e : $e");
      log("message r : $r");
      var f = await _flutterFullSecurityPlugin.isAppFullSecurity;
      log("message f : $f");
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
