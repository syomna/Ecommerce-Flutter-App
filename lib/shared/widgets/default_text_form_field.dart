import 'package:flutter/material.dart';

class DefaultTextFormField extends StatelessWidget {
  const DefaultTextFormField(
      {Key? key,
      required this.label,
      required this.controller,
      required this.prefixIcon,
      required this.validator,
      this.keyboardType,
      this.onSubmit,
      this.onIconPressed,
      this.isPassword = false,
      this.suffixIcon})
      : super(key: key);

  final TextEditingController controller;
  final ValueChanged<String>? onSubmit;
  final String? Function(String?)? validator;
  final String label;
  final TextInputType? keyboardType;
  final Function()? onIconPressed;
  final bool isPassword;
  final IconData? suffixIcon;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isPassword,
      keyboardType: keyboardType,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(suffixIcon),
          onPressed: onIconPressed,
        ),
        prefixIcon: Icon(prefixIcon),
        labelText: label,
      ),
    );
  }
}
