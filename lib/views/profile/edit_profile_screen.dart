// ========================================================================================
// ÉCRAN: MODIFIER LE PROFIL UTILISATEUR
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Définition de la couleur principale (Vert)
  static const Color primaryColor = Color(0xFF14B53A);

  // ========================================================================================
  // CONTRÔLEURS DE CHAMPS DE TEXTE
  // ========================================================================================
  final TextEditingController _nameController = TextEditingController(text: 'Tenen M Sylla');
  final TextEditingController _emailController = TextEditingController(text: 'madyehsylla427@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: '••••••••••••');
  final TextEditingController _phoneController = TextEditingController(text: '+223 74323874');

  // ========================================================================================
  // VARIABLES D'ÉTAT POUR LA GESTION DE L'IMAGE DE PROFIL
  // ========================================================================================
  File? _profileImage;

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

  /// Permet à l'utilisateur de sélectionner une image depuis la galerie
  Future<void> _pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de l\'image: $e')),
      );
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
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.04),

                        // PHOTO DE PROFIL AVEC BOUTON DE MODIFICATION
                        Stack(
                          children: [
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
                                child: _profileImage != null
                                    ? Image.file(
                                  _profileImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                                    : Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.grey[600],
                                    size: screenWidth * 0.2,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickProfileImage,
                                child: Container(
                                  width: screenWidth * 0.1,
                                  height: screenWidth * 0.1,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey, width: 1),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.black,
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

                              // Bouton Enregistrer (Renvoie les nouvelles données)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // 1. Logique de sauvegarde (simulée)
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Profil mis à jour avec succès!')),
                                    );

                                    // 2. Créer un Map avec les nouvelles valeurs
                                    final Map<String, String> updatedData = {
                                      'name': _nameController.text,
                                      'email': _emailController.text,
                                      'phone': _phoneController.text,
                                      // Note: Ajouter d'autres champs si besoin
                                    };

                                    // 3. Fermer l'écran et envoyer les données mises à jour
                                    Navigator.of(context).pop(updatedData);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
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