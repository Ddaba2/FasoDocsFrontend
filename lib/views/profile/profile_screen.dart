// ÉCRAN: PROFIL
import 'package:flutter/material.dart';
import 'edit_profile_screen.dart'; // Import de l'écran d'édition
import '../history/history_screen.dart';
import '../../controllers/report_controller.dart'; // Supposé existant

// ====================================================================
// CONVERSION EN STATEFULWIDGET pour gérer la mise à jour
// ====================================================================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Définition de la couleur principale (le vert)
  final Color primaryColor = const Color(0xFF14B53A);

  // ====================================================================
  // SIMULATION DES DONNÉES UTILISATEUR
  // ====================================================================
  // Ces données vont être mises à jour via setState
  String userName = 'Daba Diarra';
  String userEmail = 'daba.diarra@gmail.com';
  String userPhone = '+223 76 00 00 00';
  String userAddress = 'Hamdallaye ACI 2000';
  String userBirthDate = '01/01/1990';
  String userGender = 'Femme';


  // ====================================================================
  // MÉTHODE DE NAVIGATION ET MISE À JOUR
  // ====================================================================
  void _navigateToEditProfile(BuildContext context) async {
    // Naviguer vers l'écran de modification et attendre un résultat (Map des données mises à jour)
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );

    // Vérifier si le résultat est un Map (données mises à jour)
    if (result != null && result is Map<String, String>) {
      setState(() {
        // Mettre à jour les variables d'état avec les nouvelles données renvoyées
        userName = result['name'] ?? userName;
        userEmail = result['email'] ?? userEmail;
        userPhone = result['phone'] ?? userPhone;

        // Note: Les autres champs (adresse, date, genre) ne sont pas modifiés
        // par l'écran d'édition, donc ils conservent leur valeur actuelle.

        print('Profil mis à jour avec les nouvelles données. Reconstruction de ProfileScreen.');
      });
    }
  }

  // ====================================================================
  // Fonction pour afficher la boîte de dialogue de déconnexion
  // ====================================================================
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr(e) de vouloir vous déconnecter?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Déconnexion', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(dialogContext).pop();

                // TODO: Logique de déconnexion réelle
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Déconnexion réussie.')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // ====================================================================
  // MÉTHODE BUILD PRINCIPALE
  // ====================================================================
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
                // Header avec bouton fermeture (X), titre et menu
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Bouton de fermeture (X)
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                          child: Icon(
                            Icons.close, // Icône de fermeture (X)
                            color: Colors.black,
                            size: screenWidth * 0.06,
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
                      // Menu trois points avec OPTION DÉCONNEXION SEULEMENT
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.grey[600],
                          size: screenWidth * 0.06,
                        ),
                        onSelected: (String value) {
                          if (value == 'logout') {
                            _showLogoutDialog(context);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem<String>(
                            value: 'logout',
                            child: Row(
                              children: [
                                Icon(Icons.logout, color: primaryColor),
                                SizedBox(width: 8),
                                const Text('Déconnexion'),
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

                        // Nom de l'utilisateur (Dynamique)
                        Text(
                          userName, // <-- Utilisez la variable d'état mise à jour
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        // Email (Dynamique)
                        Text(
                          userEmail, // <-- Utilisez la variable d'état mise à jour
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // Cartes d'informations (Dynamiques)
                        _buildProfileCard(
                          context, screenWidth, screenHeight, Icons.phone,
                          'Téléphone', userPhone, primaryColor, // <-- Utilisé la variable d'état
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        _buildProfileCard(
                          context, screenWidth, screenHeight, Icons.location_on,
                          'Adresse', userAddress, primaryColor,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        _buildProfileCard(
                          context, screenWidth, screenHeight, Icons.calendar_today,
                          'Date de naissance', userBirthDate, primaryColor,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        _buildProfileCard(
                          context, screenWidth, screenHeight, Icons.person,
                          'Genre', userGender, primaryColor,
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

  // Fonction pour construire une carte de profil
  Widget _buildProfileCard(
      BuildContext context,
      double screenWidth,
      double screenHeight,
      IconData icon,
      String label,
      String value,
      Color primaryColor,
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
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: primaryColor,
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
          // Icône de navigation vers l'écran d'édition (Chevron droit)
          GestureDetector(
            onTap: () => _navigateToEditProfile(context), // Appelle la méthode de navigation/mise à jour
            child: Icon(
              Icons.chevron_right,
              color: Colors.grey[600],
              size: screenWidth * 0.08,
            ),
          ),
        ],
      ),
    );
  }
}