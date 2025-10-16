// ========================================================================================
// ÉCRAN: MODIFIER LE PROFIL UTILISATEUR
// ========================================================================================
// Cet écran permet à l'utilisateur de modifier ses informations personnelles :
// - Nom complet
// - Adresse email
// - Mot de passe
// - Numéro de téléphone
// - Photo de profil (sélection depuis la galerie)
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
  // ========================================================================================
  // CONTRÔLEURS DE CHAMPS DE TEXTE
  // ========================================================================================
  // Contrôleurs pour gérer les valeurs des champs de saisie avec des valeurs par défaut
  final TextEditingController _nameController = TextEditingController(text: 'Tenen M Sylla');
  final TextEditingController _emailController = TextEditingController(text: 'madyehsylla427@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: '••••••••••••');
  final TextEditingController _phoneController = TextEditingController(text: '+223 74323874');
  
  // ========================================================================================
  // VARIABLES D'ÉTAT POUR LA GESTION DE L'IMAGE DE PROFIL
  // ========================================================================================
  File? _profileImage;        // Fichier image sélectionné
  String? _profileImagePath;  // Chemin vers l'image sélectionnée

  // ========================================================================================
  // MÉTHODES DE LIFECYCLE
  // ========================================================================================
  
  /// Libère les ressources des contrôleurs de texte
  /// Appelée automatiquement quand le widget est supprimé
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
  /// L'image est redimensionnée et compressée pour optimiser les performances
  Future<void> _pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      // Sélection d'une image depuis la galerie avec contraintes de taille
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,  // Sélection depuis la galerie
        maxWidth: 1024,               // Largeur maximale de 1024px
        maxHeight: 1024,              // Hauteur maximale de 1024px
        imageQuality: 80,             // Qualité de compression à 80%
      );
      
      // Si une image a été sélectionnée, mettre à jour l'état
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);      // Convertir en File
          _profileImagePath = image.path;        // Sauvegarder le chemin
        });
      }
    } catch (e) {
      // Afficher un message d'erreur en cas de problème
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de l\'image: $e')),
      );
    }
  }

  // ========================================================================================
  // MÉTHODE BUILD - CONSTRUCTION DE L'INTERFACE UTILISATEUR
  // ========================================================================================
  
  /// Construit l'interface utilisateur de l'écran de modification de profil
  /// Utilise un LayoutBuilder pour s'adapter à différentes tailles d'écran
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Fond blanc pour l'écran
      body: SafeArea(  // Zone sûre qui évite les encoches et la barre de statut
        child: LayoutBuilder(  // Builder qui fournit les contraintes de taille
          builder: (context, constraints) {
            // ========================================================================================
            // CALCUL DES DIMENSIONS RESPONSIVES
            // ========================================================================================
            final screenWidth = constraints.maxWidth;     // Largeur de l'écran
            final screenHeight = constraints.maxHeight;   // Hauteur de l'écran
            final horizontalPadding = screenWidth * 0.05; // Padding horizontal (5% de la largeur)
            final verticalPadding = screenHeight * 0.02;  // Padding vertical (2% de la hauteur)
            
            return Column(
              children: [
                // ========================================================================================
                // HEADER AVEC BOUTON RETOUR, TITRE ET LOGOUT
                // ========================================================================================
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ========================================================================================
                      // BOUTON RETOUR - Permet de revenir à l'écran précédent
                      // ========================================================================================
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),  // Navigation retour
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.orange,  // Couleur orange FasoDocs
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: screenWidth * 0.05,
                          ),
                        ),
                      ),
                      // ========================================================================================
                      // TITRE DE LA PAGE
                      // ========================================================================================
                      Text(
                        'Modifier le profil',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      // ========================================================================================
                      // BOUTON DÉCONNEXION - Permet à l'utilisateur de se déconnecter
                      // ========================================================================================
                      GestureDetector(
                        onTap: () {
                          // TODO: Implémenter l'action de déconnexion
                        },
                        child: Icon(
                          Icons.logout,
                          color: Colors.red,  // Couleur rouge pour indiquer une action importante
                          size: screenWidth * 0.06,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // ========================================================================================
                // CONTENU PRINCIPAL - Zone scrollable avec les champs de modification
                // ========================================================================================
                Expanded(
                  child: SingleChildScrollView(  // Permet le défilement si le contenu dépasse
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.04),
                        
                        // ========================================================================================
                        // PHOTO DE PROFIL AVEC BOUTON DE MODIFICATION
                        // ========================================================================================
                        Stack(
                          children: [
                            Container(
                              width: screenWidth * 0.4,
                              height: screenWidth * 0.4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.green,
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child: _profileImagePath != null
                                    ? Image.network(
                                        _profileImagePath!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.grey[600],
                                              size: screenWidth * 0.2,
                                            ),
                                          );
                                        },
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
                        
                        // Conteneur principal avec bordure verte
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // Champ Nom
                              _buildEditField(
                                context,
                                screenWidth,
                                screenHeight,
                                Icons.person,
                                _nameController,
                                'Nom complet',
                              ),
                              
                              SizedBox(height: screenHeight * 0.02),
                              
                              // Champ Email
                              _buildEditField(
                                context,
                                screenWidth,
                                screenHeight,
                                Icons.email,
                                _emailController,
                                'Email',
                              ),
                              
                              SizedBox(height: screenHeight * 0.02),
                              
                              // Champ Mot de passe
                              _buildEditField(
                                context,
                                screenWidth,
                                screenHeight,
                                Icons.lock,
                                _passwordController,
                                'Mot de passe',
                                isPassword: true,
                              ),
                              
                              SizedBox(height: screenHeight * 0.02),
                              
                              // Champ Téléphone
                              _buildEditField(
                                context,
                                screenWidth,
                                screenHeight,
                                Icons.phone,
                                _phoneController,
                                'Téléphone',
                              ),
                              
                              SizedBox(height: screenHeight * 0.04),
                              
                              // Bouton Enregistrer
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Action de sauvegarde
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Profil mis à jour avec succès!')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
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

  Widget _buildEditField(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    IconData icon,
    TextEditingController controller,
    String hintText, {
    bool isPassword = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.015,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.black,
            size: screenWidth * 0.05,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.grey[600],
          ),
          border: InputBorder.none,
        ),
        style: TextStyle(
          fontSize: screenWidth * 0.04,
          color: Colors.black,
        ),
      ),
    );
  }
}