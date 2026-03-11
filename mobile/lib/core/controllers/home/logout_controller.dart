import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:mobile/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logout_controller.g.dart';

final logoutMutation = Mutation<void>();

@riverpod
class LogoutController extends _$LogoutController {
  @override
  void build() {}

  Future<void> logout() async {
    await logoutMutation.run(ref, (tsx) async {
      final authNotifier = tsx.get(authProvider.notifier);
      await authNotifier.signOut();
    });
  }
}
