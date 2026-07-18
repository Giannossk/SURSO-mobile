import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/marketing_scaffold.dart';

class _Step {
  const _Step(this.icon, this.title, this.content);
  final IconData icon;
  final String title;
  final String content;
}

const _steps = [
  _Step(Icons.rocket_launch_outlined, 'Plan & Organize',
      'SURSO\'s team sets up Journal Club sessions, Meet the Experts panels, and workshops from one dashboard.'),
  _Step(Icons.groups_outlined, 'Coordinate the Team',
      'Roles are assigned so every organizer knows exactly what they own, from setup to wrap-up.'),
  _Step(Icons.trending_up_outlined, 'Run & Track',
      'Check attendees in, track engagement, and issue certificates once an activity wraps.'),
];

const _faqs = [
  (
    q: 'What is SURSO?',
    a: 'SURSO NKUA is the Surgical Society of Medical Students at the National and Kapodistrian University of Athens — the first student surgical team bringing together students with a shared passion for the surgical specialties. We explore the art of surgery through group activities, workshops, and interactions with professionals in the field.',
  ),
  (
    q: 'Who can join SURSO?',
    a: 'SURSO is open to NKUA medical students who share a passion for the surgical specialties and want to get closer to the field through hands-on activities, talks, and mentorship from professionals.',
  ),
  (
    q: 'What activities does SURSO run?',
    a: 'We run a mix of recurring activities: Journal Club, where we discuss current surgical research; Meet the Experts, our ongoing interview and panel series with surgical professionals (now at volume 7); Ready, Set, Scrub In, a hands-on skills workshop; and regular workshops and talks throughout the year.',
  ),
  (
    q: 'How do I become a member?',
    a: 'Sign up in the app to create your account and register for SURSO activities. Follow us on Instagram (@surso_uoa) for announcements about upcoming activities.',
  ),
  (
    q: 'Where can I follow SURSO?',
    a: 'You can find us on Instagram, Facebook, LinkedIn, YouTube, and TikTok.',
  ),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return MarketingScaffold(
      title: 'SURSO',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Explore the Art of '),
                TextSpan(text: 'Surgery', style: TextStyle(color: scheme.primary)),
              ],
            ),
            style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'SURSO NKUA is the first student surgical team at the National and Kapodistrian University of Athens — bringing together students with a shared passion for the surgical specialties. Through Journal Club, Meet the Experts, hands-on workshops, and talks with professionals in the field, we\'re inspiring future surgeons.',
            style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => context.push('/signup'),
                  child: const Text('Get started'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.push('/login'),
                  child: const Text('Sign in'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text('How SURSO works', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          for (final step in _steps)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: scheme.primaryContainer,
                    foregroundColor: scheme.onPrimaryContainer,
                    child: Icon(step.icon),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(step.content, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 32),
          Text('Frequently asked questions', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          for (final faq in _faqs)
            ExpansionTile(
              title: Text(faq.q, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(faq.a, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant))],
            ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text('Still have questions?', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('We\'re here to help you.', style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                const SizedBox(height: 12),
                FilledButton(onPressed: () => context.push('/support'), child: const Text('Contact support')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
