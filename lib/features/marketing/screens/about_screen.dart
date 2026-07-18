import 'package:flutter/material.dart';

import '../widgets/marketing_scaffold.dart';

class _Value {
  const _Value(this.icon, this.title, this.description);
  final IconData icon;
  final String title;
  final String description;
}

const _values = [
  _Value(Icons.lightbulb_outline, 'Innovation',
      'We keep pushing on what an event platform can do, from live check-ins to real-time analytics.'),
  _Value(Icons.groups_outlined, 'Collaboration',
      'Events are a team sport — co-organizer roles and shared dashboards keep everyone aligned.'),
  _Value(Icons.auto_awesome_outlined, 'Excellence',
      'From registration to certificates, every step should feel reliable and polished.'),
  _Value(Icons.public_outlined, 'Impact',
      'We measure success by the events our organizers pull off, and the communities they bring together.'),
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
            'Building the future of event management for communities, campuses, and organizations.',
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
                    'Our mission is to give organizers everything they need to plan, run, and grow impactful events — '
                    'from registration to certificates — without the chaos of juggling five different tools.',
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
                    'We envision a world where any community, big or small, can run a professional, well-organized '
                    'event without needing a technical team.',
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
