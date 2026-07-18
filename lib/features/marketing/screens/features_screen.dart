import 'package:flutter/material.dart';

import '../widgets/marketing_scaffold.dart';

class _Benefit {
  const _Benefit(this.icon, this.title, this.description);
  final IconData icon;
  final String title;
  final String description;
}

const _programs = [
  _Benefit(Icons.menu_book_outlined, 'Journal Club',
      'Our recurring discussion group where we dig into current surgical research together.'),
  _Benefit(Icons.record_voice_over_outlined, 'Meet the Experts',
      'An ongoing interview and panel series with real surgical professionals — now in its 7th volume.'),
  _Benefit(Icons.clean_hands_outlined, 'Ready, Set, Scrub In',
      'A hands-on workshop where you practice real surgical skills in a guided, beginner-friendly setting.'),
  _Benefit(Icons.campaign_outlined, 'Workshops & Talks',
      'Regular sessions and talks that bring you closer to the surgical specialties.'),
];

const _benefits = [
  _Benefit(Icons.event_available_outlined, 'Event Creation & Management',
      'Set up events with dates, venues, capacity, pricing, and posters in minutes.'),
  _Benefit(Icons.groups_2_outlined, 'Team & Co-Organizer Roles',
      'Our team shares event management duties across roles, so everyone knows what they own.'),
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
          Text('Our Programs', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'The recurring activities that bring SURSO\'s community together.',
            style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _programs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: 140,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final p = _programs[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: scheme.primaryContainer,
                        foregroundColor: scheme.onPrimaryContainer,
                        child: Icon(p.icon),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text(p.description, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Text('How We Run Them', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'The tools our own team uses to plan and run every SURSO event.',
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
