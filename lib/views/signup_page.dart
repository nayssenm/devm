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

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    _nomC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthController>();

    // Valider les champs
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus(); // Cacher le clavier

    try {
      await auth.signUp(
        _emailC.text.trim(),
        _passC.text.trim(),
        _nomC.text.trim(),
      );

      if (auth.user != null) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      // Optionnel : afficher snackbar ou autre
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('S\'inscrire')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomC,
                decoration: const InputDecoration(labelText: 'Nom'),
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.isEmpty) ? 'Nom requis' : null,
              ),
              TextFormField(
                controller: _emailC,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email requis';
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(v)) return 'Email invalide';
                  return null;
                },
              ),
              TextFormField(
                controller: _passC,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                textInputAction: TextInputAction.done,
                validator: (v) => (v == null || v.length < 6) ? 'Minimum 6 caractères' : null,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              if (auth.error != null)
                Text(auth.error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: auth.loading ? null : _submit,
                  child: auth.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('S\'inscrire'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
