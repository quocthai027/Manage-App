import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebView(
          initialUrl: 'http://sunwinapp1.online/',
          javascriptMode:
              JavascriptMode.unrestricted, // Để kích hoạt JavaScript
        ),
      ),
    );
  }
}
