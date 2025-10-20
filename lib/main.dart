// ========================================================================================
// FASODOCS - APPLICATION MOBILE DE GESTION ADMINISTRATIVE
// ========================================================================================
// Cette application permet aux citoyens burkinabés d'effectuer leurs démarches 
// administratives de manière simplifiée et centralisée.
//
// Fonctionnalités principales :
// - Authentification par SMS
// - Gestion des documents administratifs
// - Notifications des mises à jour
// - Suivi des démarches
// - Support multilingue (Français/English)
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/splash/splash_screen.dart';
import 'views/onboarding/onboarding_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/signup_screen.dart';
import 'views/auth/sms_verification_screen.dart';
import 'views/home/home_screen.dart';
import 'views/profile/profile_screen.dart';
import 'views/profile/edit_profile_screen.dart';
import 'views/history/history_screen.dart';
import 'views/report//report_problem_screen.dart';
import 'views/settings/settings_screen.dart';
import 'views/help/help_support_screen.dart';
import 'views/notifications/notifications_screen.dart';
import 'views/identity/identity_screen.dart';
import 'views/category/category_screen.dart';
import 'views/business/business_screen.dart';
import 'views/auto/auto_screen.dart';
import 'views/land/land_screen.dart';
import 'views/utilities/utilities_screen.dart';
import 'views/justice/justice_screen.dart';
import 'views/tax/tax_screen.dart';

/// Point d'entrée principal de l'application FasoDocs
void main() {
  runApp(const FasoDocsApp());
}

/// Classe principale de l'application FasoDocs
/// 
/// Configure l'application Flutter avec :
/// - L'orientation en mode portrait uniquement
/// - Le titre de l'application
/// - Le premier écran affiché (SplashScreen)
/// - La désactivation de la bannière de debug
class FasoDocsApp extends StatelessWidget {
  const FasoDocsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Force l'application à rester en mode portrait uniquement
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'FasoDocs',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
              routes: {
                '/onboarding': (context) => const OnboardingScreen(),
                '/login': (context) => const LoginScreen(),
                '/signup': (context) => const SignupScreen(),
                '/sms-verification': (context) => const SMSVerificationScreen(),
                '/home': (context) => const HomeScreen(),
                '/profile': (context) => const ProfileScreen(),
                '/edit-profile': (context) => const EditProfileScreen(),
                '/history': (context) => const HistoryScreen(),
                '/report-problem': (context) => const ReportProblemScreen(),
                '/settings': (context) => const SettingsScreen(),
                '/help-support': (context) => const HelpSupportScreen(),
                '/notifications': (context) => const NotificationsScreen(),
                '/identity': (context) => const IdentityScreen(),
                '/category': (context) => const CategoryScreen(),
                '/business': (context) => const BusinessScreen(),
                '/auto': (context) => const AutoScreen(),
                '/land': (context) => const LandScreen(),
                '/utilities': (context) => const UtilitiesScreen(),
                '/justice': (context) => const JusticeScreen(),
                '/tax': (context) => const TaxScreen(),
              },
    );
  }
}
