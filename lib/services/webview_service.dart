import 'package:flutter/material.dart';
import '../screens/webview_screen.dart';

class WebViewService {
  static void openUrl(BuildContext context, String url, {String? title}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: url,
          title: title,
        ),
      ),
    );
  }
}
