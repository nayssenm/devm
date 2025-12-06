import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devm_covoitlocal/controllers/auth_controller.dart';
import 'package:devm_covoitlocal/views/login_page.dart';
import 'package:devm_covoitlocal/views/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthController>();
    auth.checkAuth().then((_) {
      // petit délai esthétique
      Future.delayed(const Duration(milliseconds: 500), () {
        if (auth.user != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginPage()));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          FlutterLogo(size: 96),
          SizedBox(height: 16),
          CircularProgressIndicator(),
        ],),
      ),
    );
  }
}
