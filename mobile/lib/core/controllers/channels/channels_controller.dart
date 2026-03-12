import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:mobile/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'channels_controller.g.dart';

final createChannelMutation = Mutation<void>();

@riverpod
class ChannelsController extends _$ChannelsController {
  @override
  void build() {}

  Future<void> createChannel({
    required String name,
    String? description,
  }) async {
    await createChannelMutation.run(ref, (tsx) async {
      final repo = await tsx.get(channelsRepositoryProvider.future);

      await repo.createChannel(
        name: name,
        description: description,
      );

      await tsx.get(channelsProvider.notifier).refreshChannels();
    });
  }
}
