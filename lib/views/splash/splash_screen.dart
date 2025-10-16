// ========================================================================================
// ÉCRAN 1: SPLASH SCREEN - ÉCRAN DE CHARGEMENT INITIAL
// ========================================================================================
// Premier écran affiché au lancement de l'application.
// Affiche le logo FasoDocs et redirige automatiquement vers l'écran d'onboarding
// après 3 secondes de chargement.
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    // Configure l'apparence de la barre de statut et de navigation
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,        // Barre de statut transparente
        statusBarIconBrightness: Brightness.dark, // Icônes sombres sur fond clair
        systemNavigationBarColor: Colors.white,    // Barre de navigation blanche
        systemNavigationBarIconBrightness: Brightness.dark, // Icônes sombres
      ),
    );

    // ========================================================================================
    // NAVIGATION AUTOMATIQUE VERS L'ONBOARDING
    // ========================================================================================
    // Attend 3 secondes puis navigue vers l'écran d'onboarding
    // Vérifie que le widget est toujours monté avant de naviguer
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
    return Scaffold(
      backgroundColor: Colors.white,  // Fond blanc pour l'écran de splash
      body: SafeArea(  // Zone sûre qui évite les encoches et la barre de statut
        child: LayoutBuilder(  // Builder qui fournit les contraintes de taille
          builder: (context, constraints) {
            // ========================================================================================
            // CALCUL DES DIMENSIONS RESPONSIVES
            // ========================================================================================
            final screenWidth = constraints.maxWidth;     // Largeur de l'écran
            final logoSize = screenWidth * 0.3;           // Taille du logo (30% de la largeur)
            final fontSize = screenWidth * 0.08;          // Taille de police (8% de la largeur)
            
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,  // Colonne centrée verticalement
                children: [
                  // ========================================================================================
                  // LOGO FASODOCS - Image principale du splash screen
                  // ========================================================================================
                  Image.asset(
                    'assets/images/FasoDocs 1.png',
                    width: logoSize,
                    height: logoSize * 0.6,
                    fit: BoxFit.contain,
                  ),
                  
                  SizedBox(height: screenWidth * 0.02),
                  
                  // Texte FasoDocs
                  Text(
                    'FasoDocs',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
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
