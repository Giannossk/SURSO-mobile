import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/network/socket_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/auth_state.dart';

void main() {
  runApp(const ProviderScope(child: SursoApp()));
}

class SursoApp extends ConsumerWidget {
  const SursoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    ref.listen(authProvider, (previous, next) {
      final user = next.value;
      final socket = ref.read(socketServiceProvider);
      if (user is AuthAuthenticated) {
        socket.connect(user.user.id);
      } else if (user is AuthUnauthenticated) {
        socket.disconnect();
      }
    });

    return MaterialApp.router(
      title: 'SURSO',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
