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
//           print('sssssssss $urls');
//           // widget.onSuccess();
//         }
//         if (url.toString().contains("https://10.0.2.2:5000/payment/cancel")) {
//           String urls = url.toString();

//           print('2222222 $urls');

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

// ----------------------------------------------
// pubspec.yaml dependencies:
// webview_flutter: ^4.4.2
// webview_flutter_web: ^0.2.2+4

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:async';

// class PayPal extends StatefulWidget {
//   const PayPal({super.key, required this.url, required this.onSuccess});
//   final String url;
//   final VoidCallback onSuccess;

//   @override
//   State<PayPal> createState() => _PayPalState();
// }

// class _PayPalState extends State<PayPal> {
//   late final WebViewController controller;
//   bool isLoading = true;
//   Timer? urlCheckTimer;
//   String? lastUrl;

//   @override
//   void initState() {
//     super.initState();
//     _initializeWebView();
//   }

//   void _initializeWebView() {
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.white)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (String url) {
//             debugPrint("🔄 Page started: $url");
//             _handleUrlChange(url);
//           },
//           onPageFinished: (String url) {
//             setState(() {
//               isLoading = false;
//             });
//             debugPrint("✅ Page finished: $url");
//             _handleUrlChange(url);
//             _startUrlPolling();
//           },
//           onUrlChange: (UrlChange change) {
//             debugPrint("🔗 URL changed: ${change.url}");
//             if (change.url != null) {
//               _handleUrlChange(change.url!);
//             }
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             debugPrint("🧭 Navigation to: ${request.url}");
//             _handleUrlChange(request.url);
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//   }

//   void _startUrlPolling() {
//     urlCheckTimer?.cancel();
//     urlCheckTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
//       try {
//         final currentUrl = await controller.currentUrl();
//         if (currentUrl != null && currentUrl != lastUrl) {
//           lastUrl = currentUrl;
//           debugPrint("🔍 Polling detected URL: $currentUrl");
//           _handleUrlChange(currentUrl);
//         }
//       } catch (e) {
//         debugPrint("Error getting current URL: $e");
//       }
//     });
//   }

//   void _handleUrlChange(String url) {
//     debugPrint("🔎 Checking URL: $url");

//     // Check for success
//     if (url.contains("status=success")) {
//       debugPrint("✅ Payment Success detected with URL: $url");

//       // Extract payment details
//       Uri uri = Uri.parse(url);
//       String? paymentId = uri.queryParameters['id'] ?? uri.queryParameters['payment_id'];
//       String? state = uri.queryParameters['state'] ?? uri.queryParameters['payment_state'];
//       String? orderId = uri.queryParameters['order_id'];

//       debugPrint("Payment ID: $paymentId, State: $state, Order ID: $orderId");

//       _cleanupAndClose();
//       widget.onSuccess();
//       return;
//     }

//     // Check for cancellation
//     if (url.contains("status=cancelled") || url.contains("/payment/cancel")) {
//       debugPrint("❌ Payment cancelled");
//       _cleanupAndClose();
//       return;
//     }

//     // Check for failure
//     if (url.contains("status=failed")) {
//       debugPrint("❌ Payment failed");
//       _cleanupAndClose();
//       return;
//     }
//   }

//   void _cleanupAndClose() {
//     urlCheckTimer?.cancel();
//     if (mounted) {
//       Navigator.of(context).pop();
//     }
//   }

//   @override
//   void dispose() {
//     urlCheckTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PayPal Payment'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () => _cleanupAndClose(),
//         ),
//       ),
//       body: Stack(
//         children: [
//           WebViewWidget(controller: controller),
//           if (isLoading)
//             const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Loading PayPal...', style: TextStyle(fontSize: 16)),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
// -------------------------

import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'dart:js' as js;

class PayPal extends StatefulWidget {
  const PayPal({super.key, required this.url, required this.onSuccess});
  final String url;
  final VoidCallback onSuccess;
  @override
  State<PayPal> createState() => _PayPalState();
}

class _PayPalState extends State<PayPal> {
  late String viewId;
  bool _isLoading = true;
  html.IFrameElement? iframe;

  @override
  void initState() {
    super.initState();
    viewId = 'paypal-iframe-${DateTime.now().millisecondsSinceEpoch}';
    _setupMessageListener();
    _registerIframe();
  }

  void _setupMessageListener() {
    // Listen for messages from the iframe
    html.window.addEventListener('message', (html.Event event) {
      final messageEvent = event as html.MessageEvent;
      print('📨 Received message: ${messageEvent.data}');

      if (messageEvent.data is Map) {
        final data = messageEvent.data as Map<String, dynamic>;
        final type = data['type'];
        widget.onSuccess();

        if (type == 'PAYPAL_SUCCESS') {
          print('✅ PayPal success message received!');
          print('Payment ID: ${data['paymentId']}');
          print('State: ${data['state']}');

          // Call the success callback
          widget.onSuccess();
        } else if (type == 'PAYPAL_ERROR') {
          print('❌ PayPal error: ${data['message']}');
          // Handle error if needed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment failed: ${data['message']}')),
          );
        }
      }
    });

    // Also listen for custom events on the window
    html.window.addEventListener('paypal-success', (html.Event event) {
      print('🎉 Custom paypal-success event received!');
      widget.onSuccess();
    });
  }

  void _registerIframe() {
    ui.platformViewRegistry.registerViewFactory(viewId, (int id) {
      iframe =
          html.IFrameElement()
            ..src = widget.url
            ..style.border = 'none'
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.display = 'block'
            ..id = 'paypal-iframe-$id';

      // Set sandbox attribute using setAttribute
      iframe!.setAttribute(
        'sandbox',
        'allow-same-origin allow-scripts allow-forms allow-popups allow-top-navigation',
      );
      iframe!.setAttribute('allow', 'payment');

      // Handle iframe load
      iframe!.onLoad.listen((event) {
        print('🔄 Iframe loaded: ${iframe!.src}');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });

      // Handle iframe errors
      iframe!.onError.listen((event) {
        print('❌ Iframe error: $event');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });

      return iframe!;
    });
  }

  @override
  void dispose() {
    // Clean up event listeners
    html.window.removeEventListener('message', null);
    html.window.removeEventListener('paypal-success', null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayPal Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Debug info
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black87,
              padding: const EdgeInsets.all(8),
              child: Text(
                'URL: ${widget.url}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: HtmlElementView(viewType: viewId),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.white.withOpacity(0.8),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading PayPal...'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
