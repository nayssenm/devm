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
  final _formKey = GlobalKey<FormState>();
  bool _isEmailValid = true;
  String? _emailError;
  
  // Variables pour les effets de survol
  bool _isLoginHovered = false;
  bool _isSignupHovered = false;
  
  // Validateur d'email
  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  
  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    
    // Couleurs du thème
    const Color primaryGrey = Color(0xFF3A3A3A);
    const Color secondaryBeige = Color(0xFFF5F1E8);
    const Color accentBlue = Color(0xFF4A6FA5);
    const Color lightBlue = Color(0xFF7B9BC9);
    const Color darkGrey = Color(0xFF2C2C2C);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Se connecter',
          style: TextStyle(
            color: secondaryBeige,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: primaryGrey,
        elevation: 4,
        iconTheme: const IconThemeData(color: secondaryBeige),
      ),
      body: Stack(
        children: [
          // Background avec image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2069&q=80',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Overlay semi-transparent pour améliorer la lisibilité
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: secondaryBeige.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Titre
                        const Text(
                          'Connexion',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: primaryGrey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Entrez vos identifiants pour continuer',
                          style: TextStyle(
                            color: darkGrey,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Champ Email avec validation
                        TextFormField(
                          controller: _emailC,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(color: primaryGrey),
                            prefixIcon: const Icon(Icons.email, color: accentBlue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: accentBlue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: accentBlue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: primaryGrey.withOpacity(0.5)),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.red, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            errorText: _emailError,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: primaryGrey),
                          onChanged: (value) {
                            if (value.isNotEmpty && !_validateEmail(value)) {
                              setState(() {
                                _emailError = 'Format invalide: nom@exemple.com';
                              });
                            } else {
                              setState(() {
                                _emailError = null;
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre email';
                            }
                            if (!_validateEmail(value)) {
                              return 'Format invalide: nom@exemple.com';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        // Champ Mot de passe
                        TextFormField(
                          controller: _passC,
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            labelStyle: const TextStyle(color: primaryGrey),
                            prefixIcon: const Icon(Icons.lock, color: accentBlue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: accentBlue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: accentBlue, width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: primaryGrey.withOpacity(0.5)),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                          ),
                          obscureText: true,
                          obscuringCharacter: '*',
                          style: const TextStyle(color: primaryGrey),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            if (value.length < 6) {
                              return 'Le mot de passe doit contenir au moins 6 caractères';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        
                        // Lien mot de passe oublié
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Mot de passe oublié ?',
                              style: TextStyle(
                                color: accentBlue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Messages d'erreur de l'authentification
                        if (auth.error != null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    auth.error!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        if (auth.error != null) const SizedBox(height: 16),
                        
                        // Bouton Se connecter
                        MouseRegion(
                          onEnter: (_) => setState(() => _isLoginHovered = true),
                          onExit: (_) => setState(() => _isLoginHovered = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _isLoginHovered
                                    ? [lightBlue, accentBlue]
                                    : [accentBlue, Color(0xFF3A5F8F)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: _isLoginHovered
                                  ? [
                                      BoxShadow(
                                        color: accentBlue.withOpacity(0.4),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: ElevatedButton(
                              onPressed: auth.loading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        await auth.signIn(
                                          _emailC.text.trim(),
                                          _passC.text.trim(),
                                        );
                                        if (auth.user != null) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (_) => const HomePage(),
                                            ),
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: auth.loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    )
                                  : Text(
                                      'Se connecter',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: secondaryBeige,
                                        shadows: _isLoginHovered
                                            ? [
                                                Shadow(
                                                  color: Colors.black.withOpacity(0.2),
                                                  blurRadius: 2,
                                                ),
                                              ]
                                            : null,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Séparateur
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: primaryGrey.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Pas encore de compte ?',
                                style: TextStyle(
                                  color: primaryGrey.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: primaryGrey.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Bouton S'inscrire
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Créez un compte',
                              style: TextStyle(
                                color: primaryGrey,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 8),
                            MouseRegion(
                              onEnter: (_) => setState(() => _isSignupHovered = true),
                              onExit: (_) => setState(() => _isSignupHovered = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _isSignupHovered
                                      ? primaryGrey
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: primaryGrey,
                                    width: 2,
                                  ),
                                  boxShadow: _isSignupHovered
                                      ? [
                                          BoxShadow(
                                            color: primaryGrey.withOpacity(0.3),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SignupPage(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    "S'inscrire",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: _isSignupHovered
                                          ? secondaryBeige
                                          : primaryGrey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}