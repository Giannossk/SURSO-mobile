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
  _Step(Icons.rocket_launch_outlined, 'Create & Plan',
      'Set up events with dates, venues, registrations, and schedules all from a single dashboard. No chaos, just clarity.'),
  _Step(Icons.groups_outlined, 'Collaborate & Manage',
      'Assign roles, coordinate volunteers, and collaborate in real time. Everyone knows their task, every time.'),
  _Step(Icons.trending_up_outlined, 'Launch & Track',
      'Go live with confidence. Track registrations, engagement, and attendance, and auto-generate certificates once it\'s done.'),
  _Step(Icons.workspace_premium_outlined, 'Trusted by Communities',
      'Trusted by communities like GDG Jalandhar, AWS Cloud Clubs, and Coding Ninjas — 5+ successful events and counting.'),
];

class _Testimonial {
  const _Testimonial(this.text, this.name, this.role);
  final String text;
  final String name;
  final String role;
}

const _testimonials = [
  _Testimonial(
    'SURSO revolutionized how we organize our tech conferences. The ticketing and scheduling features are flawless.',
    'Gurjot Singh',
    'Event Organizer',
  ),
  _Testimonial(
    'Finally an event platform that doesn\'t feel clunky. SURSO is sleek, fast, and our attendees loved the check-in process.',
    'Amanpreet Kaur',
    'Community Manager',
  ),
  _Testimonial(
    'We managed 500+ attendees with zero hiccups. SURSO\'s dashboard gave us real-time insights that saved the day.',
    'Simar Preet Singh',
    'Conference Director',
  ),
  _Testimonial(
    'Setting up our annual summit took minutes instead of days. SURSO handles everything from registration to post-event feedback.',
    'Tracy Wang',
    'Meetup Host',
  ),
  _Testimonial(
    'The best investment for our community meetups. SURSO makes it incredibly easy to manage RSVPs and communicate with members.',
    'Vedant Gaidhanne',
    'Event Planner',
  ),
  _Testimonial(
    'Design is important to us, and SURSO looks beautiful out of the box. It matches our brand perfectly.',
    'Suraj Mani',
    'Marketing Lead',
  ),
];

const _faqs = [
  (
    q: 'What makes SURSO unique?',
    a: 'SURSO is purpose-built for communities and organizations to host events end-to-end. From event creation and registrations to team roles, certificates, and analytics — everything is managed in one fast, simple, and intuitive platform.',
  ),
  (
    q: 'Who can use SURSO?',
    a: 'SURSO is ideal for student communities, tech clubs, colleges, startups, and organizations. Whether you\'re hosting meetups, workshops, hackathons, or large-scale events, SURSO adapts to your needs.',
  ),
  (
    q: 'What features does SURSO provide?',
    a: 'SURSO offers event creation, registrations, automated notifications, team and role management, certificate distribution, user profiles, and a powerful admin dashboard with real-time analytics.',
  ),
  (
    q: 'How can I get started with SURSO?',
    a: 'Getting started is simple — sign up, create your organization, and launch your first event in minutes. Our intuitive interface ensures you can manage everything without any technical complexity.',
  ),
  (
    q: 'Is SURSO free to use?',
    a: 'Yes! SURSO offers a free plan suitable for most communities. You can host events, manage participants, and distribute certificates without worrying about hidden costs.',
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
                const TextSpan(text: 'Run Events '),
                TextSpan(text: 'Smarter', style: TextStyle(color: scheme.primary)),
              ],
            ),
            style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'A modern event management platform designed to help organizations plan, manage, and host impactful events with ease. '
            'Trusted by GDG Jalandhar, AWS Cloud Clubs, and Coding Ninjas.',
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
          const SizedBox(height: 24),
          Text('What our users say', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            'From intimate meetups to global conferences, SURSO powers the world\'s most successful events.',
            style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _testimonials.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final t = _testimonials[index];
                return SizedBox(
                  width: 280,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: List.generate(5, (_) => Icon(Icons.star, size: 16, color: scheme.primary))),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              t.text,
                              style: theme.textTheme.bodySmall,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(radius: 14, child: Text(t.name.characters.first)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(t.name, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                                    Text(t.role, style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
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
