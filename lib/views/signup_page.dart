import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:devm_covoitlocal/controllers/auth_controller.dart';
import 'package:devm_covoitlocal/views/home_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _nomC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('S\'inscrire')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _nomC, decoration: const InputDecoration(labelText: 'Nom')),
          TextField(controller: _emailC, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: _passC, decoration: const InputDecoration(labelText: 'Mot de passe'), obscureText: true),
          const SizedBox(height: 16),
          if (auth.error != null) Text(auth.error!, style: const TextStyle(color: Colors.red)),
          ElevatedButton(
            onPressed: auth.loading ? null : () async {
              await auth.signUp(_emailC.text.trim(), _passC.text.trim(), _nomC.text.trim());
              if (auth.user != null) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
              }
            },
            child: auth.loading ? const CircularProgressIndicator(color: Colors.white) : const Text('S\'inscrire'),
          ),
        ],),
      ),
    );
  }
}
