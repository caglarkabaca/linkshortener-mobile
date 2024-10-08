import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart';
import 'package:link_shortener_mobile/Providers/AuthProvider.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkLogsProvider.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkProvider.dart';
import 'package:link_shortener_mobile/Providers/ThemeProvider.dart';
import 'package:link_shortener_mobile/Views/SplashView.dart';
import 'package:link_shortener_mobile/theme.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HttpOverrides.global = new MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Montserrat", "Nunito");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ShortLinkProvider()),
        ChangeNotifierProvider(create: (context) => ShortLinkLogsProvider()),
        ChangeNotifierProvider(create: (context) => ShortLinkCreateProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider(theme))
      ],
      builder: (context, child) => MaterialApp(
        title: 'Link Shortener',
        home: const SplashView(),
        theme: Provider.of<ThemeProvider>(context).themeData,
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
