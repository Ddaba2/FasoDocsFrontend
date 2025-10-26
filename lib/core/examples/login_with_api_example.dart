// ========================================================================================
// EXEMPLE - Intégration du backend dans login_screen.dart
// ========================================================================================
// Ce fichier montre comment intégrer l'API dans votre écran de connexion
// ========================================================================================

/*

// Dans votre login_screen.dart, ajoutez ces imports :

import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../home/home_screen.dart'; // Votre écran principal après connexion

// Dans la classe _LoginScreenState, modifiez la méthode _handleLogin() :

void _handleLogin() async {
  final phoneText = _phoneController.text.trim();
  
  // Validation
  if (phoneText.isEmpty) {
    setState(() {
      _showError = true;
      _errorMessage = 'Le numéro de téléphone est obligatoire';
    });
    _showErrorSnackbar(_errorMessage);
    return;
  }
  
  // Validation du format
  final phoneDigits = phoneText.replaceAll(RegExp(r'[^0-9]'), '');
  if (phoneDigits.length < 8 || phoneDigits.length > 15) {
    setState(() {
      _showError = true;
      _errorMessage = 'Le numéro doit contenir entre 8 et 15 chiffres';
    });
    _showErrorSnackbar(_errorMessage);
    return;
  }
  
  // Afficher un loader
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
  
  try {
    // Appel API pour la connexion
    // Note: Vous devrez peut-être adapter les noms de champs selon votre backend
    final user = await authService.login(
      phoneDigits,
      'password', // Récupérez le mot de passe depuis un champ du formulaire
    );
    
    // Fermer le loader
    if (mounted) {
      Navigator.of(context).pop();
      
      // Navigation vers l'écran principal
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  } catch (e) {
    // Fermer le loader
    if (mounted) {
      Navigator.of(context).pop();
    }
    
    setState(() {
      _showError = true;
      _errorMessage = e.toString();
    });
    
    _showErrorSnackbar(_errorMessage);
  }
}

// Pour l'inscription (signup_screen.dart) :

import '../../core/services/auth_service.dart';

void _handleSignup() async {
  if (_validateForm()) {
    // Afficher un loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      final user = await authService.signup(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        email: _emailController.text,
      );
      
      if (mounted) {
        Navigator.of(context).pop();
        // Navigation vers l'écran de vérification
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SMSVerificationScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur d\'inscription: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// Pour déconnexion (settings_screen.dart) :

import '../../core/services/auth_service.dart';
import '../auth/login_screen.dart';

void _handleLogout() async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Se déconnecter'),
      content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Se déconnecter'),
        ),
      ],
    ),
  );
  
  if (confirmed == true) {
    // Afficher un loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      await authService.logout();
      
      if (mounted) {
        Navigator.of(context).pop();
        // Retour à l'écran de connexion
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

*/

