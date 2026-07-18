import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MarketingDrawer extends StatelessWidget {
  const MarketingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    void goTo(String path) {
      Navigator.of(context).pop();
      context.go(path);
    }

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: scheme.primaryContainer),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'SURSO',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            ListTile(leading: const Icon(Icons.home_outlined), title: const Text('Home'), onTap: () => goTo('/')),
            ListTile(leading: const Icon(Icons.bolt_outlined), title: const Text('Features'), onTap: () => goTo('/features')),
            ListTile(leading: const Icon(Icons.info_outline), title: const Text('About'), onTap: () => goTo('/about-us')),
            ListTile(leading: const Icon(Icons.mail_outline), title: const Text('Contact'), onTap: () => goTo('/contact')),
            ListTile(leading: const Icon(Icons.support_agent_outlined), title: const Text('Support'), onTap: () => goTo('/support')),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Sign in'),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/login');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add_outlined),
              title: const Text('Sign up'),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/signup');
              },
            ),
          ],
        ),
      ),
    );
  }
}
