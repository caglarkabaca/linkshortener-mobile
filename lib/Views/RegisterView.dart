import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Models/DTO/UserRegisterRequestDTO.dart';
import 'package:link_shortener_mobile/Providers/AuthProvider.dart';
import 'package:link_shortener_mobile/Views/LoginView.dart';
import 'package:link_shortener_mobile/Widgets/InputField.dart';
import 'package:link_shortener_mobile/Widgets/SubmitButton.dart';
import 'package:phonenumbers/phonenumbers.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({required this.phoneNumber, super.key});

  final String phoneNumber;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    Text('Link Shortener', style: TextStyle(fontSize: 36)),
                    const SizedBox(height: 20),
                    InputField(
                        controller: _emailController,
                        hintText: 'Email adresiniz'),
                    const SizedBox(height: 5),
                    InputField(
                        controller: _userNameController,
                        hintText: 'Kullanıcı adınız'),
                    const SizedBox(height: 5),
                    InputField(
                      controller: _passwordController,
                      hintText: 'Şifreniz',
                      isPassword: true,
                    ),
                    InputField(
                      controller: TextEditingController(),
                      hintText: 'Şifrenizi doğrulayın',
                      isPassword: true,
                      matchController: _passwordController,
                    ),
                    const SizedBox(height: 15),
                    SubmitButton(
                      text: 'Kayıt ol',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final password = _passwordController.text;
                          final username = _userNameController.text;
                          final email = _emailController.text;

                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            Provider.of<AuthProvider>(context, listen: false)
                                .register(
                              context,
                              UserRegisterRequestDTO(
                                  email: email,
                                  userName: username,
                                  password: password,
                                  phoneNumber: widget.phoneNumber),
                            );
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
      ),
    );
  }
}
