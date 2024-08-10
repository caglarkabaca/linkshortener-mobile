import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:link_shortener_mobile/Providers/AuthProvider.dart';
import 'package:link_shortener_mobile/Views/LoginView.dart';
import 'package:phonenumbers/phonenumbers.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

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
                                .register(context, email, username, password);
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

class SmsVerifyWidget extends StatelessWidget {
  SmsVerifyWidget({
    super.key,
  });

  final _phoneController = PhoneNumberEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundColor: colorScheme.surfaceTint,
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/icon.png'),
                      radius: 62,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Kayıta devam etmek için SMS doğrulaması yapmanız gerekmektedir.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 5),
                  PhoneNumberField(
                    controller: _phoneController,
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Bu telefon numarası hesabınıza kaydedilecektir.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SubmitButton(
                    text: "Devam",
                    onPressed: () {
                      final phone_number =
                          _phoneController.value!.formattedNumber;

                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        Provider.of<AuthProvider>(context, listen: false)
                            .verifyPhoneNumber(context, phone_number);
                      });
                    },
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
                      if (value.response == null)
                        return const SizedBox();

                      return Text(
                        (value.response as String),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      );
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VerifyWidget extends StatelessWidget {
  VerifyWidget({required this.verifyId, super.key});

  final String verifyId;
  final _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: colorScheme.surfaceTint,
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/icon.png'),
                        radius: 62,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Gelen doğrulama kodunu giriniz.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 5),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      controller: _pinController,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Kod gelmedi mi ?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Tekrar gönder",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SubmitButton(
                      text: "Onayla",
                      onPressed: () {
                        WidgetsBinding.instance
                            .addPostFrameCallback((timeStamp) {
                          Provider.of<AuthProvider>(context, listen: false)
                              .verifyCode(context, verifyId, _pinController.text);
                        });
                      },
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
                        if (value.response == null)
                          return const SizedBox();

                        return Text(
                          (value.response as String),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      }
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
