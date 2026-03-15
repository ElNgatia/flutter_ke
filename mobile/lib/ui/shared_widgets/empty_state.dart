import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.message,
    this.asset,
    super.key,
  });

  final Widget message;
  final Widget? asset;

  @override
  Widget build(BuildContext context) {
    if (asset == null) {
      return Center(child: message);
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          asset!,
          const SizedBox(height: 16),
          message,
        ],
      ),
    );
  }
}
