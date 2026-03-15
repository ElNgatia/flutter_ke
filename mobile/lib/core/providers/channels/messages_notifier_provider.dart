
import 'package:mobile/core/data/models/channels/message.dart';
import 'package:mobile/core/repositories/channel_repo/channels_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages_notifier_provider.g.dart';

@riverpod
class MessagesNotifier extends _$MessagesNotifier {
  @override
  Future<List<Message>> build(String channelId) async {
    final repo = await ref.watch(channelsRepositoryProvider.future);
    return repo.fetchMessages(channelId);
  }

  Future<void> refreshMessages(String channelId) async {
    state = const AsyncLoading();

    final repo = await ref.read(channelsRepositoryProvider.future);

    state = await AsyncValue.guard(
      () => repo.fetchMessages(channelId),
    );
  }
}
