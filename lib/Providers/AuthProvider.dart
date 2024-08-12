import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:link_shortener_mobile/Core/HttpBase.dart';
import 'package:link_shortener_mobile/Core/LocalStorage.dart';
import 'package:link_shortener_mobile/Core/MainHub.dart';
import 'package:link_shortener_mobile/Models/DTO/ErrorResponseDTO.dart';
import 'package:link_shortener_mobile/Models/DTO/VerifySmsDTO.dart';
import 'package:link_shortener_mobile/Providers/AuthService.dart';
import 'package:link_shortener_mobile/Views/MainView.dart';
import 'package:link_shortener_mobile/Views/SplashView.dart';

import '../Views/RegisterView.dart';

class AuthProvider extends ChangeNotifier {
  final _service = AuthService();

  late dynamic _response;

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

  Future<void> logout(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final response = await LocalStorage().clearToken();
    await MainHub().Disconnect();

    isLoading = false;

    if (response) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const SplashView()));
    } else {
      notifyListeners();
    }
  }

  Future<void> register(BuildContext context, String email, String username,
      String password) async {
    await resetState();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SmsVerifyWidget(),
      ),
    ).then((value) async {
      if (value != null || value != false) {
        isLoading = true;
        notifyListeners();

        final response = await _service
            .registerService(username, password, email, value, onError: (dto) {
          errorDto = dto;
        });

        if (response != null) {
          isLoading = false;
          notifyListeners();
          Navigator.pop(context, response);
        } else {
          _response = response;
          isLoading = false;
          notifyListeners();
        }
      }
    });
  }

  Future<void> verifyPhoneNumber(BuildContext context, String phone_number,
      {bool resend = false, int? resendToken}) async {
    await resetState();

    isLoading = true;
    notifyListeners();

    await FirebaseAuth.instance.verifyPhoneNumber(
      forceResendingToken: resendToken,
      phoneNumber: phone_number,
      verificationCompleted: (PhoneAuthCredential credential) {
        print("completed");
        Navigator.pop(context, phone_number);
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
                  verifyId: verificationId),
            ),
          ).then((value) {
            if (value == true) {
              Navigator.pop(context, phone_number);
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
