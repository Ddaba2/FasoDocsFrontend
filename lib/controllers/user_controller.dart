// ========================================================================================
// CONTRÔLEUR UTILISATEUR - MVC Pattern
// ========================================================================================
// Ce fichier contient la logique métier pour la gestion des utilisateurs
// Il gère les opérations CRUD et la logique d'authentification
// ========================================================================================

import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';

class UserController {
  static final UserController _instance = UserController._internal();
  factory UserController() => _instance;
  UserController._internal();

  // Utilisateur actuel
  UserModel? _currentUser;
  
  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // ========================================================================================
  // MÉTHODES D'AUTHENTIFICATION
  // ========================================================================================

  /// Authentifie un utilisateur avec son numéro de téléphone
  Future<bool> loginWithPhone(String phoneNumber) async {
    try {
      // Simulation d'une authentification par SMS
      // Dans une vraie application, vous feriez un appel API ici
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulation d'un utilisateur trouvé
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
      );
      
      return true;
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      return false;
    }
  }

  /// Vérifie le code SMS
  Future<bool> verifySMSCode(String code) async {
    try {
      // Simulation de la vérification du code SMS
      // Dans une vraie application, vous feriez un appel API ici
      await Future.delayed(const Duration(seconds: 1));
      
      // Code de test: 123456
      if (code == '123456') {
        return true;
      }
      return false;
    } catch (e) {
      print('Erreur lors de la vérification du code: $e');
      return false;
    }
  }

  /// Déconnecte l'utilisateur actuel
  void logout() {
    _currentUser = null;
  }

  // ========================================================================================
  // MÉTHODES DE GESTION DU PROFIL
  // ========================================================================================

  /// Met à jour les informations du profil utilisateur
  Future<bool> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? profileImagePath,
  }) async {
    try {
      if (_currentUser == null) return false;

      // Simulation d'une mise à jour en base de données
      await Future.delayed(const Duration(seconds: 1));

      _currentUser = _currentUser!.copyWith(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        profileImagePath: profileImagePath,
        updatedAt: DateTime.now(),
      );

      return true;
    } catch (e) {
      print('Erreur lors de la mise à jour du profil: $e');
      return false;
    }
  }

  /// Sélectionne une image de profil depuis la galerie
  Future<String?> pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        return image.path;
      }
      return null;
    } catch (e) {
      print('Erreur lors de la sélection de l\'image: $e');
      return null;
    }
  }

  /// Prend une photo avec la caméra pour le profil
  Future<String?> takeProfilePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        return image.path;
      }
      return null;
    } catch (e) {
      print('Erreur lors de la prise de photo: $e');
      return null;
    }
  }

  /// Valide le format d'un email
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Valide le format d'un numéro de téléphone burkinabé
  bool isValidPhoneNumber(String phoneNumber) {
    // Format: +226 XX XX XX XX ou 226 XX XX XX XX
    return RegExp(r'^(\+226|226)?\s?[0-9]{2}\s?[0-9]{2}\s?[0-9]{2}\s?[0-9]{2}$').hasMatch(phoneNumber);
  }

  /// Valide le format d'un nom complet
  bool isValidFullName(String fullName) {
    // Au moins 2 mots, chaque mot au moins 2 caractères
    return RegExp(r'^[a-zA-ZÀ-ÿ\s]{2,}\s+[a-zA-ZÀ-ÿ\s]{2,}$').hasMatch(fullName);
  }

  // ========================================================================================
  // MÉTHODES UTILITAIRES
  // ========================================================================================

  /// Obtient les initiales de l'utilisateur
  String getUserInitials() {
    if (_currentUser?.fullName == null) return 'U';
    
    final names = _currentUser!.fullName!.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return _currentUser!.fullName![0].toUpperCase();
  }

  /// Obtient le nom d'affichage de l'utilisateur
  String getDisplayName() {
    if (_currentUser?.fullName != null && _currentUser!.fullName!.isNotEmpty) {
      return _currentUser!.fullName!;
    }
    if (_currentUser?.phoneNumber != null) {
      return _currentUser!.phoneNumber!;
    }
    return 'Utilisateur';
  }

  /// Vérifie si l'utilisateur a un profil complet
  bool hasCompleteProfile() {
    if (_currentUser == null) return false;
    
    return _currentUser!.fullName != null &&
           _currentUser!.fullName!.isNotEmpty &&
           _currentUser!.email != null &&
           _currentUser!.email!.isNotEmpty;
  }

  /// Obtient le pourcentage de complétion du profil
  double getProfileCompletionPercentage() {
    if (_currentUser == null) return 0.0;
    
    int completedFields = 0;
    int totalFields = 4; // fullName, email, phoneNumber, profileImagePath
    
    if (_currentUser!.fullName != null && _currentUser!.fullName!.isNotEmpty) completedFields++;
    if (_currentUser!.email != null && _currentUser!.email!.isNotEmpty) completedFields++;
    if (_currentUser!.phoneNumber != null && _currentUser!.phoneNumber!.isNotEmpty) completedFields++;
    if (_currentUser!.profileImagePath != null && _currentUser!.profileImagePath!.isNotEmpty) completedFields++;
    
    return completedFields / totalFields;
  }
}
