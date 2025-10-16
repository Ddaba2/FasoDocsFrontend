// ÉCRAN 2: ONBOARDING (exactement comme la photo)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
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
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: 3,
        itemBuilder: (context, index) {
          return _buildOnboardingPage(index);
        },
      ),
    );
  }

  Widget _buildOnboardingPage(int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        
        // Calcul des tailles responsive
        final horizontalPadding = screenWidth * 0.05; // 5% de la largeur
        final verticalPadding = screenHeight * 0.02; // 2% de la hauteur
        final titleFontSize = screenWidth * 0.05; // 5% de la largeur
        final subtitleFontSize = screenWidth * 0.035; // 3.5% de la largeur
        final buttonFontSize = screenWidth * 0.04; // 4% de la largeur
        
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_getImagePath(index)),
              fit: index == 0 ? BoxFit.cover : BoxFit.cover,
              alignment: index == 0 ? Alignment.center : (index == 2 ? Alignment(-0.5, 0) : Alignment.center),
              scale: index == 0 ? 0.9 : 1.0,
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
                              color: Colors.grey.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(8),
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
                            color: Colors.grey[800]!.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(16),
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
                                  backgroundColor: Colors.grey[800],
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
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