import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'package:devm_covoitlocal/controllers/auth_controller.dart';
import 'package:devm_covoitlocal/controllers/trajet_controller.dart';
import 'package:devm_covoitlocal/services/firestore_service.dart';
import 'package:devm_covoitlocal/views/splash_page.dart';
import 'package:devm_covoitlocal/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔐 Protection contre l'initialisation multiple (Hot Restart)
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),

        ChangeNotifierProvider<AuthController>(
          create: (ctx) =>
              AuthController(ctx.read<FirestoreService>()),
        ),

        ChangeNotifierProvider<TrajetController>(
          create: (ctx) =>
              TrajetController(ctx.read<FirestoreService>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DEVMOB - CovoitLocal (MVC)',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}
;