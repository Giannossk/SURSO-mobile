import 'package:flutter/material.dart';

import '../widgets/contact_form.dart';
import '../widgets/marketing_scaffold.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return MarketingScaffold(
      title: 'Contact',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Contact Us', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'Get in touch with the SURSO team. We\'re here to help with any questions about SURSO.',
            style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          const ContactForm(),
        ],
      ),
    );
  }
}
