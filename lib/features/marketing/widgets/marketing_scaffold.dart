import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'marketing_drawer.dart';

class MarketingScaffold extends StatelessWidget {
  const MarketingScaffold({super.key, required this.title, required this.body});

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          TextButton(onPressed: () => context.push('/login'), child: const Text('Sign in')),
          FilledButton(onPressed: () => context.push('/signup'), child: const Text('Get started')),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const MarketingDrawer(),
      body: SafeArea(child: body),
    );
  }
}
