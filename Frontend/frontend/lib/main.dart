import 'package:flutter/material.dart';
// import 'package:frontend/view/login.dart';
import 'package:frontend/view/report.dart';
import 'package:sentry_flutter/sentry_flutter.dart';



Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://0b83a48effc377ba8219a49ea3e759ee@o4509316345102336.ingest.us.sentry.io/4509316481417216';
      // Adds request headers and IP for users,
      // visit: https://docs.sentry.io/platforms/dart/data-management/data-collected/ for more info
      options.sendDefaultPii = true;
    },
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: const report_view(),
    );
  }
}



// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(
//       fontFamily: 'Poppins',
//     ),
//     home: const login(),
//   ));
// }
