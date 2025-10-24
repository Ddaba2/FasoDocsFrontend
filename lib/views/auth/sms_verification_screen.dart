import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Note: Assurez-vous que le chemin vers HomeScreen est correct.
import '../home/home_screen.dart'; // Placeholder pour la navigation

class SMSVerificationScreen extends StatefulWidget {
  const SMSVerificationScreen({super.key});

  @override
  State<SMSVerificationScreen> createState() => _SMSVerificationScreenState();
}

class _SMSVerificationScreenState extends State<SMSVerificationScreen> {
  // Configuration pour l'OTP (One-Time Password)
  final int _otpLength = 4; // Code à 4 chiffres basé sur l'image

  // Liste des TextEditingController et FocusNode pour chaque boîte de saisie
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  final String _phoneNumber = '+223 74 32 38 74'; // Numéro visible dans l'image

  // Chemin d'asset du logo pour la vérification SMS
  // REMPLACEZ CECI PAR LE CHEMIN RÉEL DE VOTRE LOGO D'ARCHE V-J-R
  final String _logoAssetPath = 'assets/images/mali_logo_sms.png';

  @override
  void initState() {
    super.initState();

    // Initialisation des listes
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());

    // Pour se concentrer automatiquement sur le premier champ au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.first.requestFocus();
      
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
    // Libération des ressources
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Fonction pour obtenir le code complet
  String _getOTP() {
    return _controllers.map((c) => c.text).join();
  }

  // Gère la validation et la navigation (associée au bouton "Confirmer")
  void _handleContinue() {
    final code = _getOTP();
    // Vérifier si le code a la bonne longueur (4 chiffres)
    if (code.length == _otpLength) {
      // Simulation de la vérification réussie
      // Dans une application réelle, vous feriez ici un appel API
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir le code complet'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Widget pour un seul champ de saisie (une boîte de l'OTP)
  Widget _buildOTPField(int index, double boxSize, double screenWidth, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    
    const activeBorderColor = Color(0xFF14B53A); // Couleur verte
    final defaultBorderColor = isDarkMode ? Colors.grey.shade700 : const Color(0xFFE0E0E0); // Gris clair

    // Détermine la couleur de la bordure : verte si le champ n'est pas vide
    bool isFilled = _controllers[index].text.isNotEmpty;
    // Détermine si le champ est le champ actuellement focus
    bool isFocused = _focusNodes[index].hasFocus;
    // La couleur de la bordure est verte si elle est remplie OU si elle a le focus
    Color borderColor = isFilled || isFocused ? activeBorderColor : defaultBorderColor;


    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1), // Un seul chiffre par boîte
          FilteringTextInputFormatter.digitsOnly, // Seulement des chiffres
        ],
        style: TextStyle(
          fontSize: screenWidth * 0.06,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          counterText: '', // Supprime le compteur de caractères par défaut
        ),
        onChanged: (value) {
          if (value.length == 1) {
            // Passage automatique au champ suivant
            if (index < _otpLength - 1) {
              _focusNodes[index + 1].requestFocus();
            } else {
              // Si c'est le dernier champ, masquer le clavier
              _focusNodes[index].unfocus();
              // Tenter la confirmation immédiatement
              // _handleContinue(); // Optionnel: activer pour valider auto
            }
          } else if (value.isEmpty && index > 0) {
            // Retour en arrière si le champ est vidé (pour une meilleure UX)
            _focusNodes[index - 1].requestFocus();
          }
          // Déclenche une reconstruction pour mettre à jour la couleur de la bordure
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      // AppBar pour la flèche de retour
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // Correction de style pour la flèche de retour à gauche
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            // Calcule la taille des boîtes pour laisser de l'espace (4 boîtes + 3 espaces)
            final boxSize = (screenWidth * 0.9 - 3 * 10) / 4;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),

                  // =========================================================
                  // LOGO ADAPTÉ AU DESIGN DE SingUp (1).png
                  // =========================================================
                  Center(
                    child: Image.asset(
                      _logoAssetPath,
                      width: screenWidth * 0.35,
                      height: screenWidth * 0.35,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.lock_open,
                          size: screenWidth * 0.25,
                          color: const Color(0xFF14B53A),
                        );
                      },
                    ),
                  ),
                  // =========================================================

                  SizedBox(height: screenHeight * 0.05),

                  // Titre principal
                  Text(
                    'Vérifiez vos sms',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Message d'instruction
                  Text(
                    'Nous avons envoyé votre code au $_phoneNumber',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.06),

                  // Champs de saisie du code SMS (Boîtes séparées)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(_otpLength, (index) {
                      return _buildOTPField(index, boxSize, screenWidth, context);
                    }),
                  ),

                  const Spacer(),

                  // Bouton Confirmer
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14B53A),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.4),
                      ),
                      child: Text(
                        'Confirmer',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}