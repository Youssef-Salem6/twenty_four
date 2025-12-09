import 'package:flutter/material.dart';

class NewsLoading extends StatelessWidget {
  const NewsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(child: CircularProgressIndicator(color: theme.primaryColor)),
    );
  }
}
