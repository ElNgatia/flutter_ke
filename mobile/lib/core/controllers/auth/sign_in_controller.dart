import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:mobile/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_controller.g.dart';

final signInMutation = Mutation<void>();

@riverpod
class SignInController extends _$SignInController {
  @override
  void build() {}

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await signInMutation.run(ref, (tsx) async {
      final authNotifier = tsx.get(authProvider.notifier);

      await authNotifier.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }
}
