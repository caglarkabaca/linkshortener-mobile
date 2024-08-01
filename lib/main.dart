import 'dart:io';

import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Providers/AuthProvider.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkLogsProvider.dart';
import 'package:link_shortener_mobile/Providers/ShortLinkProvider.dart';
import 'package:link_shortener_mobile/Views/SplashView.dart';
import 'package:provider/provider.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ShortLinkProvider()),
        ChangeNotifierProvider(create: (context) => ShortLinkLogsProvider())
      ],
      child: const MaterialApp(
        title: 'Link Shortener',
        home: SplashView(),
        routes: {},
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
