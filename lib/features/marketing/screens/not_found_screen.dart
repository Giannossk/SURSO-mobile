import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '404',
                  style: theme.textTheme.displayLarge?.copyWith(color: scheme.primary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('This page doesn\'t exist.', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(
                  'The link you followed might be broken or the page may have been removed. '
                  'Head back to the homepage or explore what\'s happening next.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilledButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.home_outlined),
                      label: const Text('Back to home'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () => context.go('/features'),
                      child: const Text('Explore features'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
