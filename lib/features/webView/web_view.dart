import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  final String url;

  const WebView({super.key, this.url = 'https://flutter.dev'});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController _controller;
  bool isLoading = true;
  String pageTitle = '';

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) {
                setState(() {
                  isLoading = true;
                });
              },
              onPageFinished: (url) async {
                setState(() {
                  isLoading = false;
                });
                // Get page title
                final title = await _controller.getTitle();
                setState(() {
                  pageTitle = title ?? '';
                });
              },
              // onWebResourceError: (error) {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text('Error: ${error.description}')),
              //   );
              // },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle.isEmpty ? 'WebView' : pageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _controller.reload(),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'back',
            mini: true,
            onPressed: () async {
              if (await _controller.canGoBack()) {
                _controller.goBack();
              }
            },
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'forward',
            mini: true,
            onPressed: () async {
              if (await _controller.canGoForward()) {
                _controller.goForward();
              }
            },
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
