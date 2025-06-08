// app_routing.dart
import 'package:flutter/material.dart';
import 'package:frontend/view/bookingparkir_view.dart';
import 'package:frontend/view/pembayaran_view.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/view/dashboard.dart';
import 'package:frontend/view/report_view.dart';
import 'package:frontend/view/login_view.dart';
import 'package:frontend/view/register_view.dart';
import 'package:frontend/view/report_list_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
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
      path: '/reportlist',
      builder: (context, state) => const ReportListView(),
    ),
    GoRoute(
      path: '/bookingparkir',
      builder: (context, state) => const bookingparkir(),
    ),
    GoRoute(
        path: '/pembayaran',
        builder: (context, state) {
          // Receive the extra data passed from previous screen
          final bookingData = state.extra as Map<String, dynamic>?;
          return pembayaran(bookingData: bookingData);
        }),
  ],

  // Error page
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);
