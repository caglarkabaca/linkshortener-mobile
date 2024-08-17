import 'package:flutter/material.dart';

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
