import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NewsError extends StatelessWidget {
  final String message;
  final VoidCallback onBackPressed;

  const NewsError({
    super.key,
    required this.message,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            const Gap(16),
            Text(message, style: theme.textTheme.titleMedium),
            const Gap(8),
            ElevatedButton(
              onPressed: onBackPressed,
              child: const Text('العودة'),
            ),
          ],
        ),
      ),
    );
  }
}
