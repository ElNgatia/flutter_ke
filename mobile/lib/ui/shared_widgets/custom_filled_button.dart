import 'package:flutter/material.dart';
import 'package:mobile/ui/theme/app_spacing.dart';

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
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: FilledButton(
        style: theme.filledButtonTheme.style,
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
