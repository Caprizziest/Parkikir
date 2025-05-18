// router.dart
import 'package:flutter/material.dart';
import 'package:frontend/view/parkingspot_view.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/view/dashboard.dart';
import 'package:frontend/view/report_view.dart';
import 'package:frontend/view/login_view.dart';
import 'package:frontend/view/register_view.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterView(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const dashboard_view(),
    ),
    GoRoute(
      path: '/report',
      builder: (context, state) => const report_view(),
    ),
      GoRoute(
    path: '/booking',
    name: 'booking',
    builder: (context, state) => const ParkingSpotScreen(),
  ),
  ],

  // Error page
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);
