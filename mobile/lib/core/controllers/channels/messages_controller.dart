import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:mobile/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages_controller.g.dart';

final sendMessageMutation = Mutation<void>();

@riverpod
class MessagesController extends _$MessagesController {
  @override
  void build() {}

  Future<void> sendMessage({
    required String channelId,
    required String content,
  }) async {
    await sendMessageMutation.run(ref, (tsx) async {
      final repo = await tsx.get(channelsRepositoryProvider.future);

      await repo.sendMessage(
        channelId: channelId,
        content: content,
      );

      await tsx
          .get(messagesProvider(channelId).notifier)
          .refreshMessages(channelId);
    });
  }
}
