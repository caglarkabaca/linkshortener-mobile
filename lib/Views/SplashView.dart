import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Core/LocalStorage.dart';
import 'package:link_shortener_mobile/Views/LoginView.dart';
import 'package:link_shortener_mobile/Views/MainView.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isToken = await LocalStorage().checkToken();
      if (isToken) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const MainView()));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const LoginView()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Link Shortener Yükleniyor..'),
            SizedBox(
              height: 10,
            ),
            CircularProgressIndicator(
              backgroundColor: Color(0xff800080),
              strokeWidth: 8,
            ),
          ],
        ),
      ),
    );
  }
}
