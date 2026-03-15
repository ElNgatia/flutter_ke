import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.color = Colors.white});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(color),
        strokeWidth: 2,
      ),
    );
  }
}
