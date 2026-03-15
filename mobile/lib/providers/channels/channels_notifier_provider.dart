
import 'package:mobile/core/data/models/channels/channel.dart';
import 'package:mobile/repositories/channel_repo/channels_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channels_notifier_provider.g.dart';

@riverpod
class ChannelsNotifier extends _$ChannelsNotifier {
  @override
  Future<List<Channel>> build() async {
    final repo = await ref.watch(channelsRepositoryProvider.future);

    return repo.fetchChannels();
  }

  Future<void> refreshChannels() async {
    state = const AsyncLoading();

    final repo = await ref.read(channelsRepositoryProvider.future);

    state = await AsyncValue.guard(repo.fetchChannels);
  }
}
