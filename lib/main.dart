import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/trajet_controller.dart';
import 'services/firestore_service.dart';
import 'views/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  

  runApp(const CovoitLocalApp());
}

class CovoitLocalApp extends StatelessWidget {
  const CovoitLocalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
        ChangeNotifierProvider<AuthController>(
          create: (ctx) => AuthController(ctx.read<FirestoreService>()),
        ),
        ChangeNotifierProvider<TrajetController>(
          create: (ctx) => TrajetController(ctx.read<FirestoreService>()),
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
