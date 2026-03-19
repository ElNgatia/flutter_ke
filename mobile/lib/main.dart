import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/firebase_options.dart';
import 'package:mobile/router/app_router.dart';
import 'package:mobile/ui/app/pages/my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final appRouter = AppRouter();

  runApp(
    ProviderScope(
      child: MyApp(appRouter: appRouter),
    ),
  );
}
