import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/auth_provider.dart';
import '../../features/auth/auth_state.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/profile_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/admin/screens/admin_home_screen.dart';
import '../../features/customer/screens/customer_home_screen.dart';
import '../../features/customer/screens/ticket_detail_screen.dart';
import '../../features/events/screens/event_detail_screen.dart';
import '../../features/marketing/screens/about_screen.dart';
import '../../features/marketing/screens/contact_screen.dart';
import '../../features/marketing/screens/features_screen.dart';
import '../../features/marketing/screens/home_screen.dart';
import '../../features/marketing/screens/not_found_screen.dart';
import '../../features/marketing/screens/pricing_screen.dart';
import '../../features/marketing/screens/support_screen.dart';
import '../../features/marketing/screens/thank_you_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/organizer/screens/organizer_home_screen.dart';
import '../widgets/splash_screen.dart';

part 'app_router.g.dart';

const authOnlyRoutes = {'/login', '/signup', '/forgot-password'};
const marketingRoutes = {'/', '/features', '/pricing', '/about-us', '/contact', '/support', '/thank-you'};
const publicRoutes = {...authOnlyRoutes, ...marketingRoutes};

class _GoRouterRefreshNotifier extends ChangeNotifier {
  _GoRouterRefreshNotifier(Ref ref) {
    ref.listen(authProvider, (_, _) => notifyListeners());
  }
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final refresh = _GoRouterRefreshNotifier(ref);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final authAsync = ref.read(authProvider);
      final location = state.matchedLocation;

      if (authAsync.isLoading) {
        return location == '/splash' ? null : '/splash';
      }

      final authState = authAsync.value;
      final isAuthenticated = authState is AuthAuthenticated;

      if (!isAuthenticated) {
        if (publicRoutes.contains(location)) return null;
        return location == '/splash' ? '/' : '/login';
      }

      // Authenticated: keep users off the splash, auth screens, and marketing home.
      if (location == '/splash' || authOnlyRoutes.contains(location) || location == '/') {
        return _homeFor((authState).user.role);
      }
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/features', builder: (context, state) => const FeaturesScreen()),
      GoRoute(path: '/pricing', builder: (context, state) => const PricingScreen()),
      GoRoute(path: '/about-us', builder: (context, state) => const AboutScreen()),
      GoRoute(path: '/contact', builder: (context, state) => const ContactScreen()),
      GoRoute(path: '/support', builder: (context, state) => const SupportScreen()),
      GoRoute(path: '/thank-you', builder: (context, state) => const ThankYouScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
      GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
      GoRoute(path: '/customer', builder: (context, state) => const CustomerHomeScreen()),
      GoRoute(
        path: '/events/:id',
        builder: (context, state) => EventDetailScreen(eventId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/tickets/:id',
        builder: (context, state) => TicketDetailScreen(registrationId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/organizer', builder: (context, state) => const OrganizerHomeScreen()),
      GoRoute(path: '/admin', builder: (context, state) => const AdminHomeScreen()),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}

String _homeFor(String role) {
  switch (role) {
    case 'organizer':
      return '/organizer';
    case 'admin':
      return '/admin';
    default:
      return '/customer';
  }
}
