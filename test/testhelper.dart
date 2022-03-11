import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class TestHelper {
  static Future<Widget> makeTestableWidget({required Widget child}) async {
    await loadAppFonts();
    return MaterialApp(
      title: "Test",
      home: Scaffold(
        appBar: AppBar(
          title: Text(child.runtimeType.toString()),
        ),
        body: child,
      ),
    );
  }
}
