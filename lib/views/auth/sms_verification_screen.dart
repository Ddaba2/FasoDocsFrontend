import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Note: Assurez-vous que le chemin vers HomeScreen est correct.
import '../home/home_screen.dart'; // Placeholder pour la navigation
import '../../core/services/auth_service.dart';
import '../../core/utils/form_validators.dart';

class SMSVerificationScreen extends StatefulWidget {
  final String telephone;
  
  const SMSVerificationScreen({super.key, required this.telephone});

  @override
  State<SMSVerificationScreen> createState() => _SMSVerificationScreenState();
}

class _SMSVerificationScreenState extends State<SMSVerificationScreen> {
  // Configuration pour l'OTP (One-Time Password)
  final int _otpLength = 4; // Code à 4 chiffres basé sur l'image

  // Liste des TextEditingController et FocusNode pour chaque boîte de saisie
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  bool _isLoading = false;

  // Chemin d'asset du logo pour la vérification SMS
  // Utilise le logo FasoDocs disponible
  final String _logoAssetPath = 'assets/images/FasoDocs.png';
  
  // ⏰ Gestion de l'expiration du code SMS (2 minutes)
  static const Duration _codeExpirationDuration = Duration(minutes: 2);
  DateTime? _codeSentTime;
  Timer? _expirationTimer;
  int _remainingSeconds = 120; // 2 minutes en secondes
  bool _isCodeExpired = false;

  @override
  void initState() {
    super.initState();

    // Initialisation des listes
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    
    // ⏰ Enregistrer le moment où le code a été envoyé (quand l'écran s'ouvre)
    _codeSentTime = DateTime.now();
    _remainingSeconds = _codeExpirationDuration.inSeconds;
    _startExpirationTimer();

    // Pour se concentrer automatiquement sur le premier champ au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.first.requestFocus();
      
      final brightness = Theme.of(context).brightness;
      final isDark = brightness == Brightness.dark;
      
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: isDark ? Colors.black : Colors.white,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      );
    });
  }
  
  /// Démarre le timer d'expiration du code
  void _startExpirationTimer() {
    _expirationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final now = DateTime.now();
        final elapsed = now.difference(_codeSentTime!);
        final remaining = _codeExpirationDuration - elapsed;
        
        if (remaining.isNegative || remaining.inSeconds <= 0) {
          // Le code a expiré
          setState(() {
            _remainingSeconds = 0;
            _isCodeExpired = true;
          });
          timer.cancel();
        } else {
          setState(() {
            _remainingSeconds = remaining.inSeconds;
            _isCodeExpired = false;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }
  
  /// Formate le temps restant en MM:SS
  String _formatRemainingTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
  
  /// Vérifie si le code est expiré
  bool _isCodeExpiredCheck() {
    if (_codeSentTime == null) return true;
    final now = DateTime.now();
    final elapsed = now.difference(_codeSentTime!);
    return elapsed >= _codeExpirationDuration;
  }

  @override
  void dispose() {
    // Arrêter le timer d'expiration
    _expirationTimer?.cancel();
    
    // Libération des ressources
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Fonction pour obtenir le code complet
  String _getOTP() {
    return _controllers.map((c) => c.text).join();
  }

  // Gère la validation et la navigation (associée au bouton "Confirmer")
  void _handleContinue() async {
    final code = _getOTP();
    
    // ⏰ Vérifier si le code est expiré AVANT de valider
    if (_isCodeExpiredCheck() || _isCodeExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            '⏰ Code expiré. Veuillez demander un nouveau code',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    
    // Validation avec message clair
    final codeError = FormValidators.validateSmsCode(code, length: _otpLength);
    if (codeError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            codeError,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Appeler l'API pour vérifier le code SMS
      final jwtResponse = await authService.verifierSms(widget.telephone, code);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Arrêter le timer
        _expirationTimer?.cancel();
        
        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jwtResponse.message)),
        );
        
        // Naviguer vers l'écran d'accueil
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Message d'erreur unifié : "Code incorrect ou expiré"
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '❌ Code incorrect ou expiré',
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }
  
  /// Demander un nouveau code SMS
  Future<void> _requestNewCode() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Appeler l'API pour renvoyer un nouveau code
      await authService.connexionTelephone(widget.telephone);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Réinitialiser le timer
          _codeSentTime = DateTime.now();
          _remainingSeconds = _codeExpirationDuration.inSeconds;
          _isCodeExpired = false;
        });
        
        // Redémarrer le timer
        _startExpirationTimer();
        
        // Vider les champs
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes.first.requestFocus();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Nouveau code envoyé par SMS'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erreur: ${e.toString().replaceFirst('Exception: ', '')}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Widget pour un seul champ de saisie (une boîte de l'OTP)
  Widget _buildOTPField(int index, double boxSize, double screenWidth, BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    
    const activeBorderColor = Color(0xFF14B53A); // Couleur verte
    final defaultBorderColor = isDarkMode ? Colors.grey.shade700 : const Color(0xFFE0E0E0); // Gris clair

    // Détermine la couleur de la bordure : verte si le champ n'est pas vide
    bool isFilled = _controllers[index].text.isNotEmpty;
    // Détermine si le champ est le champ actuellement focus
    bool isFocused = _focusNodes[index].hasFocus;
    // La couleur de la bordure est verte si elle est remplie OU si elle a le focus
    Color borderColor = isFilled || isFocused ? activeBorderColor : defaultBorderColor;


    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1), // Un seul chiffre par boîte
          FilteringTextInputFormatter.digitsOnly, // Seulement des chiffres
        ],
        style: TextStyle(
          fontSize: screenWidth * 0.06,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          counterText: '', // Supprime le compteur de caractères par défaut
        ),
        onChanged: (value) {
          if (value.length == 1) {
            // Passage automatique au champ suivant
            if (index < _otpLength - 1) {
              _focusNodes[index + 1].requestFocus();
            } else {
              // Si c'est le dernier champ, masquer le clavier
              _focusNodes[index].unfocus();
              // Tenter la confirmation immédiatement
              // _handleContinue(); // Optionnel: activer pour valider auto
            }
          } else if (value.isEmpty && index > 0) {
            // Retour en arrière si le champ est vidé (pour une meilleure UX)
            _focusNodes[index - 1].requestFocus();
          }
          // Déclenche une reconstruction pour mettre à jour la couleur de la bordure
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      // AppBar pour la flèche de retour
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // Correction de style pour la flèche de retour à gauche
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            // Calcule la taille des boîtes pour laisser de l'espace (4 boîtes + 3 espaces)
            final boxSize = (screenWidth * 0.9 - 3 * 10) / 4;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.02),

                  // =========================================================
                  // LOGO ADAPTÉ AU DESIGN DE SingUp (1).png
                  // =========================================================
                  Center(
                    child: Image.asset(
                      _logoAssetPath,
                      width: screenWidth * 0.35,
                      height: screenWidth * 0.35,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.lock_open,
                          size: screenWidth * 0.25,
                          color: const Color(0xFF14B53A),
                        );
                      },
                    ),
                  ),
                  // =========================================================

                  SizedBox(height: screenHeight * 0.05),

                  // Titre principal
                  Text(
                    'Vérifiez vos sms',
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Message d'instruction
                  Text(
                    'Nous avons envoyé votre code au ${widget.telephone}',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: screenHeight * 0.02),
                  
                  // ⏰ Affichage du temps restant ou message d'expiration
                  _isCodeExpired
                      ? Column(
                          children: [
                            Text(
                              '⏰ Code expiré',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextButton.icon(
                              onPressed: _isLoading ? null : _requestNewCode,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Demander un nouveau code'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF14B53A),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: screenWidth * 0.05,
                              color: _remainingSeconds <= 30 ? Colors.red : textColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Code valide pendant: ${_formatRemainingTime(_remainingSeconds)}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: _remainingSeconds <= 30 ? Colors.red : textColor,
                                fontWeight: _remainingSeconds <= 30 ? FontWeight.bold : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),

                  SizedBox(height: screenHeight * 0.04),

                  // Champs de saisie du code SMS (Boîtes séparées)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(_otpLength, (index) {
                      return _buildOTPField(index, boxSize, screenWidth, context);
                    }),
                  ),

                  const Spacer(),

                  // Bouton Confirmer (désactivé si le code est expiré)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_isLoading || _isCodeExpired) ? null : _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isCodeExpired 
                            ? Colors.grey 
                            : const Color(0xFF14B53A),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.4),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              _isCodeExpired ? 'Code expiré' : 'Confirmer',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}