// ========================================================================================
// ÉCRAN 1: SPLASH SCREEN - ÉCRAN DE CHARGEMENT INITIAL
// ========================================================================================
// Premier écran affiché au lancement de l'application.
// Affiche le logo FasoDocs et redirige automatiquement vers l'écran d'onboarding
// après 3 secondes de chargement.
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // ========================================================================================
  // MÉTHODE D'INITIALISATION
  // ========================================================================================
  
  /// Initialise l'écran de splash avec la configuration de l'interface système
  /// et programme la navigation automatique vers l'onboarding après 3 secondes
  @override
  void initState() {
    super.initState();
    
    // ========================================================================================
    // CONFIGURATION DE L'INTERFACE SYSTÈME
    // ========================================================================================
    // Configure l'apparence de la barre de statut et de navigation selon le thème
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

    // ========================================================================================
    // NAVIGATION AUTOMATIQUE VERS L'ONBOARDING
    // ========================================================================================
    // Afficher le splash screen pendant 3 secondes (même en mode debug)
    // puis naviguer vers l'écran d'onboarding
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {  // Vérification que le widget existe encore
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  // ========================================================================================
  // MÉTHODE BUILD - CONSTRUCTION DE L'INTERFACE UTILISATEUR
  // ========================================================================================
  
  /// Construit l'interface utilisateur du splash screen
  /// Affiche le logo FasoDocs centré avec le texte de l'application
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Utiliser un fond blanc pour le splash screen (visible même si le thème est sombre)
    final backgroundColor = Colors.white;
    final textColor = Colors.black;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(  // Zone sûre qui évite les encoches et la barre de statut
        child: LayoutBuilder(  // Builder qui fournit les contraintes de taille
          builder: (context, constraints) {
            // ========================================================================================
            // CALCUL DES DIMENSIONS RESPONSIVES
            // ========================================================================================
            final screenWidth = constraints.maxWidth;     // Largeur de l'écran
            final screenHeight = constraints.maxHeight;   // Hauteur de l'écran
            final logoSize = screenWidth * 0.3;           // Taille du logo réduite (30% de la largeur)
            final fontSize = screenWidth * 0.06;          // Taille de police (6% de la largeur)
            
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,  // Centré verticalement au milieu
                crossAxisAlignment: CrossAxisAlignment.center,  // Centré horizontalement
                children: [
                  // ========================================================================================
                  // LOGO FASODOCS - Image principale du splash screen (en haut du milieu)
                  // ========================================================================================
                  Image.asset(
                    'assets/images/FasoDocs 1.png',
                    width: logoSize,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                  
                  SizedBox(height: screenWidth * 0.04),
                  
                  // Texte FasoDocs (en bas du logo, au milieu)
                  Text(
                    'FasoDocs',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: 0.5,
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
