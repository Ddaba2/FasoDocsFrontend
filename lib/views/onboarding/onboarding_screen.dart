// ÉCRAN 2: ONBOARDING (exactement comme la photo)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation pour les transitions
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();

    // Détection du mode sombre
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDark = brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? Colors.black : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _skipOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(), // Animation fluide
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
            _fadeController.reset();
            _fadeController.forward();
          });
        },
        itemCount: 3,
        itemBuilder: (context, index) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: _buildOnboardingPage(index),
          );
        },
      ),
    );
  }

  Widget _buildOnboardingPage(int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        // Calcul des tailles responsive
        final horizontalPadding = screenWidth * 0.05; // 5% de la largeur
        final verticalPadding = screenHeight * 0.02; // 2% de la hauteur
        final titleFontSize = screenWidth * 0.05; // 5% de la largeur
        final subtitleFontSize = screenWidth * 0.035; // 3.5% de la largeur
        final buttonFontSize = screenWidth * 0.04; // 4% de la largeur

        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            image: DecorationImage(
              image: AssetImage(_getImagePath(index)),
              fit: BoxFit.cover,
              alignment: index == 0
                ? Alignment.center
                : (index == 2 ? Alignment(-0.5, 0) : Alignment.center),
              opacity: isDarkMode ? 0.7 : 1.0, // Réduit l'opacité en mode sombre
              colorFilter: isDarkMode
                ? ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken)
                : null,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header avec bouton Skip seulement en haut à droite
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Bouton Skip en haut à droite
                      if (index < 2)
                        GestureDetector(
                          onTap: _skipOnboarding,
                          child: Container(
                            padding: EdgeInsets.all(screenWidth * 0.02),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                ? Colors.grey.shade800.withOpacity(0.9)
                                : Colors.grey.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
                              border: isDarkMode
                                ? Border.all(color: Colors.grey.shade700)
                                : null,
                            ),
                            child: Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: screenWidth * 0.05,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                Expanded(
                  child: Stack(
                    children: [
                      // Rectangle de texte positionné exactement comme sur la photo
                      Positioned(
                        left: screenWidth * 0.07,
                        right: screenWidth * 0.07,
                           top: index == 0 ? screenHeight * 0.68 : (index == 2 ? screenHeight * 0.58 : screenHeight * 0.62),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: isDarkMode
                              ? Colors.black.withOpacity(0.9)
                              : Colors.grey[800]!.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(16),
                            border: isDarkMode
                              ? Border.all(color: Colors.grey.shade800, width: 1)
                              : null,
                          ),
                          child: RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: _getTitleText(index, screenWidth * 0.038),
                            ),
                          ),
                        ),
                      ),

                      // Contenu en bas (points et bouton)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.025),

                            // Indicateurs de page (exactement comme la photo)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                3,
                                (i) => Container(
                                  margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
                                  width: screenWidth * 0.02,
                                  height: screenWidth * 0.02,
                                  decoration: BoxDecoration(
                                    color: i == _currentPage
                                        ? const Color(0xFFFCD116)
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.025),

                            // Bouton Continuer gris foncé (exactement comme la photo)
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                              child: ElevatedButton(
                                onPressed: _nextPage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.grey[800],
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                                  elevation: isDarkMode ? 0 : 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: isDarkMode
                                      ? BorderSide(color: Colors.grey.shade800)
                                      : BorderSide.none,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _currentPage == 2 ? "Commencer" : "Continuer",
                                      style: TextStyle(
                                        fontSize: buttonFontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.025),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getImagePath(int index) {
    switch (index) {
      case 0:
        return "assets/images/Problème1.png";
      case 1:
        return "assets/images/SolutionF.png";
      case 2:
        return "assets/images/confiance.png";
      default:
        return "assets/images/Problème1.png";
    }
  }

  List<TextSpan> _getTitleText(int index, double fontSize) {
    switch (index) {
      case 0:
        return [
          TextSpan(text: "Obtenir un ", style: TextStyle(fontSize: fontSize, color: Colors.white)),
          TextSpan(
            text: "document administratif",
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFCD116),
            ),
          ),
          TextSpan(text: " au Mali ? C'est souvent la promesse de longues files d'attente, de paperasse incompréhensible et de frais imprévus.", style: TextStyle(fontSize: fontSize, color: Colors.white)),
        ];
      case 1:
        return [TextSpan(text: "Vos démarches administratives sans complexité. Des procédures guidées et des informations fiables enfin accessibles à tous.", style: TextStyle(fontSize: fontSize, color: Colors.white))];
      case 2:
        return [
          TextSpan(text: "La complexité, nous la gérons.\n", style: TextStyle(fontSize: fontSize, color: Colors.white)),
          TextSpan(text: "La simplicité, nous vous la livrons.", style: TextStyle(fontSize: fontSize, color: Colors.white)),
        ];
      default:
        return [TextSpan(text: "", style: TextStyle(fontSize: fontSize, color: Colors.white))];
    }
  }
}