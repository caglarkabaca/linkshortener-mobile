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
    isLoading = true;
    notifyListeners();

    // await FirebaseAuth.instance.verifyPhoneNumber(
    //   phoneNumber: '+90 535 4635157',
    //   verificationCompleted: (PhoneAuthCredential credential) {
    //     print('completed');
    //   },
    //   verificationFailed: (FirebaseAuthException e) {
    //     print('failed');
    //   },
    //   codeSent: (String verificationId, int? resendToken) {
    //     print('codesent');
    //   },
    //   codeAutoRetrievalTimeout: (String verificationId) {
    //     print('timeout');
    //   },
    // );

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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SmsVerifyWidget()));
  }

  Future<void> verifyPhoneNumber(
      BuildContext context, String phone_number) async {
    isLoading = true;
    notifyListeners();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone_number,
      verificationCompleted: (PhoneAuthCredential credential) {
        print("completed");
        _response = VerifySmsDTO(status: VerifySms.COMPLETED);
        notifyListeners();
      },
      verificationFailed: (FirebaseAuthException e) {
        print("failed");
        _response = VerifySmsDTO(status: VerifySms.FAILED);
        notifyListeners();
      },
      codeSent: (String verificationId, int? resendToken) {
        print('codesent');
        _response = VerifySmsDTO(status: VerifySms.CODESENT);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyWidget(verifyId: verificationId),
          ),
        );
        isLoading = false;
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('timeout');
        _response = VerifySmsDTO(status: VerifySms.TIMEOUT);
        notifyListeners();
      },
    );
  }

  Future<void> verifyCode(String verificationId, String code) async {
    isLoading = true;
    notifyListeners();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: code);
    await FirebaseAuth.instance.signInWithCredential(credential);

    isLoading = false;
    notifyListeners();
  }

  Future<void> resetState() async {
    isLoading = false;
    errorDto = null;
    _response = null;
    notifyListeners();
  }
}
