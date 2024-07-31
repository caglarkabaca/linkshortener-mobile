import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Core/LocalStorage.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late String token = "dummy token";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() async {
        token = (await LocalStorage().getToken())!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              token,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                await LocalStorage().clearToken();
              });
            }, child: Text('Clear'))
          ],
        )
      ),
    );
  }
}
