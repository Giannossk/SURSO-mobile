import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/marketing_scaffold.dart';

class _Tier {
  const _Tier({
    required this.name,
    required this.price,
    required this.tagline,
    required this.features,
    required this.ctaLabel,
    required this.ctaPath,
    this.badge,
  });

  final String name;
  final String price;
  final String tagline;
  final List<String> features;
  final String ctaLabel;
  final String ctaPath;
  final String? badge;
}

const _tiers = [
  _Tier(
    name: 'Community',
    price: 'Free',
    tagline: 'Best for small clubs & meetups',
    features: ['Unlimited free events', 'Registrations & QR check-in', 'Digital certificates', 'Email support'],
    ctaLabel: 'Get started',
    ctaPath: '/signup',
  ),
  _Tier(
    name: 'Organizer Pro',
    price: '₹999/event',
    tagline: 'For growing communities and conferences',
    features: [
      'Everything in Community',
      'Co-organizer roles',
      'Real-time analytics',
      'Priority support',
      'Custom event branding',
    ],
    ctaLabel: 'Get started',
    ctaPath: '/signup',
    badge: 'Most popular',
  ),
  _Tier(
    name: 'Enterprise',
    price: 'Custom',
    tagline: 'For large organizations',
    features: [
      'Dedicated account manager',
      'Multi-organization management',
      'White-label certificates',
      '24/7 support',
    ],
    ctaLabel: 'Contact sales',
    ctaPath: '/contact',
  ),
];

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return MarketingScaffold(
      title: 'Pricing',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Choose your plan', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'From community meetups to enterprise conferences — a plan for every stage.',
            style: theme.textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          for (final tier in _tiers)
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: tier.badge != null ? scheme.primary : scheme.outlineVariant, width: tier.badge != null ? 2 : 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tier.badge != null) ...[
                      Chip(
                        label: Text(tier.badge!),
                        backgroundColor: scheme.primaryContainer,
                        labelStyle: TextStyle(color: scheme.onPrimaryContainer, fontWeight: FontWeight.w600),
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(height: 12),
                    ],
                    Text(tier.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(tier.tagline, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                    const SizedBox(height: 16),
                    Text(tier.price, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: scheme.primary)),
                    const SizedBox(height: 16),
                    for (final feature in tier.features)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle, size: 18, color: scheme.primary),
                            const SizedBox(width: 8),
                            Expanded(child: Text(feature, style: theme.textTheme.bodyMedium)),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => context.push(tier.ctaPath),
                        child: Text(tier.ctaLabel),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
