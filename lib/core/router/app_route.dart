import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pothole_mobile_app/features/auth/application/auth_notifier.dart';
import 'package:pothole_mobile_app/features/auth/presentation/pages/login_view.dart';
import 'package:pothole_mobile_app/features/auth/presentation/pages/register_view.dart';
import 'package:pothole_mobile_app/features/setting/presentation/pages/about_view.dart';
import 'package:pothole_mobile_app/features/setting/presentation/pages/change_password_view.dart';
import 'package:pothole_mobile_app/features/setting/presentation/pages/edit_profile_view.dart';
import 'package:pothole_mobile_app/features/setting/presentation/pages/profile_view.dart';
import 'package:pothole_mobile_app/navigation/navigationView.dart';

final authNotifierProvider = ChangeNotifierProvider((ref) {
  return AuthNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: auth,
    redirect: (context, state) {
      final isLoggedIn = auth.user != null;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/navigation';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: '/navigation',
        builder: (context, state) => const NavigationView(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutView(),
      ),
      GoRoute(
        path: '/edit_profile',
        builder: (context, state) => const EditProfileView(),
      ),
      GoRoute(
        path: '/change_password',
        builder: (context, state) => const ChangePasswordView(),
      ),
    ],
  );
});
