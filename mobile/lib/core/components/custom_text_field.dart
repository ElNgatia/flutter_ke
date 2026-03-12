import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    super.key,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.validator,
    this.obscureText = false,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.autofocus = false,
    this.style,
    this.fieldKey,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<String>? autofillHints;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? suffixIcon;
  final bool autofocus;
  final TextStyle? style;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      style: style ?? const TextStyle(color: Colors.white),
      controller: controller,
      key: fieldKey,
      keyboardType: keyboardType,
      autofocus: autofocus,
      textInputAction: textInputAction,
      autofillHints: autofillHints,
      obscureText: obscureText,
      enableSuggestions: enableSuggestions,
      autocorrect: autocorrect,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        floatingLabelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.tertiary,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.colorScheme.tertiary,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
