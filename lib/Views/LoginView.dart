import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_shortener_mobile/Providers/AuthProvider.dart';
import 'package:provider/provider.dart';

const color1 = Color(0xffeabfff);
const color2 = Color(0xff3c005a);
const color3 = Color(0xff800080);
const color4 = Color(0xffd580ff);
const colorBackground = Color(0xfffff3fd);

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Logo
              const CircleAvatar(
                radius: 64,
                backgroundImage: AssetImage('assets/icon.png'),
              ),
              const SizedBox(height: 10),
              // Title
              const Text(
                'Link Shortener',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 20),
              // Username field
              InputField(
                  controller: _userNameController,
                  hintText: 'Kullanıcı adınız'),
              const SizedBox(height: 5),
              // Password field
              InputField(
                controller: _passwordController,
                hintText: 'Şifreniz',
                isPassword: true,
              ),
              const SizedBox(height: 15),
              SubmitButton(
                text: 'Giriş yap',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final userName = _userNameController.text;
                    final password = _passwordController.text;
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      Provider.of<AuthProvider>(context, listen: false)
                          .login(context, userName, password);
                    });
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<AuthProvider>(builder: (context, value, child) {
                if (value.isLoading) {
                  return const CircularProgressIndicator(
                    backgroundColor: color3,
                    strokeWidth: 8,
                  );
                }

                if (value.errorDto != null) {
                  return Text(
                    (value.errorDto!).error_message ?? "???",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  );
                } else {
                  return const SizedBox(
                    height: 0,
                  );
                }
              })
            ]),
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  final String text;

  final VoidCallback onPressed;

  SubmitButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(color2),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            )),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String hintText;

  final TextEditingController controller;
  final bool isPassword;

  const InputField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) return 'Bu alan boş olamaz.';
          return null;
        },
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black38,
            )),
        style: const TextStyle(
            fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w600),
      ),
    );
  }
}
