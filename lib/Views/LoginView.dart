import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:link_shortener_mobile/Models/User.dart';
import 'package:link_shortener_mobile/Providers/AuthProvider.dart';
import 'package:link_shortener_mobile/Views/RegisterView.dart';
import 'package:link_shortener_mobile/Widgets/InputField.dart';
import 'package:link_shortener_mobile/Widgets/SmsVerifyWidget.dart';
import 'package:link_shortener_mobile/Widgets/SubmitButton.dart';
import 'package:phonenumbers/phonenumbers.dart';
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

  final _phoneController = PhoneNumberEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: const BottomAppBar(
          color: Colors.transparent,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.password)),
              Tab(icon: Icon(Icons.phone)),
            ],
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Center(
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
                    const Text('Link Shortener',
                        style: TextStyle(fontSize: 36)),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 175,
                      child: TabBarView(
                        children: [
                          // EMAİL PASSWORD LOGİN
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
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
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .login(context, userName, password);
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          // PHONE NUMBER LOGIN
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: PhoneNumberField(
                                  controller: _phoneController,
                                  countryCodeWidth: 50,
                                  decoration: const InputDecoration(
                                    hintText: "Telefon numaranız",
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Password field
                              const SizedBox(height: 15),
                              SubmitButton(
                                text: 'Giriş yap',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final phone_number =
                                        _phoneController.value!.formattedNumber;

                                    WidgetsBinding.instance
                                        .addPostFrameCallback((timeStamp) {
                                      Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .verifyPhoneNumber(
                                              context, phone_number,
                                              onSuccess: (phone_number) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((timeStamp) {
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .loginWithPhone(
                                                  context, phone_number);
                                        });
                                      });
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
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
                                builder: (context) => SmsVerifyWidget(
                                  onSuccess: (phone_number) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RegisterView(
                                            phoneNumber: phone_number),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ).then((value) {});
                          },
                          child: Text("Hesap Oluşturun"),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Consumer<AuthProvider>(
                          builder: (context, value, child) {
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
                      }),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
