import 'dart:async';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/core/core.dart';

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

final Mutation<dynamic> _signInMutation = Mutation();

class SignInForm extends HookConsumerWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final obscurePassword = useState(true);

    final emailController = useTextEditingController(
      text: kDebugMode ? 'denzelgatugu@gmail.com' : '',
    );
    final passwordController = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);

    const minPasswordLength = 8;

    Future<void> submit() async {
      if (formKey.currentState?.validate() ?? false) {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();

        await _signInMutation.run(ref, (tsx) async {
          TextInput.finishAutofillContext();
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final router = context.router;

          final authNotifier = tsx.get(authProvider.notifier);
          try {
            await authNotifier.signInWithEmailAndPassword(
              email: email,
              password: password,
            );

            unawaited(router.replace(const HomeRoute()));
          } on Exception catch (e, stackTrace) {
            log(
              'Error signing in',
              error: e,
              stackTrace: stackTrace,
              level: 1000,
            );

            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('An error occurred during signing in'),
              ),
            );
          }
        });
      }
    }

    final signInState = ref.watch(_signInMutation);

    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            header: true,
            child: Text(
              'Sign In',
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
                  fieldKey: const ValueKey('sign_in_email'),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: passwordController,
                  labelText: 'Password',
                  hintText: '********',
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  obscureText: obscurePassword.value,
                  enableSuggestions: false,
                  autocorrect: false,
                  onFieldSubmitted: (_) => submit(),
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
                  fieldKey: const ValueKey('sign_in_password'),
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
          Align(
            child: RichText(
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
          ),
        ],
      ),
    );
  }
}
