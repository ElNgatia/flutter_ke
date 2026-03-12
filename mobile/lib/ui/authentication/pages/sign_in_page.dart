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

class SignInForm extends HookConsumerWidget {
  const SignInForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final obscurePassword = useState(true);
    final emailController = useTextEditingController(
      text: kDebugMode ? 'denzelgatugu@gmail.com' : '',
    );
    final passwordController = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    const minPasswordLength = 8;

    ref.listen(
      signInMutation,
      (_, state) {
        switch (state) {
          case MutationSuccess():
            context.router.replace(const HomeRoute());

          case MutationError(:final error, :final stackTrace):
            log(
              'Error signing in',
              error: error,
              stackTrace: stackTrace,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('An error occurred during signing in'),
              ),
            );

          default:
            break;
        }
      },
    );

    final signInState = ref.watch(signInMutation);

    Future<void> submit() async {
      if (formKey.currentState?.validate() ?? false) {
        TextInput.finishAutofillContext();

        await ref
            .read(signInControllerProvider.notifier)
            .signIn(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
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
