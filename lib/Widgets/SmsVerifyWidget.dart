import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Providers/AuthProvider.dart';
import 'package:link_shortener_mobile/Widgets/SubmitButton.dart';
import 'package:phonenumbers/phonenumbers.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class SmsVerifyWidget extends StatelessWidget {
  SmsVerifyWidget({
    required this.onSuccess,
    super.key,
  });

  final _phoneController = PhoneNumberEditingController();
  final Function(String) onSuccess;

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
                            .verifyPhoneNumber(context, phone_number,
                                onSuccess: onSuccess);
                      });
                    },
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
                        if (value.response == null) return const SizedBox();

                        return Text(
                          (value.response as String),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        );
                      }
                    }),
                  )
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
  VerifyWidget(
      {required this.verifyId,
      required this.phoneNumber,
      required this.resendToken,
      required this.onSuccess,
      super.key});

  final String verifyId;
  final String phoneNumber;
  final int? resendToken;
  final Function onSuccess;
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
                            onPressed: () {
                              WidgetsBinding.instance
                                  .addPostFrameCallback((timeStamp) {
                                Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .verifyPhoneNumber(context, phoneNumber,
                                        resendToken: resendToken,
                                        resend: true,
                                        onSuccess: (phone_number) =>
                                            onSuccess(phone_number));
                              });
                            },
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
                              .verifyCode(
                                  context, verifyId, _pinController.text);
                        });
                      },
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
                          if (value.response == null) return const SizedBox();

                          return Text(
                            (value.response as String),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          );
                        }
                      }),
                    )
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
