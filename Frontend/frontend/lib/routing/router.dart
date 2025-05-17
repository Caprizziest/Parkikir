// app_routing.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/view/dashboard.dart';
import 'package:frontend/view/report_view.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const dashboard_view(),
      ),
      GoRoute(
        path: '/report',
        builder: (context, state) => const report_view(),
      ),
    ],
  );

  // Helper methods for navigation
  static void goToReport(BuildContext context) {
    context.push('/report');
  }

  static void goBack(BuildContext context) {
    context.pop();
  }
}
