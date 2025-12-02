import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devm_covoitlocal/controllers/auth_controller.dart';
import 'package:devm_covoitlocal/views/signup_page.dart';
import 'package:devm_covoitlocal/views/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Se connecter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _emailC, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: _passC, decoration: const InputDecoration(labelText: 'Mot de passe'), obscureText: true),
          const SizedBox(height: 16),
          if (auth.error != null) Text(auth.error!, style: const TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: auth.loading ? null : () async {
              await auth.signIn(_emailC.text.trim(), _passC.text.trim());
              if (auth.user != null) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
              }
            },
            child: auth.loading ? const CircularProgressIndicator(color: Colors.white) : const Text('Se connecter'),
          ),
          TextButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage()));
          }, child: const Text('S\'inscrire'),),
        ],),
      ),
    );
  }
}
