import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/dashboard/presentation/screens/home_screen.dart';
import 'features/dashboard/presentation/screens/rider_details_screen.dart';
import 'features/auth/presentation/providers/auth_providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/rider/:id',
        name: 'rider-details',
        builder: (context, state) {
          final riderId = int.parse(state.pathParameters['id']!);
          return RiderDetailsScreen(riderId: riderId);
        },
      ),
    ],
    redirect: (context, state) {
      final container = ProviderScope.containerOf(context);
      final authState = container.read(authControllerProvider);
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';
      final isSplash = state.matchedLocation == '/splash';

      // If on splash, let it handle navigation
      if (isSplash) {
        return null;
      }

      // If not logged in and not on login, go to login
      if (!isLoggedIn && !isLoggingIn) {
        return '/login';
      }

      // If logged in and on login, go to home
      if (isLoggedIn && isLoggingIn) {
        return '/home';
      }

      return null;
    },
  );
});

