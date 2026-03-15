import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  const CustomFilledButton({
    required this.onPressed,
    required this.child,
    super.key,
  });

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            Colors.deepPurpleAccent,
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
