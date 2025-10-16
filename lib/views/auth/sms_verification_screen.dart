// ========================================================================================
// ÉCRAN: VÉRIFICATION SMS - AUTHENTIFICATION PAR CODE SMS
// ========================================================================================
// Cet écran permet à l'utilisateur de vérifier son numéro de téléphone
// en saisissant le code de vérification reçu par SMS.
//
// Fonctionnalités :
// - Affichage du logo FasoDocs stylisé avec les couleurs du drapeau burkinabé
// - Message indiquant le numéro de téléphone où le code a été envoyé
// - Champ de saisie pour le code de vérification (8 chiffres)
// - Compteur de caractères en temps réel
// - Validation du code avant de permettre la continuation
// - Navigation vers la page d'accueil après validation réussie
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home/home_screen.dart';

class SMSVerificationScreen extends StatefulWidget {
  const SMSVerificationScreen({super.key});

  @override
  State<SMSVerificationScreen> createState() => _SMSVerificationScreenState();
}

class _SMSVerificationScreenState extends State<SMSVerificationScreen> {
  final _smsController = TextEditingController();
  String _phoneNumber = '+223 74 32 38 74'; // Numéro par défaut

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
    _smsController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    // Vérifier si le code SMS est valide (ici on simule juste)
    if (_smsController.text.length == 8) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez saisir un code de 8 chiffres'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
            
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.08),
                  
                  // Logo FasoDocs centré
                  Center(
                    child: Column(
                      children: [
                        // Logo avec les couleurs du drapeau burkinabé
                        Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              // Segment vert
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: screenWidth * 0.08,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF14B53A),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.description,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              // Segment jaune avec flèche
                              Positioned(
                                left: screenWidth * 0.08,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: screenWidth * 0.09,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFD700),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.arrow_upward,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                              // Segment rouge
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: screenWidth * 0.08,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDC143C),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.08),
                  
                  // Titre principal
                  Text(
                    'Vérifiez vos sms',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: screenHeight * 0.03),
                  
                  // Message d'instruction
                  Text(
                    'Nous avons envoyé votre code au $_phoneNumber',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  SizedBox(height: screenHeight * 0.06),
                  
                  // Champ de saisie du code SMS
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF14B53A),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _smsController,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Code de vérification sms',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: screenWidth * 0.04,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.02,
                        ),
                        counterText: '',
                      ),
                    ),
                  ),
                  
                  // Compteur de caractères
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                      child: Text(
                        '${_smsController.text.length}/8',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Bouton Continuer
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF14B53A),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Continuer',
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.05),
                  
                  // Indicateur de navigation (ligne noire en bas)
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}