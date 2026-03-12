import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:mobile/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_controller.g.dart';

final signUpMutation = Mutation<void>();

@riverpod
class SignUpController extends _$SignUpController {
  @override
  void build() {}

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    await signUpMutation.run(ref, (tsx) async {
      final authNotifier = tsx.get(authProvider.notifier);

      await authNotifier.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }
}
