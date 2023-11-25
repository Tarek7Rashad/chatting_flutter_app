import 'package:flutter/material.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  const CustomTextFormFieldWidget({
    super.key,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
    this.onChanged,
    this.validate,
    required this.controller,
  });
  final String hintText;
  final String labelText;
  final bool obscureText;
  final Function(String)? onChanged;
  final String? Function(String?)? validate;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      validator: validate,
      style: const TextStyle(color: Colors.white, fontSize: 20),
      decoration: InputDecoration(
        constraints: BoxConstraints(maxHeight: 70),
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xfff7f7f7), fontSize: 20),
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xfff7f7f7), fontSize: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xfff7f7f7),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            width: 2,
            color: Color(0xfff7f7f7),
          ),
        ),
      ),
    );
  }
}
