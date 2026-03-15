import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/providers/auth/auth_notifier_provider.dart';
import 'package:mobile/repositories/auth_repo/auth_repository.dart';
import 'package:mobile/router/app_router.gr.dart';
import 'package:mobile/services/error_logger/error_logger.dart';
import 'package:mobile/services/validator_service/validator_service.dart';
import 'package:mobile/ui/shared_widgets/custom_filled_button.dart';
import 'package:mobile/ui/shared_widgets/custom_text_field.dart';
import 'package:mobile/ui/shared_widgets/loading_indicator.dart';

final _signInMutation = Mutation<void>();

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  static const path = '/auth/sign_in';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Kenya')),
      body: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: const SignInForm(),
      ),
    );
  }
}

class SignInForm extends HookConsumerWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final obscurePassword = useState(true);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    const minPasswordLength = 8;

    final signInState = ref.watch(_signInMutation);

    Future<void> submit() async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final router = context.router;
      if (formKey.currentState?.validate() ?? false) {
        TextInput.finishAutofillContext();

        return _signInMutation.run(
          ref,
          (tsx) async {
            try {
              final notifier = tsx.get(authProvider.notifier);
              await notifier.signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
              await router.replaceAll([const HomeRoute()]);
            } on AuthRepositoryException catch (error, stackTrace) {
              ErrorLoggerService.instance.logError(
                error,
                message: 'Error signing in',
                stackTrace: stackTrace,
              );
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  backgroundColor: theme.colorScheme.error,
                  content: Text(error.message),
                ),
              );
            } catch (error, stackTrace) {
              ErrorLoggerService.instance.logError(
                error,
                message: 'Error signing in',
                stackTrace: stackTrace,
              );
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  backgroundColor: theme.colorScheme.error,
                  content: const Text('An error occurred during signing in'),
                ),
              );
            }
          },
        );
      }
    }

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sign In',
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 32),
          AutofillGroup(
            child: Column(
              children: [
                CustomTextField(
                  controller: emailController,
                  labelText: 'Email',
                  hintText: 'example@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email is required';
                    }
                    return ValidatorService.emailFormatValidator(v.trim());
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: passwordController,
                  labelText: 'Password',
                  hintText: '********',
                  obscureText: obscurePassword.value,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Password is required';
                    }
                    if (v.length < minPasswordLength) {
                      return 'Password must be at least $minPasswordLength '
                          'characters';
                    }
                    return null;
                  },
                  onFieldSubmitted: switch (signInState) {
                    MutationPending() => null,
                    _ => (_) => submit(),
                  },
                  suffixIcon: IconButton(
                    onPressed: () =>
                        obscurePassword.value = !obscurePassword.value,
                    icon: Icon(
                      obscurePassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          CustomFilledButton(
            onPressed: switch (signInState) {
              MutationPending() => null,
              _ => submit,
            },
            child: switch (signInState) {
              MutationPending() => const LoadingIndicator(),
              _ => const Text('Sign in'),
            },
          ),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              text: "Don't have an account? ",
              style: const TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: 'Sign Up',
                  style: TextStyle(color: theme.colorScheme.tertiary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => context.replaceRoute(const SignUpRoute()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
