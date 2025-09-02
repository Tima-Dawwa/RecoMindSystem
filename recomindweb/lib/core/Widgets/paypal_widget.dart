import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PayPal extends StatefulWidget {
  const PayPal({super.key, required this.url, required this.onSuccess});

  final String url;
  final VoidCallback onSuccess;

  @override
  State<PayPal> createState() => _PayPalState();
}

class _PayPalState extends State<PayPal> {
  InAppWebViewController? webviewController;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(widget.url)),
      initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
      onWebViewCreated: (controller) {
        webviewController = controller;
      },
      onLoadStart: (controller, url) {
        if (url == null) return;
        debugPrint("Page started: $url");
        if (url.toString().contains("status=success")) {
          String urls = url.toString();
          debugPrint("✅ Success detected with URL: $urls");
          // widget.onSuccess();
        }
        if (url.toString().contains("https://10.0.2.2:5000/payment/cancel")) {
          // Navigator.pop(context);
        }
      },
      onLoadStop: (controller, url) async {
        if (url == null) return;
        debugPrint("Page finished: $url");
      },
    );
  }
}
