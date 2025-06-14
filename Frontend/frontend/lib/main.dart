import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:frontend/routing/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'viewmodel/bookingparkir_view_model.dart';
import 'view/pembayaran_view.dart'; // Pastikan ini juga ada jika diperlukan

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://0b83a48effc377ba8219a49ea3e759ee@o4509316345102336.ingest.us.sentry.io/4509316481417216';
      options.sendDefaultPii = true;
    },
    appRunner: () => runApp(
      // Wrap with ProviderScope for Riverpod
      const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ParkirKi',
      theme: ThemeData(
        primaryColor: const Color(0xFF4B4BEE),
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        fontFamily: 'Poppins',
      ),
      routerConfig:
          appRouter, // appRouter Anda sudah ada di file routing/router.dart
    );
  }
}

// Pastikan appRouter di `frontend/routing/router.dart` juga diperbarui untuk mengarah ke BookingparkirViewModel
// Contoh (Anda harus menyesuaikannya dengan implementasi Anda):
// Dalam router.dart:
/*
import 'package:go_router/go_router.dart';
import 'package:frontend/view/bookingparkir.dart';
import 'package:frontend/view/pembayaran_view.dart'; // jika ada

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Placeholder(), // Ganti dengan halaman utama Anda
    ),
    GoRoute(
      path: '/bookingparkir',
      builder: (context, state) => const bookingparkir(), // bookingparkir akan menggunakan BookingparkirViewModel
    ),
    GoRoute(
      path: '/pembayaran',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final selectedSpot = args?['selectedSpot'] as String?;
        final price = args?['price'] as double?;
        return PembayaranView(
          selectedSpot: selectedSpot ?? 'N/A',
          price: price ?? 0.0,
        );
      },
    ),
  ],
);
*/