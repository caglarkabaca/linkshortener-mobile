import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Core/HttpBase.dart';
import 'package:link_shortener_mobile/Core/LocalStorage.dart';
import 'package:link_shortener_mobile/Core/MainHub.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorResponseDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/UserRegisterRequestDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/VerifySmsDTO.dart';
import 'package:link_shortener_mobile/Providers/Services/AuthService.dart';
import 'package:link_shortener_mobile/Views/MainView.dart';
import 'package:link_shortener_mobile/Views/SplashView.dart';
import 'package:link_shortener_mobile/Widgets/SmsVerifyWidget.dart';
import 'package:provider/provider.dart';

import '../Views/RegisterView.dart';

class AuthProvider extends ChangeNotifier {
  final _service = AuthService();

  dynamic _response;

  dynamic get response => _response;
  bool isLoading = false;

  ErrorResponseDTO? errorDto;

  Future<void> login(
      BuildContext context, String userName, String password) async {
    await resetState();

    isLoading = true;
    notifyListeners();

    final response =
        await _service.loginService(userName, password, onError: (dto) {
      errorDto = dto;
    });

    _response = response;
    isLoading = false;

    if (response != null) {
      await LocalStorage().setToken(response.token!);
      await LocalStorage().setUser(response.user!);

      Httpbase().setToken(response.token ?? 'WTF MAN');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const MainView()),
      );
      await resetState();
      return;
    } else {
      notifyListeners();
    }
  }

  Future<void> loginWithPhone(BuildContext context, String phoneNumber) async {
    await resetState();

    isLoading = true;
    notifyListeners();

    final response =
        await _service.loginServiceWithPhone(phoneNumber, onError: (dto) {
      errorDto = dto;
    });

    _response = response;
    isLoading = false;

    if (response != null) {
      await LocalStorage().setToken(response.token!);
      await LocalStorage().setUser(response.user!);

      Httpbase().setToken(response.token ?? 'WTF MAN');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const MainView()),
      );
      await resetState();
      return;
    } else {
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final response = await LocalStorage().clearToken();
    Httpbase().setToken(null);
    await MainHub().Disconnect();

    isLoading = false;

    if (response) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const SplashView(),
        ),
      );
    } else {
      notifyListeners();
    }
  }

  Future<void> register(
      BuildContext context, UserRegisterRequestDTO registerDto) async {
    await resetState();

    isLoading = true;
    notifyListeners();

    final response =
        await _service.registerService(registerDto, onError: (dto) {
      errorDto = dto;
    });

    if (response != null) {
      isLoading = false;
      notifyListeners();
      Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);

      await LocalStorage().setToken(response.token!);
      await LocalStorage().setUser(response.user!);

      Httpbase().setToken(response.token ?? 'WTF MAN');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const MainView()),
      );
    } else {
      _response = response;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyPhoneNumber(BuildContext context, String phone_number,
      {required Function(String) onSuccess,
      bool resend = false,
      int? resendToken}) async {
    await resetState();

    isLoading = true;
    notifyListeners();

    await FirebaseAuth.instance.verifyPhoneNumber(
      forceResendingToken: resendToken,
      phoneNumber: phone_number,
      verificationCompleted: (PhoneAuthCredential credential) {
        print("completed");
        onSuccess(phone_number);

        // if (isRegister) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => RegisterView(phoneNumber: phone_number),
        //     ),
        //   );
        // } else {
        //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //     Provider.of<AuthProvider>(context, listen: false)
        //         .loginWithPhone(context, phone_number);
        //   });
        // }

        notifyListeners();
      },
      verificationFailed: (FirebaseAuthException e) {
        print("failed $e");
        _response = "Bir hata meydana geldi\nLütfen tekrar deneyiniz.";
        isLoading = false;
        notifyListeners();
      },
      codeSent: (String verificationId, int? resendToken) {
        print('codesent');
        isLoading = false;
        notifyListeners();

        if (resend == false) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyWidget(
                phoneNumber: phone_number,
                resendToken: resendToken,
                verifyId: verificationId,
                onSuccess: onSuccess,
              ),
            ),
          ).then((value) {
            if (value == true) {
              onSuccess(phone_number);
            }
          });
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('timeout');
        _response = "İstek zaman aşımına uğradı.";
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> verifyCode(
      BuildContext context, String verificationId, String code) async {
    await resetState();

    isLoading = true;
    notifyListeners();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: code);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);

      isLoading = false;
      notifyListeners();
      Navigator.pop(context, true);
    } catch (e) {
      _response = "Bir hata meydana geldi\nLütfen tekrar deneyiniz.";
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetState() async {
    isLoading = false;
    errorDto = null;
    _response = null;
    notifyListeners();
  }
}
