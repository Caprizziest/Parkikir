import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:frontend/routing/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      // Use GoRouter for navigation
      routerConfig: appRouter,
    );
  }
}
