// ÉCRAN 4: SIGNUP SCREEN (exactement comme la photo)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/services/auth_service.dart';
import '../../core/utils/form_validators.dart';
import 'conditions_utilisation_screen.dart';

// ASSUREZ-VOUS QUE CE CHEMIN EST CORRECT
import '../auth/login_screen.dart'; // <--- NOUVELLE IMPORTATION POUR LA NAVIGATION

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final brightness = Theme.of(context).brightness;
      final isDark = brightness == Brightness.dark;
      
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: isDark ? Colors.black : Colors.white,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      );
    });
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Inscription dans la table "citoyen" du backend
  Future<void> _handleSignup() async {
    // Validation du nom avec messages précis
    final nomError = FormValidators.validateName(_nomController.text, fieldName: 'Le nom');
    if (nomError != null) {
      _showErrorSnackbar(nomError);
      return;
    }

    // Validation du prénom avec messages précis
    final prenomError = FormValidators.validateName(_prenomController.text, fieldName: 'Le prénom');
    if (prenomError != null) {
      _showErrorSnackbar(prenomError);
      return;
    }

    // Validation du téléphone avec messages précis
    final phoneError = FormValidators.validatePhone(_phoneController.text);
    if (phoneError != null) {
      _showErrorSnackbar(phoneError);
      return;
    }

    // Validation de l'email avec messages précis
    final emailError = FormValidators.validateEmail(_emailController.text);
    if (emailError != null) {
      _showErrorSnackbar(emailError);
      return;
    }

    // Validation du mot de passe avec messages précis
    final passwordError = FormValidators.validatePassword(_passwordController.text, minLength: 6);
    if (passwordError != null) {
      _showErrorSnackbar(passwordError);
      return;
    }

    // Validation de la confirmation du mot de passe avec messages précis
    final confirmError = FormValidators.validateConfirmPassword(
      _confirmPasswordController.text,
      _passwordController.text,
    );
    if (confirmError != null) {
      _showErrorSnackbar(confirmError);
      return;
    }

    // Vérifier l'acceptation des conditions
    if (!_acceptTerms) {
      _showErrorSnackbar('✅ Veuillez accepter les conditions d\'utilisation');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      
      // 1. Inscription de l'utilisateur
      final messageResponse = await authService.inscription(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        telephone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        motDePasse: _passwordController.text,
        confirmerMotDePasse: _confirmPasswordController.text,
      );

      if (mounted) {
        // Afficher une boîte de dialogue informative
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 32),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Inscription réussie !',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  messageResponse.message,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  '📧 Email de bienvenue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Un email de bienvenue vous a été envoyé à :',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _emailController.text.trim(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF14B53A),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '💡 Vérifiez votre boîte mail pour découvrir toutes les fonctionnalités de FasoDocs.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Rediriger vers l'écran de connexion
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const LoginScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF14B53A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Se connecter', style: TextStyle(fontSize: 16)),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      }
    } catch (e) {
      print('❌ Erreur inscription: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur d\'inscription: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // FONCTION MISE À JOUR POUR REDIRIGER VERS LOGINSCREEN
  void _goToLogin() {
    // Remplace la route actuelle par LoginScreen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  // Afficher un message d'erreur clair
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // Image d'arrière-plan (assurez-vous que l'asset 'confiance.png' existe)
          image: DecorationImage(
            image: AssetImage('assets/images/confiance.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                (isDarkMode ? Colors.black : Colors.black).withOpacity(0.7),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header avec bouton retour (adapté)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _goToLogin,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF14B53A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            // CHANGEMENT D'ICÔNE : Utilisation de chevron_left
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 24, // Légèrement plus grande pour un chevron
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Inscription',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                const Spacer(),

                // Contenu principal (Formulaire)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Champ Nom
                      TextFormField(
                        controller: _nomController,
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Nom',
                          labelStyle: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: textColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A), width: 2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Champ Prénom
                      TextFormField(
                        controller: _prenomController,
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Prénom',
                          labelStyle: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: textColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A), width: 2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Champ Téléphone
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Téléphone',
                          hintText: 'Ex: 76 12 34 56',
                          helperText: 'Le numéro doit commencer par 5, 6, 7, 8 ou 9',
                          labelStyle: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: textColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A), width: 2),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(15),
                          // Validateur pour accepter uniquement les numéros commençant par 5, 6, 7, 8 ou 9
                          _PhoneNumberFormatter(),
                        ],
                        validator: (value) => FormValidators.validatePhone(value),
                      ),

                      const SizedBox(height: 20),

                      // Champ Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.next,
                        enableSuggestions: true,
                        autocorrect: false,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'exemple@email.com',
                          helperText: 'Utilisez le clavier pour taper @ et .com',
                          helperStyle: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                          labelStyle: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: textColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A), width: 2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Champ Mot de passe
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          labelStyle: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: textColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: textColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A), width: 2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Champ Confirmer mot de passe
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Confirmer votre mot de passe',
                          labelStyle: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: textColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: textColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A), width: 2),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Checkbox conditions d'utilisation
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (value) {
                              setState(() {
                                _acceptTerms = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF14B53A),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const ConditionsUtilisationScreen(),
                                    ),
                                  );
                                },
                              child: RichText(
                                text: TextSpan(
                                  text: "J'accepte les ",
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "conditions d'utilisation",
                                      style: TextStyle(
                                        color: const Color(0xFF14B53A),
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Bouton d'inscription
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B53A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'S\'inscrire',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Lien vers connexion
                      Center(
                        child: TextButton(
                          onPressed: _goToLogin,
                          child: RichText(
                            text: TextSpan(
                              text: "Vous avez déjà un compte ? ",
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey.shade400 : const Color(0xFF757575),
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: "Se connecter",
                                  style: TextStyle(
                                    color: const Color(0xFF14B53A),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}