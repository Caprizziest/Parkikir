// app_routing.dart
import 'package:flutter/material.dart';
import 'package:frontend/view/bookingparkir_view.dart';
import 'package:frontend/view/history_view.dart';
import 'package:frontend/view/pembayaran_view.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/view/dashboard.dart';
import 'package:frontend/view/report_view.dart';
import 'package:frontend/view/login_view.dart';
import 'package:frontend/view/register_view.dart';
import 'package:frontend/view/report_list_view.dart';
import 'package:frontend/view/notice_list_view.dart';
import 'package:frontend/view/notice_detail_view.dart';
import 'package:frontend/view/report_detail_view.dart';
import 'package:frontend/view/profile_view.dart';
import 'package:frontend/view/main_shell.dart';
import 'package:frontend/view/payment_view.dart';
import 'package:frontend/view/success_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/register',
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

    // Shell route for main navigation
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardView(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardView(),
        ),
        GoRoute(
          path: '/history',
          name: 'history',
          builder: (context, state) => const HistoryView(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileView(),
        ),
      ],
    ),

    // Routes outside shell (no navbar)
    GoRoute(
      path: '/report',
      builder: (context, state) => const report_view(),
    ),
    GoRoute(
      path: '/reportlist',
      builder: (context, state) => const ReportListView(),
    ),
    GoRoute(
      path: '/reportdetail/:reportId',
      name: 'reportDetail',
      builder: (context, state) {
        final reportId = int.parse(state.pathParameters['reportId']!);
        return ReportDetailView(reportId: reportId);
      },
    ),
    GoRoute(
      path: '/noticelist',
      builder: (context, state) => const NoticeListView(),
    ),
    GoRoute(
      path: '/noticedetail/:noticeId',
      name: 'noticeDetail',
      builder: (context, state) {
        final noticeId = int.parse(state.pathParameters['noticeId']!);
        return NoticeDetailView(noticeId: noticeId);
      },
    ),
    GoRoute(
      path: '/bookingparkir',
      builder: (context, state) => const bookingparkir(),
    ),
GoRoute(
  path: '/pembayaran',
  builder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    return PaymentView(
      selectedSpot: extra?['selectedSpot'] ?? '',
      price: extra?['price'] ?? 0.0,
    );
  },
),
    GoRoute(
      path: '/success',
      builder: (context, state) => const SuccessView(),
    ),
  ],

  // Error page
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error: ${state.error}'),
    ),
  ),
);
