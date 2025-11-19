// ========================================================================================
// ÉCRAN: MODIFIER LE PROFIL UTILISATEUR
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/profil_service.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/photo_service.dart';
import '../../core/config/api_config.dart';
import '../../core/widgets/profile_avatar.dart';

class EditProfileScreen extends StatefulWidget {
  final String? currentName;
  final String? currentEmail;
  final String? currentPhone;
  
  const EditProfileScreen({
    super.key,
    this.currentName,
    this.currentEmail,
    this.currentPhone,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Définition de la couleur principale (Vert)
  static const Color primaryColor = Color(0xFF14B53A);

  // ========================================================================================
  // CONTRÔLEURS DE CHAMPS DE TEXTE
  // ========================================================================================
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;

  // ========================================================================================
  // VARIABLES D'ÉTAT POUR LA GESTION DE L'IMAGE DE PROFIL
  // ========================================================================================
  File? _profileImage;
  String? _currentPhotoBase64; // Photo actuelle depuis le backend
  bool _isLoading = false;
  bool _isUploading = false;

  // Services
  final ProfilService _profilService = profilService;
  final AuthService _authService = authService;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName ?? '');
    _emailController = TextEditingController(text: widget.currentEmail ?? '');
    _passwordController = TextEditingController(text: '••••••••••••');
    _phoneController = TextEditingController(text: widget.currentPhone ?? '');
    _loadCurrentProfile();
  }

  /// Charge le profil actuel depuis le backend
  Future<void> _loadCurrentProfile() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authService.getProfil();
      setState(() {
        // Utiliser photoProfil au lieu de photo (correction importante)
        _currentPhotoBase64 = user.photoProfil;
        if (widget.currentName == null) {
          _nameController.text = user.nomComplet;
        }
        if (widget.currentEmail == null) {
          _emailController.text = user.email;
        }
        if (widget.currentPhone == null) {
          _phoneController.text = user.telephone;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('❌ Erreur chargement profil: $e');
    }
  }

  // ========================================================================================
  // MÉTHODES DE LIFECYCLE
  // ========================================================================================

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ========================================================================================
  // MÉTHODES UTILITAIRES
  // ========================================================================================

  /// Permet à l'utilisateur de sélectionner une image (galerie ou caméra)
  Future<void> _pickProfileImage() async {
    try {
      debugPrint('📸 ===== DÉBUT SÉLECTION PHOTO =====');
      final File? selectedFile = await _profilService.showImageSourceDialog(context);
      
      if (selectedFile != null) {
        debugPrint('📸 Photo sélectionnée: ${selectedFile.path}');
        setState(() {
          _profileImage = selectedFile;
          _currentPhotoBase64 = null; // Réinitialiser la photo actuelle
        });
        debugPrint('📸 Photo stockée dans _profileImage');
        debugPrint('📸 ===== FIN SÉLECTION PHOTO =====');
      } else {
        debugPrint('⚠️ Aucune photo sélectionnée');
      }
    } catch (e) {
      debugPrint('❌ Erreur sélection photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection de l\'image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Test d'upload photo simple (pour debug)
  Future<void> _testUploadPhotoSimple() async {
    try {
      setState(() => _isUploading = true);
      
      // Récupérer le token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token == null || token.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token d\'authentification manquant'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      
      // Utiliser le service simple
      await uploadPhotoProfil(token, ApiConfig.baseUrl);
      
      // Recharger le profil pour voir la nouvelle photo
      await _loadCurrentProfile();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo uploadée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Erreur test upload photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  /// Sauvegarde le profil (nom, prénom, photo)
  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le nom est requis'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    try {
      // Séparer nom et prénom (si format "Nom Prénom")
      final nameParts = _nameController.text.trim().split(' ');
      final nom = nameParts.isNotEmpty ? nameParts.first : _nameController.text.trim();
      final prenom = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // 🔍 LOG : Vérifier si une photo est sélectionnée
      debugPrint('💾 ===== DÉBUT SAUVEGARDE PROFIL =====');
      debugPrint('   - Nom: $nom');
      debugPrint('   - Prénom: $prenom');
      debugPrint('   - Photo sélectionnée: ${_profileImage != null}');
      if (_profileImage != null) {
        debugPrint('   - Chemin photo: ${_profileImage!.path}');
        try {
          final fileSize = await _profileImage!.length();
          debugPrint('   - Taille photo: $fileSize bytes');
        } catch (e) {
          debugPrint('   - Erreur lecture taille: $e');
        }
        debugPrint('✅ Photo sera uploadée via endpoint dédié POST /api/auth/profil/photo');
      } else {
        debugPrint('⚠️ Aucune photo à uploader');
      }

      // ✅ Utiliser updateProfilComplet qui appelle l'endpoint dédié pour la photo
      debugPrint('📤 Appel de updateProfilComplet...');
      await _profilService.updateProfilComplet(
        nom: nom,
        prenom: prenom,
        photoFile: _profileImage, // Inclure la photo si elle a été sélectionnée (sera convertie en Base64 automatiquement)
      );
      debugPrint('✅ updateProfilComplet terminé');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil mis à jour avec succès !'),
            backgroundColor: Colors.green,
          ),
        );

        // Retourner les données mises à jour
        final Map<String, String> updatedData = {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
        };

        Navigator.of(context).pop(updatedData);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la mise à jour: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      debugPrint('❌ Erreur sauvegarde profil: $e');
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  // Fonction utilitaire pour construire les champs de saisie
  Widget _buildEditField(
      BuildContext context,
      double screenWidth,
      double screenHeight,
      IconData icon,
      TextEditingController controller,
      String hintText, {
        bool isPassword = false,
      }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.005,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: primaryColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(
          fontSize: screenWidth * 0.04,
          color: textColor,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: textColor,
            size: screenWidth * 0.05,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: screenWidth * 0.04,
            color: isDarkMode ? Colors.grey.shade500 : Colors.grey[600],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
        ),
      ),
    );
  }

  // ========================================================================================
  // MÉTHODE BUILD - CONSTRUCTION DE L'INTERFACE UTILISATEUR
  // ========================================================================================

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {

            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final horizontalPadding = screenWidth * 0.05;
            final verticalPadding = screenHeight * 0.02;

            return Column(
              children: [
                // ========================================================================================
                // HEADER AVEC BOUTON FERMETURE (X) ET TITRE
                // ========================================================================================
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // BOUTON FERMETURE (X)
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(), // Fermeture sans signal de mise à jour
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: Icon(
                            Icons.close, // Icône de fermeture (X)
                            color: textColor,
                            size: screenWidth * 0.06,
                          ),
                        ),
                      ),
                      // TITRE DE LA PAGE
                      Text(
                        'Modifier le profil',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      // EMPLACEMENT VIDE
                      SizedBox(width: screenWidth * 0.1),
                    ],
                  ),
                ),

                // ========================================================================================
                // CONTENU PRINCIPAL
                // ========================================================================================
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding,
                      MediaQuery.of(context).viewInsets.bottom,
                    ),
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.04),

                        // PHOTO DE PROFIL AVEC BOUTON DE MODIFICATION
                        Stack(
                          children: [
                            // Avatar avec photo actuelle ou nouvelle photo sélectionnée
                            if (_isLoading)
                              Container(
                                width: screenWidth * 0.4,
                                height: screenWidth * 0.4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 3,
                                  ),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                                  ),
                                ),
                              )
                            else if (_profileImage != null)
                              Container(
                                width: screenWidth * 0.4,
                                height: screenWidth * 0.4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 3,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.file(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                              )
                            else
                              Container(
                                width: screenWidth * 0.4,
                                height: screenWidth * 0.4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 3,
                                  ),
                                ),
                                child: ProfileAvatar(
                                  photoBase64: _currentPhotoBase64,
                                  radius: screenWidth * 0.2,
                                  backgroundColor: isDarkMode ? Colors.grey.shade700 : Colors.grey[300],
                                  defaultIcon: Icons.person,
                                  defaultIconSize: screenWidth * 0.2,
                                ),
                              ),
                            // Bouton pour changer la photo
                            if (!_isLoading)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _pickProfileImage,
                                  child: Container(
                                    width: screenWidth * 0.1,
                                    height: screenWidth * 0.1,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: screenWidth * 0.05,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // Conteneur principal des champs
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              _buildEditField(
                                context, screenWidth, screenHeight,
                                Icons.person, _nameController, 'Nom complet',
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              _buildEditField(
                                context, screenWidth, screenHeight,
                                Icons.email, _emailController, 'Email',
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              _buildEditField(
                                context, screenWidth, screenHeight,
                                Icons.lock, _passwordController, 'Mot de passe',
                                isPassword: true,
                              ),

                              SizedBox(height: screenHeight * 0.02),

                              _buildEditField(
                                context, screenWidth, screenHeight,
                                Icons.phone, _phoneController, 'Téléphone',
                              ),

                              SizedBox(height: screenHeight * 0.04),

                              // Bouton de test pour upload photo simple (optionnel - pour debug)
                              if (kDebugMode)
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _isUploading ? null : _testUploadPhotoSimple,
                                    icon: const Icon(Icons.photo_camera),
                                    label: const Text('Test Upload Photo Simple'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: primaryColor,
                                      side: BorderSide(color: primaryColor),
                                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                                    ),
                                  ),
                                ),

                              if (kDebugMode) SizedBox(height: screenHeight * 0.02),

                              // Bouton Enregistrer
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isUploading ? null : _saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    disabledBackgroundColor: Colors.grey,
                                  ),
                                  child: _isUploading
                                      ? SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Text(
                                          'Enregistrer',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),
                      ],
                    ),
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