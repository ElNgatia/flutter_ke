import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/firebase_options.dart';
import 'package:mobile/providers/supabase/supabase_client_provider.dart';
import 'package:mobile/router/app_router.dart';
import 'package:mobile/ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

final _appRouter = AppRouter();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(supabaseClientProvider);

    return MaterialApp.router(
      routerConfig: _appRouter.config(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      title: 'Flutter Kenya',
      debugShowCheckedModeBanner: false,
    );
  }
}
