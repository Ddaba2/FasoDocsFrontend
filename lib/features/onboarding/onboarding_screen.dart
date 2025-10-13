import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/widgets/faso_docs_logo.dart';
import '../../core/theme/mali_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: "Obtenir un document administratif au Mali ?",
      subtitle: "C'est souvent la promesse de longues files d'attente, de paperasse incompréhensible et de frais imprévus.",
      highlightText: "document administratif",
      imagePath: "assets/images/Problème1.png",
      backgroundColor: MaliColors.white,
    ),
    OnboardingData(
      title: "Vos démarches administratives sans complexité.",
      subtitle: "Des procédures guidées et des informations fiables enfin accessibles à tous.",
      highlightText: "",
      imagePath: "assets/images/SolutionF.png",
      backgroundColor: MaliColors.white,
    ),
    OnboardingData(
      title: "La complexité, nous la gérons.",
      subtitle: "La simplicité, nous vous la livrons.",
      highlightText: "",
      imagePath: "assets/images/confiance.png",
      backgroundColor: MaliColors.grey900,
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: MaliColors.white,
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
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _skipOnboarding() {
    Navigator.of(context).pushReplacementNamed('/login');
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
        itemCount: _onboardingData.length,
        itemBuilder: (context, index) {
          return _buildOnboardingPage(_onboardingData[index], index);
        },
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data, int index) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(data.imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header avec logo et bouton skip
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo FasoDocs
                    const FasoDocsLogoIcon(size: 40),
                    
                    // Bouton Skip
                    if (index < _onboardingData.length - 1)
                      GestureDetector(
                        onTap: _skipOnboarding,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: MaliColors.grey800.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.fast_forward,
                            color: MaliColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Contenu principal
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: data.backgroundColor.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Titre
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: data.backgroundColor == MaliColors.grey900 
                              ? MaliColors.white 
                              : MaliColors.black,
                          height: 1.3,
                        ),
                        children: _buildHighlightedText(
                          data.title,
                          data.highlightText,
                          data.backgroundColor == MaliColors.grey900 
                              ? MaliColors.white 
                              : MaliColors.black,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Sous-titre
                    Text(
                      data.subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: data.backgroundColor == MaliColors.grey900 
                            ? MaliColors.white.withOpacity(0.8)
                            : MaliColors.grey700,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Indicateurs de page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingData.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: index == _currentPage ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == _currentPage 
                          ? MaliColors.jaune 
                          : MaliColors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Bouton Continuer
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MaliColors.grey800,
                    foregroundColor: MaliColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _currentPage == _onboardingData.length - 1 
                            ? "Commencer" 
                            : "Continuer",
                        style: const TextStyle(
                          fontSize: 16,
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
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildHighlightedText(String text, String highlight, Color defaultColor) {
    if (highlight.isEmpty) {
      return [TextSpan(text: text)];
    }
    
    List<TextSpan> spans = [];
    int start = 0;
    
    while (start < text.length) {
      int index = text.toLowerCase().indexOf(highlight.toLowerCase(), start);
      
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      
      spans.add(TextSpan(
        text: text.substring(index, index + highlight.length),
        style: TextStyle(
          color: MaliColors.jaune,
          fontWeight: FontWeight.bold,
        ),
      ));
      
      start = index + highlight.length;
    }
    
    return spans;
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String highlightText;
  final String imagePath;
  final Color backgroundColor;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.highlightText,
    required this.imagePath,
    required this.backgroundColor,
  });
}
