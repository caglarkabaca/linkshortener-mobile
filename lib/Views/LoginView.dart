import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_shortener_mobile/Models/User.dart';
import 'package:link_shortener_mobile/Providers/AuthProvider.dart';
import 'package:link_shortener_mobile/Views/RegisterView.dart';
import 'package:provider/provider.dart';

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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Logo
              CircleAvatar(
                radius: 64,
                backgroundColor: colorScheme.surfaceTint,
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/icon.png'),
                  radius: 62,
                ),
              ),
              const SizedBox(height: 10),
              // Title
              const Text('Link Shortener', style: TextStyle(fontSize: 36)),
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
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Bir hesabınız yok mu?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SmsVerifyWidget(),
                        ),
                      ).then((value) {});
                    },
                    child: Text("Hesap Oluşturun"),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<AuthProvider>(builder: (context, value, child) {
                if (value.isLoading) {
                  return const CircularProgressIndicator(
                    strokeWidth: 8,
                  );
                }

                if (value.errorDto != null) {
                  return Text(
                    (value.errorDto!).error_message ?? "???",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
      child: FilledButton(
        onPressed: onPressed,
        style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        )),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
  final bool autoFocus;
  final bool required;
  final TextEditingController? matchController;

  const InputField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isPassword = false,
      this.required = true,
      this.autoFocus = false,
      this.matchController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        autofocus: autoFocus,
        validator: (value) {
          if (required == false) return null;
          if (value == null || value.isEmpty) return 'Bu alan boş olamaz.';
          if (matchController != null && matchController!.text != value)
            return 'Şifreler uyuşmuyor';
          return null;
        },
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 16,
            )),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
