import 'package:flutter/material.dart';

import '../widgets/marketing_scaffold.dart';

class _Benefit {
  const _Benefit(this.icon, this.title, this.description);
  final IconData icon;
  final String title;
  final String description;
}

const _benefits = [
  _Benefit(Icons.event_available_outlined, 'Event Creation & Management',
      'Set up events with dates, venues, capacity, pricing, and posters in minutes.'),
  _Benefit(Icons.groups_2_outlined, 'Team & Co-Organizer Roles',
      'Share event management duties with collaborators without giving up full account access.'),
  _Benefit(Icons.qr_code_scanner_outlined, 'QR Check-In',
      'Scan attendee tickets at the door for instant, contactless check-in.'),
  _Benefit(Icons.notifications_active_outlined, 'Real-Time Notifications',
      'Keep attendees and organizers in sync with live updates as things happen.'),
  _Benefit(Icons.workspace_premium_outlined, 'Certificates',
      'Auto-generate and distribute certificates to attendees once an event wraps up.'),
  _Benefit(Icons.insights_outlined, 'Analytics Dashboard',
      'Track registrations, attendance, and engagement in real time.'),
];

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return MarketingScaffold(
      title: 'Features',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Key benefits', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'Everything you need to plan, run, and grow impactful events — in one platform.',
            style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _benefits.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: 140,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final b = _benefits[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: scheme.primaryContainer,
                        foregroundColor: scheme.onPrimaryContainer,
                        child: Icon(b.icon),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text(b.description, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                          ],
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
