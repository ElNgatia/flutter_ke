import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/core/core.dart';

@RoutePage()
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static const path = '/auth/sign_up';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Kenya')),
      body: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: const SignUpForm(),
      ),
    );
  }
}

final Mutation<dynamic> _signUpMutation = Mutation();

class SignUpForm extends HookConsumerWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);

    const minPasswordLength = 8;
    final signUpState = ref.watch(_signUpMutation);

    Future<void> submit() async {
      if (formKey.currentState?.validate() ?? false) {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();

        await _signUpMutation.run(ref, (tsx) async {
          TextInput.finishAutofillContext();
          final authNotifier = tsx.get(authProvider.notifier);
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final router = context.router;

          try {
            await authNotifier.signUpWithEmailAndPassword(
              email: email,
              password: password,
            );
            unawaited(router.replace(const HomeRoute()));
          } on Exception catch (e, stackTrace) {
            log(
              'Error signing up',
              error: e,
              stackTrace: stackTrace,
              level: 1000,
            );

            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('An error occurred during signing up'),
              ),
            );
          }
        });
      }
    }

    return Form(
      key: formKey,
      child: Semantics(
        label: 'Sign up form',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              header: true,
              child: Text(
                'Sign Up',
                style: textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
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
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email is required';
                      }

                      return ValidatorService.emailFormatValidator(v.trim());
                    },
                    fieldKey: const ValueKey('sign_up_email'),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: '********',
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                    obscureText: obscurePassword.value,
                    enableSuggestions: false,
                    autocorrect: false,
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
                    fieldKey: const ValueKey('sign_up_password'),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          obscurePassword.value = !obscurePassword.value,
                      tooltip: obscurePassword.value
                          ? 'Show password'
                          : 'Hide password',
                      icon: Icon(
                        obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: confirmPasswordController,
                    labelText: 'Confirm Password',
                    hintText: '********',
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.newPassword],
                    obscureText: obscureConfirmPassword.value,
                    enableSuggestions: false,
                    autocorrect: false,
                    onFieldSubmitted: (_) => submit(),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Confirm your password';
                      }
                      if (v != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    fieldKey: const ValueKey('sign_up_confirm_password'),
                    suffixIcon: IconButton(
                      onPressed: () => obscureConfirmPassword.value =
                          !obscureConfirmPassword.value,
                      tooltip: obscureConfirmPassword.value
                          ? 'Show password'
                          : 'Hide password',
                      icon: Icon(
                        obscureConfirmPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Colors.deepPurpleAccent,
                  ),
                ),
                onPressed: switch (signUpState) {
                  MutationPending() => null,
                  _ => submit,
                },
                child: switch (signUpState) {
                  MutationPending() => const LoadingIndicator(),
                  _ => const Text('Sign up'),
                },
              ),
            ),
            const SizedBox(height: 24),
            Align(
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(color: theme.colorScheme.tertiary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            context.replaceRoute(const SignInRoute()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
