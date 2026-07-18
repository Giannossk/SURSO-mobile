import 'package:flutter/material.dart';

import '../widgets/marketing_scaffold.dart';

class _Value {
  const _Value(this.icon, this.title, this.description);
  final IconData icon;
  final String title;
  final String description;
}

const _values = [
  _Value(Icons.psychology_alt_outlined, 'Curiosity',
      'We dig into real surgical research together in Journal Club, asking questions before we have all the answers.'),
  _Value(Icons.front_hand_outlined, 'Hands-On Learning',
      'From Ready, Set, Scrub In to our regular workshops, we believe surgical skill starts with doing, not just reading.'),
  _Value(Icons.handshake_outlined, 'Mentorship',
      'Meet the Experts connects us directly with surgical professionals who\'ve walked the path we\'re on.'),
  _Value(Icons.diversity_3_outlined, 'Community',
      'SURSO is a space for NKUA students who share one thing: a passion for surgery.'),
];

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return MarketingScaffold(
      title: 'About',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('About SURSO', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'The first student surgical team at NKUA — exploring the art of surgery, together.',
            style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.rocket_launch_outlined, color: scheme.primary, size: 32),
                  const SizedBox(height: 12),
                  Text('Our Mission', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'SURSO NKUA brings together National and Kapodistrian University of Athens medical students who share a passion for the surgical specialties. '
                    'Our mission is to help students explore the art of surgery through group activities, hands-on workshops, and direct interaction with professionals in the field — '
                    'from Journal Club discussions to our Meet the Experts interview series.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.flag_outlined, color: scheme.primary, size: 32),
                  const SizedBox(height: 12),
                  Text('Our Vision', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'Inspiring future surgeons. We want every student with a curiosity about surgery to find a community, mentors, '
                    'and real hands-on experience — long before they have to choose a specialty.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text('Our core values', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            'The principles that guide everything we do and every decision we make.',
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _values.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 170,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final v = _values[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(v.icon, color: scheme.primary),
                      const SizedBox(height: 8),
                      Text(v.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          v.description,
                          style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
