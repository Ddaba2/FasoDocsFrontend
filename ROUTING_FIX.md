# Fix pour l'erreur de routage - FasoDocs

## Problème identifié

L'application rencontrait l'erreur suivante lors de l'exécution :

```
DartError: Could not find a generator for route RouteSettings("/onboarding", null) in the _WidgetsAppState.
```

## Cause du problème

Après la refactorisation de l'application, le fichier `main.dart` ne contenait plus de définitions de routes. Le `SplashScreen` tentait de naviguer vers la route `/onboarding`, mais cette route n'était pas définie dans le `MaterialApp`.

## Solution appliquée

### 1. Ajout des imports nécessaires

Ajout de tous les imports des écrans dans `lib/main.dart` :

```dart
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/auth/sms_verification_screen.dart';
import 'features/home/home_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/profile/edit_profile_screen.dart';
import 'features/history/history_screen.dart';
import 'features/report/report_problem_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/help/help_support_screen.dart';
import 'features/notifications/notifications_screen.dart';
import 'features/identity/identity_screen.dart';
import 'features/category/category_screen.dart';
```

### 2. Configuration des routes

Ajout de la propriété `routes` dans le `MaterialApp` :

```dart
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
  },
);
```

## Résultat

- ✅ L'erreur de routage est résolue
- ✅ La navigation entre les écrans fonctionne correctement
- ✅ L'application peut maintenant naviguer de `SplashScreen` vers `OnboardingScreen`
- ✅ Toutes les routes de l'application sont définies et accessibles

## Architecture finale

L'application suit maintenant une architecture MVC propre avec :

1. **Point d'entrée unique** : `main.dart` (49 lignes)
2. **Écrans modulaires** : Chaque écran dans son propre fichier
3. **Routage centralisé** : Toutes les routes définies dans `main.dart`
4. **Séparation des responsabilités** : Chaque feature dans son dossier

## Fichiers modifiés

- `lib/main.dart` : Ajout des imports et configuration des routes

## Test

L'application peut maintenant être lancée avec `flutter run` sans erreur de routage.
