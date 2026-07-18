import 'package:flutter/material.dart';

import '../widgets/contact_form.dart';
import '../widgets/marketing_scaffold.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return MarketingScaffold(
      title: 'Support',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('How can we help?', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'Have a question or ran into an issue? Send us a message and we\'ll get back to you as soon as we can.',
            style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          const ContactForm(),
        ],
      ),
    );
  }
}
