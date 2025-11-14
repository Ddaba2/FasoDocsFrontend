// ÉCRAN: PROFIL
import 'package:flutter/material.dart';
import 'edit_profile_screen.dart'; // Import de l'écran d'édition
import '../history/history_screen.dart';
import '../../controllers/report_controller.dart'; // Supposé existant
import '../../core/services/auth_service.dart';
import '../../models/api_models.dart';
import '../../core/widgets/profile_avatar.dart';

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
  
  // Service d'authentification
  final AuthService _authService = authService;

  // ====================================================================
  // DONNÉES UTILISATEUR CHARGÉES DEPUIS LE BACKEND
  // ====================================================================
  User? _user;
  bool _isLoading = true;
  String? _errorMessage;

  String userName = 'Chargement...';
  String userEmail = '';
  String userPhone = '';
  String userAddress = '';
  String userBirthDate = '';
  String userGender = '';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // ====================================================================
  // CHARGEMENT DU PROFIL DEPUIS LE BACKEND
  // ====================================================================
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.getProfil();
      
      setState(() {
        _user = user;
        userName = user.nomComplet;
        userEmail = user.email;
        userPhone = user.telephone;
        userAddress = user.adresse ?? '';
        userBirthDate = user.dateNaissance ?? '';
        userGender = user.genre ?? '';
        _isLoading = false;
      });
      
      print('✅ Profil utilisateur chargé: ${user.nomComplet}');
    } catch (e) {
      print('❌ Erreur chargement profil: $e');
      setState(() {
        _errorMessage = 'Erreur de chargement: $e';
        _isLoading = false;
      });
    }
  }

  // ====================================================================
  // MÉTHODE DE NAVIGATION ET MISE À JOUR
  // ====================================================================
  void _navigateToEditProfile(BuildContext context) async {
    // Naviguer vers l'écran de modification avec les données actuelles
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(
          currentName: userName,
          currentEmail: userEmail,
          currentPhone: userPhone,
        ),
      ),
    );

    // Vérifier si le résultat est un Map (données mises à jour)
    if (result != null && result is Map<String, String>) {
      try {
        // Appeler l'API pour mettre à jour le profil
        await _authService.updateProfil({
          'nomComplet': result['name'] ?? userName,
          'email': result['email'] ?? userEmail,
          'telephone': result['phone'] ?? userPhone,
        });
        
        // Recharger le profil depuis le backend
        await _loadUserProfile();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil mis à jour avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        print('❌ Erreur mise à jour profil: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de la mise à jour: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey,
        leading: IconButton(onPressed: (){
          Navigator.of(context).pop();

        },
            icon: const Icon(Icons.chevron_left, color: Colors.white,)),
        title:  const Text(
          'Profil',
          style: TextStyle(

            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final horizontalPadding = screenWidth * 0.05;
            final verticalPadding = screenHeight * 0.02;

            return Column(
              children: [

                // Contenu principal
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: _isLoading
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: primaryColor),
                                SizedBox(height: screenHeight * 0.02),
                                Text(
                                  'Chargement du profil...',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _errorMessage != null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: screenWidth * 0.2,
                                      color: Colors.red,
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    Text(
                                      _errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: textColor,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.03),
                                    ElevatedButton(
                                      onPressed: _loadUserProfile,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.08,
                                          vertical: screenHeight * 0.015,
                                        ),
                                      ),
                                      child: Text(
                                        'Réessayer',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                      children: [
                        SizedBox(height: screenHeight * 0.04),

                        // Photo de profil avec ProfileAvatar
                        ProfileAvatar(
                          photoBase64: _user?.photo,
                          radius: screenWidth * 0.15,
                          backgroundColor: isDarkMode ? Colors.grey.shade700 : Colors.grey[300],
                          defaultIcon: Icons.person,
                          defaultIconSize: screenWidth * 0.15,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // Nom de l'utilisateur (Dynamique)
                        Text(
                          userName, // <-- Utilisez la variable d'état mise à jour
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.01),

                        // Email (Dynamique)
                        Text(
                          userEmail, // <-- Utilisez la variable d'état mise à jour
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: textColor,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),
                        // Cartes d'informations (Dynamiques)
                        _buildProfileCard(
                          context, screenWidth, screenHeight, Icons.edit,
                          'Modifier Profile', 'mettre à jour votre profil', primaryColor, cardColor, textColor,
                              () {
                                _navigateToEditProfile(context); // fonction à exécuter quand on clique
                          },
                        ),
                        // Cartes d'informations (Dynamiques)
                        _buildProfileCard(
                          context, screenWidth, screenHeight, Icons.phone,
                          'Téléphone', userPhone, primaryColor, cardColor, textColor, // <-- Utilisé la variable d'état
                              () {
                            // fonction à exécuter quand on clique
                          },
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        _buildProfileCard(
                          context, screenWidth, screenHeight, Icons.location_on,
                          'Adresse', userAddress, primaryColor, cardColor, textColor,
                              () {
                            // fonction à exécuter quand on clique
                          },
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        _buildProfileCard(
                          context, screenWidth, screenHeight, Icons.calendar_today,
                          'Date de naissance', userBirthDate, primaryColor, cardColor, textColor,
                              () {
                            // fonction à exécuter quand on clique
                          },
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        _buildProfileCard(
                          context, screenWidth, screenHeight, Icons.person,
                          'Genre', userGender, primaryColor, cardColor, textColor,
                              () {
                            // fonction à exécuter quand on clique
                          },
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

  // Fonction pour construire une carte de profil avec onTap
  Widget _buildProfileCard(
      BuildContext context,
      double screenWidth,
      double screenHeight,
      IconData icon,
      String label,
      String value,
      Color primaryColor,
      Color cardColor,
      Color textColor,
      VoidCallback onTap, // callback à exécuter quand on clique
      ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap, // rend toute la carte cliquable
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.04),
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: isDarkMode ? Border.all(color: Colors.grey.shade700, width: 1) : null,
          boxShadow: isDarkMode ? null : [
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
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            // Icône de navigation (Chevron droit)
            GestureDetector(
              onTap: onTap, // fait la même action que la carte
              child: Icon(
                Icons.chevron_right,
                color: isDarkMode ? Colors.grey.shade500 : Colors.grey[600],
                size: screenWidth * 0.08,
              ),
            ),
          ],
        ),
      ),
    );
  }

}