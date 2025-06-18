import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/viewmodel/auth_view_model.dart';
import 'package:frontend/routing/router.dart';

class AppWrapper extends ConsumerStatefulWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends ConsumerState<AppWrapper> {
  @override
  void initState() {
    super.initState();
    // Initialize auth pada startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider).initialize();
    });
  }

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
      routerConfig: appRouter,
    );
  }
}
