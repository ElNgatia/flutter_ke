import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/providers/supabase/supabase_client_provider.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/ui/theme/app_theme.dart';

Future<void> main() async {
  await dotenv.load();

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
