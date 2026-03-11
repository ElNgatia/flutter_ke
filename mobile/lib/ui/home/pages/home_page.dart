import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/core.dart';
import 'package:mobile/ui/ui.dart';

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = context.router;
    final theme = Theme.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    ref.listen(
      logoutMutation,
      (_, state) {
        switch (state) {
          case MutationError(:final error, :final stackTrace):
            log(
              'Error signing out',
              error: error,
              stackTrace: stackTrace,
            );

            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('An error occurred during signing out'),
              ),
            );

          case MutationSuccess():
            router.replace(const SignInRoute());

          default:
            break;
        }
      },
    );

    final logoutState = ref.watch(logoutMutation);
    final channelsAsync = ref.watch(channelsProvider);

    const jobMessage = '''
💼 IT Intern — Data Centre Operations: 6-month Paid Internship

📍 Location: On-site, Nairobi (iXAfrica Data Centre – NBOX1)

🔎 What we’re looking for
• 🐧 Strong Linux CLI + scripting (Python preferred)
• 🌿 Git collaboration (branches / PRs / code reviews)
• 🌐 TCP/IP fundamentals (DNS, DHCP, subnetting, routing)
• 🖥️ Basic virtualisation knowledge (VMware / KVM / Proxmox)
• 🤖 Android dev (Kotlin preferred): Android Studio / SDK / Jetpack + REST / JSON integrations

🎓 Eligibility
• CS / IT / Network / Software Engineering (current or recent). Strong problem-solving + clear documentation.

🔗 Apply:
https://ixafrica.co.ke/careers/it-intern-data-centre-operations-6-month-internship/
''';

    return Scaffold(
      backgroundColor: const Color(0xff15112b),
      appBar: AppBar(
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
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  backgroundImage: channel.avatarUrl != null
                      ? NetworkImage(channel.avatarUrl!)
                      : null,
                  child: channel.avatarUrl == null
                      ? const Icon(Icons.group, color: Colors.black)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: switch (logoutState) {
              MutationPending() => const LoadingIndicator(),
              _ => const Icon(Icons.logout, color: Colors.white),
            },
            onPressed: switch (logoutState) {
              MutationPending() => null,
              _ => () => ref.read(logoutControllerProvider.notifier).logout(),
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              reverse: true,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              children: const [
                MessageBubble(
                  sender: 'Admin',
                  text: jobMessage,
                  isMe: false,
                ),
              ],
            ),
          ),
          Container(
            height: 30,
            color: const Color(0xff15112b),
          ),
        ],
      ),
    );
  }
}
