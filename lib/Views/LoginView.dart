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
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              // Logo
              const CircleAvatar(
                radius: 64,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/icon.png'),
                  radius: 60,
                ),
              ),
              const SizedBox(height: 10),
              // Title
              Text(
                'Link Shortener',
                style: textTheme.displayMedium,
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
                    strokeWidth: 8,
                  );
                }

                if (value.errorDto != null) {
                  return Text(
                    (value.errorDto!).error_message ?? "???",
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

  const InputField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isPassword = false,
      this.required = true,
      this.autoFocus = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        autofocus: autoFocus,
        validator: (value) {
          if (required == false) return null;
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
            )),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
