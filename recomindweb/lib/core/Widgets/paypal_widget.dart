// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class PayPal extends StatefulWidget {
//   const PayPal({super.key, required this.url, required this.onSuccess});

//   final String url;
//   final VoidCallback onSuccess;

//   @override
//   State<PayPal> createState() => _PayPalState();
// }

// class _PayPalState extends State<PayPal> {
//   InAppWebViewController? webviewController;

//   @override
//   Widget build(BuildContext context) {
//     return InAppWebView(
//       initialUrlRequest: URLRequest(url: WebUri(widget.url)),
//       initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
//       onWebViewCreated: (controller) {
//         webviewController = controller;
//       },
//       onLoadStart: (controller, url) {
//         if (url == null) return;
//         debugPrint("Page started: $url");
//         if (url.toString().contains("status=success")) {
//           String urls = url.toString();
//           debugPrint("✅ Success detected with URL: $urls");
//           // widget.onSuccess();
//         }
//         if (url.toString().contains("https://10.0.2.2:5000/payment/cancel")) {
//           // Navigator.pop(context);
//         }
//       },
//       onLoadStop: (controller, url) async {
//         if (url == null) return;
//         debugPrint("Page finished: $url");
//       },
//     );
//   }
// }
 
 // pubspec.yaml dependencies:
// webview_flutter: ^4.4.2
// webview_flutter_web: ^0.2.2+4

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class PayPal extends StatefulWidget {
  const PayPal({super.key, required this.url, required this.onSuccess});
  final String url;
  final VoidCallback onSuccess;
  
  @override
  State<PayPal> createState() => _PayPalState();
}

class _PayPalState extends State<PayPal> {
  late final WebViewController controller;
  bool isLoading = true;
  Timer? urlCheckTimer;
  String? lastUrl;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint("🔄 Page started: $url");
            _handleUrlChange(url);
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            debugPrint("✅ Page finished: $url");
            _handleUrlChange(url);
            _startUrlPolling();
          },
          onUrlChange: (UrlChange change) {
            debugPrint("🔗 URL changed: ${change.url}");
            if (change.url != null) {
              _handleUrlChange(change.url!);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint("🧭 Navigation to: ${request.url}");
            _handleUrlChange(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _startUrlPolling() {
    urlCheckTimer?.cancel();
    urlCheckTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      try {
        final currentUrl = await controller.currentUrl();
        if (currentUrl != null && currentUrl != lastUrl) {
          lastUrl = currentUrl;
          debugPrint("🔍 Polling detected URL: $currentUrl");
          _handleUrlChange(currentUrl);
        }
      } catch (e) {
        debugPrint("Error getting current URL: $e");
      }
    });
  }

  void _handleUrlChange(String url) {
    debugPrint("🔎 Checking URL: $url");
    
    // Check for success
    if (url.contains("status=success")) {
      debugPrint("✅ Payment Success detected with URL: $url");
      
      // Extract payment details
      Uri uri = Uri.parse(url);
      String? paymentId = uri.queryParameters['id'] ?? uri.queryParameters['payment_id'];
      String? state = uri.queryParameters['state'] ?? uri.queryParameters['payment_state'];
      String? orderId = uri.queryParameters['order_id'];
      
      debugPrint("Payment ID: $paymentId, State: $state, Order ID: $orderId");
      
      _cleanupAndClose();
      widget.onSuccess();
      return;
    }
    
    // Check for cancellation  
    if (url.contains("status=cancelled") || url.contains("/payment/cancel")) {
      debugPrint("❌ Payment cancelled");
      _cleanupAndClose();
      return;
    }
    
    // Check for failure
    if (url.contains("status=failed")) {
      debugPrint("❌ Payment failed");
      _cleanupAndClose();
      return;
    }
  }

  void _cleanupAndClose() {
    urlCheckTimer?.cancel();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    urlCheckTimer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayPal Payment'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _cleanupAndClose(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading PayPal...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
