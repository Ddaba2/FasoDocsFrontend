// ÉCRAN 3: LOGIN SCREEN (exactement comme la photo)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sms_verification_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

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
    _phoneController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SMSVerificationScreen()),
    );
  }

  void _goToSignup() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            
            // Calcul des tailles responsive
            final horizontalPadding = screenWidth * 0.05; // 5% de la largeur
            final logoSize = screenWidth * 0.3; // 30% de la largeur
            final titleFontSize = screenWidth * 0.07; // 7% de la largeur
            final subtitleFontSize = screenWidth * 0.05; // 5% de la largeur
            final buttonFontSize = screenWidth * 0.04; // 4% de la largeur
            final inputFontSize = screenWidth * 0.04; // 4% de la largeur
            
            return Column(
              children: [
                SizedBox(height: screenHeight * 0.05),
                
                // Logo FasoDocs centré (exactement comme la photo)
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/FasoDocs 1.png',
                        width: logoSize,
                        height: logoSize * 0.6,
                        fit: BoxFit.contain,
                      ),
                      
                      SizedBox(height: screenWidth * 0.02),
                      
                      Text(
                        'FasoDocs',
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.1),
                
                // Titres (exactement comme la photo)
                Text(
                  'Bienvenue',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                SizedBox(height: screenWidth * 0.05),
                
                Text(
                  'Connexion',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                SizedBox(height: screenHeight * 0.05),
                
                // Champ téléphone (exactement comme la photo)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF14B53A)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontSize: inputFontSize),
                          decoration: InputDecoration(
                            hintText: '74 32 38 74',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: inputFontSize),
                            prefixIcon: Icon(Icons.phone, color: Colors.grey, size: screenWidth * 0.06),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.04),
                      
                      // Bouton Se connecter (exactement comme la photo)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B53A),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Se connecter',
                            style: TextStyle(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: screenHeight * 0.025),
                      
                      // Lien inscription (exactement comme la photo)
                      GestureDetector(
                        onTap: _goToSignup,
                        child: RichText(
                          text: TextSpan(
                            text: "Nouveau sur FasoDocs? ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: screenWidth * 0.035,
                            ),
                            children: [
                              TextSpan(
                                text: "Créer un compte.",
                                style: TextStyle(
                                  color: const Color(0xFF14B53A),
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}