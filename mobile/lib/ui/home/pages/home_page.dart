import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/core.dart';
import 'package:mobile/ui/ui.dart';

final _logoutMutation = Mutation<dynamic>();

@RoutePage()
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const path = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = context.router;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    Future<void> logoutUser() async {
      await _logoutMutation.run(ref, (tsx) async {
        final authNotifier = tsx.get(authProvider.notifier);
        try {
          await authNotifier.signOut();
        } on Exception catch (_, _) {
          rethrow;
        }
      });
    }

    ref.listen(
      _logoutMutation,
      (_, currentValue) {
        switch (currentValue) {
          case MutationPending():
            return;
          case MutationError(:final error, :final stackTrace):
            log(
              'Error signing out',
              error: error,
              stackTrace: stackTrace,
              level: 1000,
            );

            scaffoldMessenger.showSnackBar(
              const SnackBar(
                content: Text('An error occurred during signing out'),
              ),
            );
          default:
            router.replace(const SignInRoute());
        }
      },
    );

    final logoutState = ref.watch(_logoutMutation);

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
        title: const Row(
          children: [
            SizedBox(width: 12),
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(
                'https://avatars.githubusercontent.com/u/14101776?s=200&v=4',
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flutter DevsKe 💻👨🏾‍💻',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Atati, Brian Kamau, bruce, Christi...',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person_outline,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: switch (logoutState) {
              MutationPending() => const LoadingIndicator(),
              _ => const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            },
            onPressed: switch (logoutState) {
              MutationPending() => null,
              _ => logoutUser,
            },
          ),
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
            width: double.infinity,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xff15112b),
            ),
          ),
        ],
      ),
    );
  }
}
