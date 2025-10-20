// ========================================================================================
// FASODOCS - APPLICATION MOBILE DE GESTION ADMINISTRATIVE
// ========================================================================================
// Cette application permet aux citoyens burkinabés d'effectuer leurs démarches 
// administratives de manière simplifiée et centralisée.
//
// Fonctionnalités principales :
// - Authentification par SMS
// - Gestion des documents administratifs
// - Notifications des mises à jour
// - Suivi des démarches
// - Support multilingue (Français/English)
// ========================================================================================

// Imports Flutter essentiels
import 'package:fasodocs/views/auto/auto_screen.dart';
import 'package:fasodocs/views/business/business_screen.dart';
import 'package:fasodocs/views/justice/justice_screen.dart';
import 'package:fasodocs/views/land/land_screen.dart';
import 'package:fasodocs/views/tax/tax_screen.dart';
import 'package:fasodocs/views/utilities/utilities_screen.dart';
import 'package:flutter/material.dart';  // Framework UI principal
import 'package:flutter/services.dart';  // Services système (orientation, statut bar)
import 'package:image_picker/image_picker.dart';  // Sélection d'images depuis galerie/caméra
import 'dart:io';  // Gestion des fichiers locaux

// Imports des écrans spécialisés pour les différentes catégories de démarches
import 'residence_screen.dart';   // Écran pour les démarches de résidence

// ========================================================================================
// CLASSE GLOBALE POUR LA GESTION DU SIGNALEMENT
// ========================================================================================
// Cette classe permet d'accéder aux fonctionnalités de report depuis n'importe
// où dans l'application via une méthode statique.
class GlobalReportAccess {
  /// Affiche un dialogue de confirmation pour signaler un problème
  /// Cette méthode peut être appelée depuis n'importe quel écran de l'application
  /// 
  /// @param context Le contexte de l'écran appelant
  static void showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Titre du dialogue
          title: const Text('Signaler un problème'),
          // Message de confirmation
          content: const Text('Voulez-vous signaler un problème ou faire une suggestion ?'),
          actions: [
            // Bouton d'annulation - ferme le dialogue sans action
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: const Text('Annuler'),
            ),
            // Bouton de confirmation - navigue vers l'écran de signalement
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue actuel
                // Navigue vers l'écran de signalement de problème
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ReportProblemScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // Couleur verte FasoDocs
                foregroundColor: Colors.white,
              ),
              child: const Text('Continuer'),
            ),
          ],
        );
      },
    );
  }
}


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
                            color: Colors.orange,  // Couleur orange pour le bouton
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

// ÉCRAN: PROFIL
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final horizontalPadding = screenWidth * 0.05;
            final verticalPadding = screenHeight * 0.02;
            
            return Column(
              children: [
                // Header avec bouton retour, titre et menu
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bouton retour
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: screenWidth * 0.05,
                          ),
                        ),
                      ),
                      // Titre
                      Text(
                        'Profil',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      // Menu trois points
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.grey[600],
                          size: screenWidth * 0.06,
                        ),
                        onSelected: (String value) {
                          if (value == 'history') {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const HistoryScreen()),
                            );
                          } else if (value == 'report') {
                            GlobalReportAccess.showReportDialog(context);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'history',
                            child: Row(
                              children: [
                                Icon(Icons.history, color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Historique'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'report',
                            child: Row(
                              children: [
                                Icon(Icons.report_problem, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Signaler un problème'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Contenu principal
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.04),
                        
                        // Photo de profil
                        Container(
                          width: screenWidth * 0.3,
                          height: screenWidth * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[600],
                            size: screenWidth * 0.15,
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.02),
                        
                        // Nom de l'utilisateur
                        Text(
                          'Daba Diarra',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.01),
                        
                        // Email
                        Text(
                          'daba.diarra@gmail.com',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black,
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.04),
                        
                        // Cartes d'informations
                        _buildProfileCard(
                          context,
                          screenWidth,
                          screenHeight,
                          Icons.phone,
                          'Téléphone',
                          '+223 76 00 00 00',
                        ),
                        
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildProfileCard(
                          context,
                          screenWidth,
                          screenHeight,
                          Icons.location_on,
                          'Adresse',
                          'Hamdallaye ACI 2000',
                        ),
                        
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildProfileCard(
                          context,
                          screenWidth,
                          screenHeight,
                          Icons.calendar_today,
                          'Date de naissance',
                          '01/01/1990',
                        ),
                        
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildProfileCard(
                          context,
                          screenWidth,
                          screenHeight,
                          Icons.person,
                          'Genre',
                          'Femme',
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

  Widget _buildProfileCard(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth * 0.12,
            height: screenWidth * 0.12,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.green,
              size: screenWidth * 0.06,
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
            child: Icon(
              Icons.edit,
              color: Colors.grey[600],
              size: screenWidth * 0.05,
            ),
          ),
        ],
      ),
    );
  }
}

// ÉCRAN: HISTORIQUE
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final horizontalPadding = screenWidth * 0.05;
            final verticalPadding = screenHeight * 0.02;
            
            return Column(
              children: [
                // Header avec logo FasoDocs et profil
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo FasoDocs
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/FasoDocs1.png',
                            width: screenWidth * 0.08,
                            height: screenWidth * 0.08 * 0.6,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'FasoDocs',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      // Profil et notifications
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const ProfileScreen()),
                              );
                            },
                            child: Container(
                              width: screenWidth * 0.1,
                              height: screenWidth * 0.1,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.grey[600],
                                size: screenWidth * 0.05,
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Stack(
                            children: [
                              Icon(
                                Icons.notifications_outlined,
                                color: Colors.grey[600],
                                size: screenWidth * 0.06,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: screenWidth * 0.03,
                                  height: screenWidth * 0.03,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '3',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.025,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.grey[600],
                              size: screenWidth * 0.06,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Contenu principal
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre avec bouton retour
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: screenWidth * 0.05,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Text(
                              'Historique',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: screenHeight * 0.04),
                        
                        // Liste des activités
                        _buildHistoryItem(
                          context,
                          screenWidth,
                          screenHeight,
                          Icons.credit_card,
                          Colors.orange,
                          'Demande de passport',
                          'Il y a 2 heures',
                        ),
                        
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildHistoryItem(
                          context,
                          screenWidth,
                          screenHeight,
                          Icons.description,
                          Colors.blue,
                          'Acte de naissance',
                          'Il y a 1 j',
                        ),
                        
                        SizedBox(height: screenHeight * 0.02),
                        
                        _buildHistoryItem(
                          context,
                          screenWidth,
                          screenHeight,
                          Icons.warning,
                          Colors.red,
                          'Signalement du tribunal de hamdallaye',
                          '15 Avril 2025',
                        ),
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

  Widget _buildHistoryItem(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    IconData icon,
    Color iconColor,
    String title,
    String time,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth * 0.12,
            height: screenWidth * 0.12,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: screenWidth * 0.06,
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ÉCRAN: SIGNALER UN PROBLÈME
class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  File? _selectedImage;
  String? _selectedImagePath;
  final ImagePicker _picker = ImagePicker();
  String? _selectedReportType;
  final TextEditingController _structureController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  final List<String> _reportTypes = [
    'Problème technique',
    'Erreur de contenu',
    'Suggestion d\'amélioration',
    'Signalement d\'abus',
    'Autre',
  ];

  @override
  void dispose() {
    _structureController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de l\'image: $e')),
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
            final horizontalPadding = screenWidth * 0.05;
            final verticalPadding = screenHeight * 0.02;
            
            return Column(
              children: [
                // Header avec logo FasoDocs et profil
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo FasoDocs
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/FasoDocs1.png',
                            width: screenWidth * 0.08,
                            height: screenWidth * 0.08 * 0.6,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'FasoDocs',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      // Profil et notifications
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const ProfileScreen()),
                              );
                            },
                            child: Container(
                              width: screenWidth * 0.1,
                              height: screenWidth * 0.1,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.grey[600],
                                size: screenWidth * 0.05,
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Stack(
                            children: [
                              Icon(
                                Icons.notifications_outlined,
                                color: Colors.grey[600],
                                size: screenWidth * 0.06,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: screenWidth * 0.03,
                                  height: screenWidth * 0.03,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '3',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.025,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const HistoryScreen()),
                              );
                            },
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.grey[600],
                              size: screenWidth * 0.06,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Contenu principal
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre avec bouton retour
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Container(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: screenWidth * 0.05,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Text(
                              'Signaler un problème',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        
                        SizedBox(height: screenHeight * 0.04),
                        
                        // Type de signalement
                        Text(
                          'Type de report',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedReportType,
                              hint: Text(
                                'Sélectionnez un type',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.grey[600],
                                ),
                              ),
                              isExpanded: true,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                                size: screenWidth * 0.05,
                              ),
                              items: _reportTypes.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedReportType = newValue;
                                });
                              },
                            ),
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.03),
                        
                        // Structure concernée
                        Text(
                          'Structure concernée',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _structureController,
                            decoration: InputDecoration(
                              hintText: 'Nom de la structure',
                              hintStyle: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.grey[600],
                              ),
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: Colors.grey[600],
                                size: screenWidth * 0.05,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.03),
                        
                        // Description
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.15,
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _descriptionController,
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
                              hintText: 'Description du problème rencontré...',
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
                        ),
                        
                        SizedBox(height: screenHeight * 0.03),
                        
                        // Ajouter une photo
                        Text(
                          'Ajouter une photo (optionel)',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: screenHeight * 0.2,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[400]!, width: 2, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _selectedImagePath != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(
                                      _selectedImagePath!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.grey[600],
                                            size: screenWidth * 0.08,
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[600],
                                          size: screenWidth * 0.08,
                                        ),
                                        SizedBox(height: screenHeight * 0.01),
                                        Text(
                                          'Appuyez pour ajouter une photo',
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.035,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.04),
                        
                        // Bouton Envoyer le signalement
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Action d'envoi du signalement
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Envoyer le report',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Icon(
                                  Icons.send,
                                  size: screenWidth * 0.05,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.02),
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

// ========================================================================================
// POINT D'ENTRÉE PRINCIPAL DE L'APPLICATION
// ========================================================================================

/// Fonction principale qui lance l'application FasoDocs
/// Cette fonction est le point d'entrée de l'application Flutter
void main() {
  runApp(const FasoDocsApp());
}

// ========================================================================================
// CLASSE PRINCIPALE DE L'APPLICATION FASODOCS
// ========================================================================================
// Cette classe configure l'application Flutter avec :
// - L'orientation en mode portrait uniquement
// - Le titre de l'application
// - Le premier écran affiché (SplashScreen)
// - La désactivation de la bannière de debug
// ========================================================================================
class FasoDocsApp extends StatelessWidget {
  const FasoDocsApp({super.key});

  /// Construit l'application FasoDocs avec la configuration de base
  @override
  Widget build(BuildContext context) {
    // ========================================================================================
    // CONFIGURATION DE L'ORIENTATION
    // ========================================================================================
    // Force l'application à rester en mode portrait uniquement
    // pour une meilleure expérience utilisateur sur mobile
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,    // Portrait normal
      DeviceOrientation.portraitDown,  // Portrait inversé
    ]);

    // ========================================================================================
    // CONFIGURATION DE L'APPLICATION FLUTTER
    // ========================================================================================
    return MaterialApp(
      title: 'FasoDocs',                    // Titre de l'application
      debugShowCheckedModeBanner: false,   // Masque la bannière "DEBUG" en mode développement
      home: const SplashScreen(),          // Premier écran affiché au lancement
    );
  }
}

// ========================================================================================
// ÉCRAN 1: SPLASH SCREEN - ÉCRAN DE CHARGEMENT INITIAL
// ========================================================================================
// Premier écran affiché au lancement de l'application.
// Affiche le logo FasoDocs et redirige automatiquement vers l'écran d'onboarding
// après 3 secondes de chargement.
// ========================================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // ========================================================================================
  // MÉTHODE D'INITIALISATION
  // ========================================================================================
  
  /// Initialise l'écran de splash avec la configuration de l'interface système
  /// et programme la navigation automatique vers l'onboarding après 3 secondes
  @override
  void initState() {
    super.initState();
    
    // ========================================================================================
    // CONFIGURATION DE L'INTERFACE SYSTÈME
    // ========================================================================================
    // Configure l'apparence de la barre de statut et de navigation
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,        // Barre de statut transparente
        statusBarIconBrightness: Brightness.dark, // Icônes sombres sur fond clair
        systemNavigationBarColor: Colors.white,    // Barre de navigation blanche
        systemNavigationBarIconBrightness: Brightness.dark, // Icônes sombres
      ),
    );

    // ========================================================================================
    // NAVIGATION AUTOMATIQUE VERS L'ONBOARDING
    // ========================================================================================
    // Attend 3 secondes puis navigue vers l'écran d'onboarding
    // Vérifie que le widget est toujours monté avant de naviguer
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {  // Vérification que le widget existe encore
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  // ========================================================================================
  // MÉTHODE BUILD - CONSTRUCTION DE L'INTERFACE UTILISATEUR
  // ========================================================================================
  
  /// Construit l'interface utilisateur du splash screen
  /// Affiche le logo FasoDocs centré avec le texte de l'application
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Fond blanc pour l'écran de splash
      body: SafeArea(  // Zone sûre qui évite les encoches et la barre de statut
        child: LayoutBuilder(  // Builder qui fournit les contraintes de taille
          builder: (context, constraints) {
            // ========================================================================================
            // CALCUL DES DIMENSIONS RESPONSIVES
            // ========================================================================================
            final screenWidth = constraints.maxWidth;     // Largeur de l'écran
            final logoSize = screenWidth * 0.3;           // Taille du logo (30% de la largeur)
            final fontSize = screenWidth * 0.08;          // Taille de police (8% de la largeur)
            
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,  // Colonne centrée verticalement
                children: [
                  // ========================================================================================
                  // LOGO FASODOCS - Image principale du splash screen
                  // ========================================================================================
                  Image.asset(
                    'assets/images/FasoDocs1.png',
                    width: logoSize,
                    height: logoSize * 0.6,
                    fit: BoxFit.contain,
                  ),
                  
                  SizedBox(height: screenWidth * 0.02),
                  
                  // Texte FasoDocs
                  Text(
                    'FasoDocs',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ÉCRAN 2: ONBOARDING (exactement comme la photo)
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

  String _getFullText(int index) {
    switch (index) {
      case 0:
        return "Obtenir un document administratif au Mali ? C'est souvent la promesse de longues files d'attente, de paperasse incompréhensible et de frais imprévus.";
      case 1:
        return "Vos démarches administratives sans complexité. Des procédures guidées et des informations fiables enfin accessibles à tous.";
      case 2:
        return "La complexité, nous la gérons.\nLa simplicité, nous vous la livrons.";
      default:
        return "";
    }
  }
}

// ÉCRAN 3: LOGIN SCREEN (exactement comme la photo)
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
                        'assets/images/FasoDocs1.png',
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
                      RichText(
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

// ÉCRAN 4: SIGNUP SCREEN (exactement comme la photo)
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;

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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _goToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/confiance.png'),
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
                // Header avec bouton retour (exactement comme la photo)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _goToLogin,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF14B53A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Inscription',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Contenu principal (exactement comme la photo)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Champ Téléphone (exactement comme la photo)
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Téléphone',
                          prefixIcon: const Icon(
                            Icons.phone_outlined,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A), width: 2),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Champ Email (exactement comme la photo)
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A), width: 2),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Champ Mot de passe (exactement comme la photo)
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible 
                                  ? Icons.visibility_off 
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A), width: 2),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Champ Confirmer mot de passe (exactement comme la photo)
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Confirmer votre mot de passe',
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible 
                                  ? Icons.visibility_off 
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFF14B53A), width: 2),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Checkbox conditions d'utilisation (exactement comme la photo)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (value) {
                              setState(() {
                                _acceptTerms = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF14B53A),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: RichText(
                                text: const TextSpan(
                                  text: "J'accepte les ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "conditions d'utilisation",
                                      style: TextStyle(
                                        color: Color(0xFF14B53A),
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Bouton d'inscription (exactement comme la photo)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleSignup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF14B53A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'S\'inscrire',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Lien vers connexion (exactement comme la photo)
                      Center(
                        child: TextButton(
                          onPressed: _goToLogin,
                          child: RichText(
                            text: const TextSpan(
                              text: "Vous avez déjà un compte ? ",
                              style: TextStyle(
                                color: Color(0xFF757575),
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: "Se connecter",
                                  style: TextStyle(
                                    color: Color(0xFF14B53A),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
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
        ),
      ),
    );
  }
}

// ========================================================================================
// ÉCRAN 5: HOME SCREEN - PAGE D'ACCUEIL PRINCIPALE
// ========================================================================================
// Écran principal de l'application FasoDocs qui contient :
// - Header avec logo FasoDocs, profil utilisateur et notifications
// - Bannière principale avec image et message de bienvenue
// - Section "Démarches Populaires" avec cartes scrollables
// - Barre de navigation inférieure avec 4 onglets principaux
// - Bouton flottant d'assistance client
// ========================================================================================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Construit l'interface utilisateur de la page d'accueil
  /// Utilise un design responsive qui s'adapte à différentes tailles d'écran
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Fond blanc pour l'écran d'accueil
      body: SafeArea(  // Zone sûre qui évite les encoches et la barre de statut
        child: Column(
          children: [
            // ========================================================================================
            // HEADER AVEC LOGO FASODOCS ET PROFIL UTILISATEUR
            // ========================================================================================
            // Contient le logo FasoDocs, le nom de l'application, l'avatar utilisateur,
            // l'icône de notifications avec badge, et le menu options
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Logo FasoDocs
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/FasoDocs1.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'FasoDocs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Profil utilisateur et notifications
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ProfileScreen()),
                          );
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                          );
                        },
                        child: Stack(
                          children: [
                            const Icon(
                              Icons.notifications_outlined,
                              color: Colors.black,
                              size: 24,
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                          size: 24,
                        ),
                        onSelected: (String value) {
                          if (value == 'history') {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const HistoryScreen()),
                            );
                          } else if (value == 'report') {
                            GlobalReportAccess.showReportDialog(context);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'history',
                            child: Row(
                              children: [
                                Icon(Icons.history, color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Historique'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'report',
                            child: Row(
                              children: [
                                Icon(Icons.report_problem, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Signaler un problème'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Bannière principale
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: AssetImage('assets/images/Acceuil.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Bienvenue sur FasoDocs',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Vos démarches administratives simplifiées',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Section Démarches Populaires
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Démarches Populaires',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const IdentityScreen(),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Text(
                          'Tout voir',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF14B53A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Color(0xFF14B53A),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Cartes horizontales des démarches populaires
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildPopularCard(
                    icon: Icons.home_outlined,
                    backgroundColor: const Color(0xFFE8F5E8),
                    iconColor: const Color(0xFF4CAF50),
                    title: 'Certificat de residence',
                  ),
                  const SizedBox(width: 12),
                  _buildPopularCard(
                    icon: Icons.credit_card,
                    backgroundColor: const Color(0xFFFFF9C4),
                    iconColor: const Color(0xFFFFB300),
                    title: 'Passeport',
                  ),
                  const SizedBox(width: 12),
                  _buildPopularCard(
                    icon: Icons.person_outline,
                    backgroundColor: const Color(0xFFFFEBEE),
                    iconColor: const Color(0xFFE91E63),
                    title: 'Acte de naissance',
                  ),
                  const SizedBox(width: 12),
                  _buildPopularCard(
                    icon: Icons.directions_car_outlined,
                    backgroundColor: const Color(0xFFE8F5E8),
                    iconColor: const Color(0xFF4CAF50),
                    title: 'Permis de conduire',
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Barre de navigation inférieure
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, -2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(
                      icon: Icons.home,
                      label: 'Accueil',
                      isActive: true,
                    ),
                    _buildNavItem(
                      icon: Icons.grid_view,
                      label: 'Catégorie',
                      isActive: false,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CategoryScreen(),
                          ),
                        );
                      },
                    ),
                    _buildNavItem(
                      icon: Icons.warning_outlined,
                      label: 'Alerte',
                      isActive: false,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const ReportProblemScreen()),
                        );
                      },
                    ),
                    _buildNavItem(
                      icon: Icons.settings_outlined,
                      label: 'Options',
                      isActive: false,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SettingsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bouton flottant de support
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 80, right: 16),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.headset_mic,
          color: Colors.black,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildPopularCard({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String title,
  }) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF14B53A).withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isActive ? const Color(0xFF14B53A) : Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF14B53A) : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ========================================================================================
// ÉCRAN: PARAMÈTRES (Settings) - CONFIGURATION DE L'APPLICATION
// ========================================================================================
// Cet écran permet à l'utilisateur de configurer l'application :
// - Changer la langue (Français/English)
// - Activer/désactiver les notifications
// - Activer/désactiver le mode sombre
// - Accéder à l'aide et au support
// - Se déconnecter de l'application
// - Informations sur la version de l'application
// ========================================================================================
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ========================================================================================
  // VARIABLES D'ÉTAT POUR LA GESTION DES PRÉFÉRENCES
  // ========================================================================================
  bool _notificationsEnabled = true;     // État des notifications (activé par défaut)
  bool _darkModeEnabled = true;          // État du mode sombre (activé par défaut)
  String _selectedLanguage = 'Français'; // Langue sélectionnée (Français par défaut)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec logo FasoDocs et profil utilisateur
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Logo FasoDocs
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/FasoDocs1.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'FasoDocs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Profil utilisateur et notifications
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Stack(
                        children: [
                          const Icon(
                            Icons.notifications_outlined,
                            color: Colors.black,
                            size: 24,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                          size: 24,
                        ),
                        onSelected: (String value) {
                          if (value == 'history') {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const HistoryScreen()),
                            );
                          } else if (value == 'report') {
                            GlobalReportAccess.showReportDialog(context);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'history',
                            child: Row(
                              children: [
                                Icon(Icons.history, color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Historique'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'report',
                            child: Row(
                              children: [
                                Icon(Icons.report_problem, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Signaler un problème'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Titre de la page avec bouton retour
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.green,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Paramètres',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Contenu principal
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Préférences
                    const Text(
                      'Préférences',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Langue
                    _buildSettingsItem(
                      icon: Icons.language,
                      title: 'Langue',
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _selectedLanguage,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      onTap: () {
                        _showLanguageDialog();
                      },
                    ),

                    const SizedBox(height: 12),

                    // Notifications
                    _buildSettingsItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notification',
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                        activeColor: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Mode sombre
                    _buildSettingsItem(
                      icon: Icons.dark_mode_outlined,
                      title: 'Mode sombre',
                      trailing: Switch(
                        value: _darkModeEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            _darkModeEnabled = value;
                          });
                        },
                        activeColor: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Section Support
                    const Text(
                      'Support',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Aide et support
                    _buildSettingsItem(
                      icon: Icons.help_outline,
                      title: 'Aide et support',
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Se déconnecter
                    _buildSettingsItem(
                      icon: Icons.logout,
                      title: 'Se déconnecter',
                      iconColor: Colors.red,
                      titleColor: Colors.red,
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 16,
                      ),
                      onTap: () {
                        _showLogoutDialog();
                      },
                    ),

                    const Spacer(),

                    // Version et copyright
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            'FasoDocs v1.0.0',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '© 2025 FasoDocs. Tous droits réservés.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  label: 'Accueil',
                  isActive: false,
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                ),
                _buildNavItem(
                  icon: Icons.grid_view,
                  label: 'Catégorie',
                  isActive: false,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const CategoryScreen(),
                      ),
                    );
                  },
                ),
                _buildNavItem(
                  icon: Icons.warning_outlined,
                  label: 'Alerte',
                  isActive: false,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ReportProblemScreen()),
                    );
                  },
                ),
                _buildNavItem(
                  icon: Icons.settings_outlined,
                  label: 'Options',
                  isActive: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
    Color iconColor = Colors.black,
    Color titleColor = Colors.black,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive ? Colors.yellow.withOpacity(0.3) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.black : Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.black : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choisir la langue'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Français'),
                leading: Radio<String>(
                  value: 'Français',
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: const Text('English'),
                leading: Radio<String>(
                  value: 'English',
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Se déconnecter'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );
  }
}

// ÉCRAN: AIDE ET SUPPORT
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Aide et Support',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.help_outline,
                size: 80,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Text(
                'Centre d\'aide et support',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Pour toute assistance, veuillez contacter notre équipe de support.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========================================================================================
// ÉCRAN: NOTIFICATIONS - CENTRE DE NOTIFICATIONS
// ========================================================================================
// Cet écran affiche toutes les notifications importantes de l'application :
// - Mises à jour des procédures administratives
// - Nouveaux centres de services
// - Perturbations de services
// - Informations générales importantes
//
// Chaque notification contient :
// - Une icône colorée selon le type de notification
// - Un titre descriptif
// - Une description détaillée
// - Un timestamp (il y a X temps)
// - Un badge "Nouveau" pour les notifications récentes
// ========================================================================================
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  /// Construit l'interface utilisateur de l'écran des notifications
  /// Affiche une liste de cartes de notifications avec différentes priorités
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec logo FasoDocs et profil utilisateur
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Logo FasoDocs
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/FasoDocs1.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'FasoDocs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Profil utilisateur et notifications
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Stack(
                        children: [
                          const Icon(
                            Icons.notifications_outlined,
                            color: Colors.black,
                            size: 24,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                          size: 24,
                        ),
                        onSelected: (String value) {
                          if (value == 'history') {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const HistoryScreen()),
                            );
                          } else if (value == 'report') {
                            GlobalReportAccess.showReportDialog(context);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'history',
                            child: Row(
                              children: [
                                Icon(Icons.history, color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Historique'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'report',
                            child: Row(
                              children: [
                                Icon(Icons.report_problem, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Signaler un problème'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Titre de la page avec bouton retour
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.green,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Liste des notifications
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    // Notification 1: Mise à jour passeport
                    _buildNotificationCard(
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                      title: 'Mise à jour de la procédure de passport',
                      description: 'Le prix du passeport a été révisé à 50 000F CFA à partir du 15 Novembre 2025',
                      time: 'Il y a 2 heures',
                    ),

                    const SizedBox(height: 16),

                    // Notification 2: Nouveau centre
                    _buildNotificationCard(
                      icon: Icons.info,
                      iconColor: Colors.blue,
                      title: 'Nouveau centre pour les cartes biométriques',
                      description: 'Un nouveau centre de délivrance des carte biométrique est désormais ouvert à Kalaban Coro',
                      time: 'Il y a 1 jour',
                    ),

                    const SizedBox(height: 16),

                    // Notification 3: Perturbation service
                    _buildNotificationCard(
                      icon: Icons.warning,
                      iconColor: Colors.red,
                      title: 'Perturbation de service',
                      description: 'Le service de délivrance des permis de conduire sera temporairement indisponible jusqu\'au 30 Novembre 2025',
                      time: 'Il y a 3 jours',
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Indicateur de navigation en bas
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icône de notification
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              // Contenu principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Bas de la carte avec timestamp et tag
          Row(
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Nouveau',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ÉCRAN 6: IDENTITY SCREEN (sous-catégorie Identité et citoyenneté)
class IdentityScreen extends StatelessWidget {
  const IdentityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec logo FasoDocs et profil utilisateur
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Logo FasoDocs
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/FasoDocs1.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'FasoDocs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Profil utilisateur et notifications
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Stack(
                        children: [
                          const Icon(
                            Icons.notifications_outlined,
                            color: Colors.black,
                            size: 24,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const HistoryScreen()),
                          );
                        },
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Titre de la section avec bouton retour
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14B53A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Identité et citoyenneté',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Grille des sous-catégories
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    // Extrait d'acte de naissance
                    _buildIdentityCard(
                      icon: Icons.person_outline,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Extrait d\'acte de naissance',
                    ),
                    // Extrait d'acte de mariage
                    _buildIdentityCard(
                      icon: Icons.favorite_border,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Extrait d\'acte de mariage',
                    ),
                    // Demande de divorce
                    _buildIdentityCard(
                      icon: Icons.favorite_border,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Demande de divorce',
                    ),
                    // Acte de décès
                    _buildIdentityCard(
                      icon: Icons.close,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Acte de décès',
                    ),
                    // Certificat de nationalité
                    _buildIdentityCard(
                      icon: Icons.flag_outlined,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Certificat de nationalité',
                    ),
                    // Certificat de casier judiciaire
                    _buildIdentityCard(
                      icon: Icons.gavel,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Certificat de casier judiciaire',
                    ),
                    // Carte d'identité nationale
                    _buildIdentityCard(
                      icon: Icons.credit_card,
                      backgroundColor: const Color(0xFFF5F5F5),
                      iconColor: const Color(0xFF424242),
                      title: 'Carte d\'identité nationale',
                    ),
                    // Passeport malien
                    _buildIdentityCard(
                      icon: Icons.credit_card,
                      backgroundColor: const Color(0xFFF5F5F5),
                      iconColor: const Color(0xFF424242),
                      title: 'Passeport malien',
                    ),
                    // Nationalité (par voie de naturalisation, par mariage)
                    _buildIdentityCard(
                      icon: Icons.flag_circle_outlined,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Nationalité (par voie de naturalisation, par mariage)',
                    ),
                    // Carte d'électeur
                    _buildIdentityCard(
                      icon: Icons.how_to_vote_outlined,
                      backgroundColor: const Color(0xFFF5F5F5),
                      iconColor: const Color(0xFF424242),
                      title: 'Carte d\'électeur',
                    ),
                    // Fiche de résidence
                    _buildIdentityCard(
                      icon: Icons.home_outlined,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Fiche de résidence',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ResidenceScreen(),
                          ),
                        );
                      },
                    ),
                    // Inscription liste électorale
                    _buildIdentityCard(
                      icon: Icons.ballot_outlined,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Inscription liste électorale',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bouton flottant de support
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: const Icon(
          Icons.headset_mic,
          color: Colors.black,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildIdentityCard({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                size: 24,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ÉCRAN 7: CATEGORY SCREEN (page des catégories)
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec logo FasoDocs et profil utilisateur
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Logo FasoDocs
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/FasoDocs.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'FasoDocs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Profil utilisateur et notifications
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Stack(
                        children: [
                          const Icon(
                            Icons.notifications_outlined,
                            color: Colors.black,
                            size: 24,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const HistoryScreen()),
                          );
                        },
                        child: const Icon(
                          Icons.more_vert,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Titre de la section avec bouton retour
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14B53A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Catégories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Grille des catégories
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    // Identité et citoyenneté
                    _buildCategoryCard(
                      icon: Icons.perm_identity,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Identité et citoyenneté',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const IdentityScreen(),
                          ),
                        );
                      },
                    ),
                    // Création d'entreprise
                    _buildCategoryCard(
                      icon: Icons.business,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Création d\'entreprise',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const BusinessScreen(),
                          ),
                        );
                      },
                    ),
                    // Documents auto
                    _buildCategoryCard(
                      icon: Icons.directions_car,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Documents auto',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AutoScreen(),
                          ),
                        );
                      },
                    ),
                    // Services fonciers
                    _buildCategoryCard(
                      icon: Icons.home,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Services fonciers',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LandScreen(),
                          ),
                        );
                      },
                    ),
                    // Eau et électricité
                    _buildCategoryCard(
                      icon: Icons.flash_on,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Eau et électricité',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const UtilitiesScreen(),
                          ),
                        );
                      },
                    ),
                    // Justice
                    _buildCategoryCard(
                      icon: Icons.balance,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFF424242),
                      title: 'Justice',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const JusticeScreen(),
                          ),
                        );
                      },
                    ),
                    // Impôt et douane
                    _buildCategoryCard(
                      icon: Icons.account_balance,
                      backgroundColor: const Color(0xFFE3F2FD),
                      iconColor: const Color(0xFF2196F3),
                      title: 'Impôt et douane',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TaxScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Bouton flottant de support
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: const Icon(
          Icons.headset_mic,
          color: Colors.black,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                size: 30,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}