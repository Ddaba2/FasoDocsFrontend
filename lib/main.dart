// ========================================================================================
// FASODOCS - APPLICATION MOBILE DE GESTION ADMINISTRATIVE
// ========================================================================================
// Cette application permet aux citoyens burkinabés d'effectuer leurs démarches 
// administratives de manière simplifiée et centralisée.
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart'; // NÉCESSAIRE POUR LA GESTION DE THÈME

// Imports des vues
import 'views/splash/splash_screen.dart';
import 'views/onboarding/onboarding_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/signup_screen.dart';
import 'views/auth/sms_verification_screen.dart';
import 'views/home/home_screen.dart';
import 'views/profile/profile_screen.dart';
import 'views/profile/edit_profile_screen.dart';
import 'views/history/history_screen.dart';
import 'views/report/report_problem_screen.dart';
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

// Import des providers
import 'locale/locale_provider.dart';
import 'providers/language_provider.dart';


// ----------------------------------------------------------------------
// 1. ThemeModeProvider (pour communiquer le changement de thème)
// ----------------------------------------------------------------------

/// Gère l'état global du mode clair/sombre et notifie les widgets qui l'écoutent.
class ThemeModeProvider extends ChangeNotifier {
  // Mode clair par défaut
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  // Fonction appelée pour changer le thème
  void toggleTheme(ThemeMode newMode) {
    if (_themeMode != newMode) {
      _themeMode = newMode;
      notifyListeners(); // Informe tous les widgets d'écouter les changements
    }
  }
}

// ----------------------------------------------------------------------
// 2. Définition des Thèmes Clairs et Sombres
// ----------------------------------------------------------------------

// Couleur principale de l'application (le vert FasoDocs)
const Color _primaryColor = Color(0xFF14B53A);

// Thème Clair
ThemeData lightTheme() {
  // Configuration de la barre de statut pour le mode clair (icônes sombres)
  const SystemUiOverlayStyle lightOverlay = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  );

  return ThemeData(
    primaryColor: _primaryColor,
    brightness: Brightness.light,

    // Fonds des pages : Blanc très clair
    scaffoldBackgroundColor: const Color(0xFFF0F0F0),

    // Fonds des "cartes" (conteneurs) et barres de navigation
    cardColor: Colors.white,

    // Couleur des textes par défaut : Noir
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black),
    ),

    // Couleur des icônes par défaut : Noir
    iconTheme: const IconThemeData(color: Colors.black),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black, // Texte/icônes de l'App Bar en noir
      systemOverlayStyle: lightOverlay,
    ),

    // CORRECTION : Utilisation de ColorScheme.light pour définir la surface
    colorScheme: ColorScheme.light(
      primary: _primaryColor,
      secondary: _primaryColor, // Couleur secondaire
      background: const Color(0xFFF0F0F0),
      surface: Colors.white, // Couleur des cartes/conteneurs
    ),

    // Styles spécifiques pour les Switch (boutons à bascule)
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) =>
      states.contains(MaterialState.selected) ? _primaryColor : Colors.grey[400]),
      trackColor: MaterialStateProperty.resolveWith((states) =>
      states.contains(MaterialState.selected) ? _primaryColor.withOpacity(0.5) : Colors.grey[300]),
    ),
  );
}

// Thème Sombre
ThemeData darkTheme() {
  const Color darkBackground = Color(0xFF121212); // Fond de la page
  const Color darkSurface = Color(0xFF1E1E1E); // Cartes et barres

  // Configuration de la barre de statut pour le mode sombre (icônes claires)
  const SystemUiOverlayStyle darkOverlay = SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
  );

  return ThemeData(
    primaryColor: _primaryColor,
    brightness: Brightness.dark,

    // Fonds des pages : Noir très sombre
    scaffoldBackgroundColor: darkBackground,

    // Fonds des "cartes" et barres de navigation : légèrement moins sombres que le fond
    cardColor: darkSurface,

    // Couleur des textes par défaut : Blanc
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white),
    ),

    // Couleur des icônes par défaut : Blanc
    iconTheme: const IconThemeData(color: Colors.white),

    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurface,
      foregroundColor: Colors.white, // Texte/icônes de l'App Bar en blanc
      systemOverlayStyle: darkOverlay,
    ),

    // CORRECTION : Utilisation de ColorScheme.dark pour définir la surface
    colorScheme: ColorScheme.dark(
      primary: _primaryColor,
      secondary: _primaryColor,
      background: darkBackground,
      surface: darkSurface, // Correction appliquée ici
    ),

    // Styles spécifiques pour les Switch (boutons à bascule)
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) =>
      states.contains(MaterialState.selected) ? _primaryColor : Colors.grey[600]),
      trackColor: MaterialStateProperty.resolveWith((states) =>
      states.contains(MaterialState.selected) ? _primaryColor.withOpacity(0.5) : Colors.grey[700]),
    ),
  );
}

// ----------------------------------------------------------------------
// 3. FasoDocsApp (Gère l'état du thème)
// ----------------------------------------------------------------------

/// Classe principale de l'application FasoDocs
class FasoDocsApp extends StatelessWidget {
  const FasoDocsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Force l'application à rester en mode portrait uniquement
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // On écoute les providers pour obtenir les états actuels
    // Le Provider doit être accessible depuis le main()
    final themeProvider = Provider.of<ThemeModeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'FasoDocs',
      debugShowCheckedModeBanner: false,

      // Configuration de la Locale avec LanguageProvider 🔥
      locale: languageProvider.locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],

      // Configuration du Thème (Clair et Sombre)
      themeMode: themeProvider.themeMode, // Utilise le mode stocké dans le Provider
      theme: lightTheme(), // Thème Clair par défaut
      darkTheme: darkTheme(), // Thème Sombre

      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        // '/sms-verification': (context) => const SMSVerificationScreen(), // Remplacé par navigation directe avec paramètre
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

/// Point d'entrée principal de l'application FasoDocs
void main() {
  // Enveloppe l'application entière dans les ChangeNotifierProviders.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeModeProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()), // 🔥 NOUVEAU
      ],
      child: const FasoDocsApp(),
    ),
  );
}