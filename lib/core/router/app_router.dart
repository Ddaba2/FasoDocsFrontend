import 'package:flutter/material.dart';
import '../../core/theme/mali_theme.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/signup_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
      
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      
      case signup:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
          settings: settings,
        );
      
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
    }
  }
}

// Écran d'accueil temporaire
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MaliColors.white,
      appBar: AppBar(
        title: const Text('FasoDocs'),
        backgroundColor: MaliColors.white,
        foregroundColor: MaliColors.black,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 100,
              color: MaliColors.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Bienvenue dans FasoDocs !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: MaliColors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Votre application pour simplifier les démarches administratives au Mali',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: MaliColors.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
