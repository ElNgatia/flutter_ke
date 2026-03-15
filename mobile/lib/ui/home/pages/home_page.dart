import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/data/models/channels/message.dart';
import 'package:mobile/core/router/app_router.gr.dart';
import 'package:mobile/core/services/error_logger/error_logger.dart';
import 'package:mobile/providers/auth/auth_notifier_provider.dart';
import 'package:mobile/providers/channels/channels_notifier_provider.dart';
import 'package:mobile/providers/channels/messages_notifier_provider.dart';
import 'package:mobile/ui/home/widgets/message_bubble.dart';
import 'package:mobile/ui/home/widgets/profile_image.dart';
import 'package:mobile/ui/shared_widgets/loading_indicator.dart';

final _logoutMutation = Mutation<void>();

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      backgroundColor: Color(0xff15112b),
      appBar: HomeAppBar(),
      body: ChannelsBody(),
    );
  }
}

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final channelsAsync = ref.watch(channelsProvider);
    final logoutState = ref.watch(_logoutMutation);

    Future<void> signOut() => _logoutMutation.run(ref, (tsx) async {
          final router = context.router;
          final scaffoldMessenger = ScaffoldMessenger.of(context);

          try {
            await tsx.get(authProvider.notifier).signOut();
            await router.replaceAll([const SignInRoute()]);
          } catch (e, stackTrace) {
            ErrorLoggerService.instance.logError(e, stackTrace: stackTrace);
            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('An error occurred during signing out'),
              ),
            );
          }
        });

    return AppBar(
      backgroundColor: const Color(0xff15112b),
      elevation: 5,
      titleSpacing: 0,
      centerTitle: false,
      title: channelsAsync.when(
        loading: () => Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            'Loading channel...',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        ),
        error: (error, _) => const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            'Channel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        data: (channels) {
          if (channels.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Text(
                'No Channel',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final channel = channels.first;

          return Row(
            children: [
              const SizedBox(width: 12),
              ProfileImage(
                size: 40,
                image: channel.avatarUrl,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      channel.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      channel.description ?? '${channel.memberCount} members',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: switch (logoutState) {
            MutationPending() => const LoadingIndicator(),
            _ => const Icon(Icons.logout, color: Colors.white),
          },
          onPressed: switch (logoutState) {
            MutationPending() => null,
            _ => signOut,
          },
        ),
      ],
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({required this.message, super.key});

  final Widget message;

  @override
  Widget build(BuildContext context) {
    return Center(child: message);
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.message,
    this.asset,
    super.key,
  });

  final Widget message;
  final Widget? asset;

  @override
  Widget build(BuildContext context) {
    if (asset == null) {
      return Center(child: message);
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          asset!,
          const SizedBox(height: 16),
          message,
        ],
      ),
    );
  }
}

class ChannelsBody extends ConsumerWidget {
  const ChannelsBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final channelsAsync = ref.watch(channelsProvider);
    final errorText = Text(
      'Failed to load messages',
      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
    );
    final emptyText = Text(
      'No messages',
      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
    );

    return Column(
      children: [
        Expanded(
          child: channelsAsync.when(
            loading: () => const Center(
              child: LoadingIndicator(),
            ),
            error: (_, _) => ErrorState(message: errorText),
            data: (channels) {
              if (channels.isEmpty) {
                return EmptyState(message: emptyText);
              }
              final channel = channels.first;
              final messagesAsync = ref.watch(
                messagesProvider(channel.id),
              );

              return messagesAsync.when(
                loading: () => const Center(
                  child: LoadingIndicator(),
                ),
                error: (_, _) => ErrorState(message: errorText),
                data: (messages) {
                  if (messages.isEmpty) {
                    return EmptyState(message: emptyText);
                  }
                  return MessagesList(messages: messages);
                },
              );
            },
          ),
        ),
        Container(
          height: 30,
          color: const Color(0xff15112b),
        ),
      ],
    );
  }
}

class MessagesList extends StatelessWidget {
  const MessagesList({
    required this.messages,
    super.key,
  });

  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return MessageBubble(
          sender: 'Admin',
          text: message.content ?? '',
          isMe: false,
        );
      },
    );
  }
}
