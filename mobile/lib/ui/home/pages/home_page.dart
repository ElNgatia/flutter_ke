import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/core.dart';
import 'package:mobile/ui/ui.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const path = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String jobMessage = '''
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

  @override
  Widget build(BuildContext context) {
    final router = context.router;

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
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () => router.replace(const SignInRoute()),
          ),
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: [
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
