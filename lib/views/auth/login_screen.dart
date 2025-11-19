// ÉCRAN 3: LOGIN SCREEN
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'sms_verification_screen.dart';
import 'signup_screen.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/form_validators.dart';

// Formatter pour valider que le numéro commence par 5, 6, 7, 8 ou 9
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Si le texte est vide, permettre la saisie
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Vérifier que le premier caractère est 5, 6, 7, 8 ou 9
    final firstChar = newValue.text[0];
    if (!['5', '6', '7', '8', '9'].contains(firstChar)) {
      // Rejeter la saisie si elle ne commence pas par un chiffre valide
      return oldValue;
    }
    
    return newValue;
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  String _completeNumber = '';
  bool _showError = false;
  String _errorMessage = '';
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
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final phoneText = _phoneController.text.trim();

    // Validation avec messages clairs et précis
    final phoneError = FormValidators.validatePhone(
      phoneText,
      completeNumber: _completeNumber,
    );

    if (phoneError != null) {
      setState(() {
        _showError = true;
        _errorMessage = phoneError;
      });

      _showErrorSnackbar(_errorMessage);
      return;
    }

    setState(() {
      _showError = false;
      _errorMessage = '';
      _isLoading = true;
    });

    try {
      // Appeler l'API pour envoyer le code SMS
      final response = await authService.connexionTelephone(_completeNumber);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );
        
        // Naviguer vers l'écran de vérification SMS
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => SMSVerificationScreen(telephone: _completeNumber),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Vérifier si c'est une erreur de compte désactivé
        if (e.toString().toLowerCase().contains('désactivé') || 
            e.toString().toLowerCase().contains('desactive') ||
            e.toString().toLowerCase().contains('disabled')) {
          _showAccountDisabledDialog(e.toString());
        } else {
          _showErrorSnackbar(e.toString().replaceFirst('Exception: ', ''));
        }
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showAccountDisabledDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.block, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Compte désactivé',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.replaceFirst('Exception: ', ''),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '💡 Veuillez contacter le support pour plus d\'informations.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _goToSignup() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            // Calcul des tailles responsive
            final horizontalPadding = screenWidth * 0.05; // 5% de la largeur
            final logoSize = screenWidth * 0.3; // 30% de la largeur
            final titleFontSize = screenWidth * 0.07; // 7% de la largeur
            final subtitleFontSize = screenWidth * 0.05; // 5% de la largeur
            final buttonFontSize = screenWidth * 0.04; // 4% de la largeur
            final inputFontSize = screenWidth * 0.04; // 4% de la largeur

            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.05),

                  // Logo FasoDocs centré
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/FasoDocs 1.png',
                          width: logoSize,
                          height: logoSize * 0.6,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: screenWidth * 0.02),
                        Text(
                          'FasoDocs',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.1),

                  // Titres
                  Text(
                    'Bienvenue',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  SizedBox(height: screenWidth * 0.05),

                  Text(
                    'Connexion',
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Champ téléphone avec IntlPhoneField
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      children: [
                        IntlPhoneField(
                          controller: _phoneController,
                          initialCountryCode: 'ML', // Mali par défaut
                          style: TextStyle(
                            fontSize: inputFontSize,
                            color: textColor,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Numéro de téléphone',
                            labelStyle: TextStyle(
                              color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
                              fontSize: inputFontSize,
                            ),
                            hintText: 'Ex: 76 12 34 56',
                            hintStyle: TextStyle(
                              color: isDarkMode ? Colors.grey.shade500 : Colors.grey.withOpacity(0.7),
                              fontSize: inputFontSize * 0.9,
                            ),
                            fillColor: cardColor,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _showError ? Colors.red : const Color(0xFF14B53A),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: _showError ? Colors.red : const Color(0xFF14B53A),
                                  width: 2
                              ),
                            ),
                            errorText: _showError ? _errorMessage : null,
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                          dropdownIcon: Icon(
                            Icons.arrow_drop_down,
                            color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
                          ),
                          onChanged: (phone) {
                            if (phone != null) {
                              _completeNumber = phone.completeNumber;
                              // Cacher l'erreur quand l'utilisateur commence à taper
                              if (_showError) {
                                setState(() {
                                  _showError = false;
                                  _errorMessage = '';
                                });
                              }
                            }
                          },
                          // Configuration des limites
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(15), // Maximum 15 chiffres
                            // Validateur pour accepter uniquement les numéros commençant par 5, 6, 7, 8 ou 9
                            _PhoneNumberFormatter(),
                          ],
                        ),

                        // Indication sur la longueur du numéro
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.01),
                          child: Text(
                            'Le numéro doit contenir entre 8 et 15 chiffres',
                            style: TextStyle(
                              color: isDarkMode ? Colors.grey.shade500 : Colors.grey,
                              fontSize: screenWidth * 0.03,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // Bouton Se connecter
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF14B53A),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                : Text(
                                    'Se connecter',
                                    style: TextStyle(
                                      fontSize: buttonFontSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        // Lien inscription
                        GestureDetector(
                          onTap: _goToSignup,
                          child: RichText(
                            text: TextSpan(
                              text: "Nouveau sur FasoDocs? ",
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey.shade400 : Colors.grey,
                                fontSize: screenWidth * 0.035,
                              ),
                              children: [
                                TextSpan(
                                  text: "Créer un compte.",
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}