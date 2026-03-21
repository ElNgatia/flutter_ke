import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/supabase/supabase_client_provider.dart';
import 'package:mobile/router/app_router.dart';
import 'package:mobile/ui/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({required this.appRouter, super.key});
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(supabaseClientProvider);

    return MaterialApp.router(
      routerConfig: appRouter.config(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      title: 'Flutter Kenya',
      debugShowCheckedModeBanner: false,
    );
  }
}
