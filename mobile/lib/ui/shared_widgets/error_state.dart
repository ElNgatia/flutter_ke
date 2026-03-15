import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({required this.message, super.key});

  final Widget message;

  @override
  Widget build(BuildContext context) {
    return Center(child: message);
  }
}
