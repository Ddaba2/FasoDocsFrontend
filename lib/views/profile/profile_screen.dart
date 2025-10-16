// ÉCRAN: PROFIL
import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import '../history/history_screen.dart';
import '../../controllers/report_controller.dart';

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
                            ReportController.showReportDialog(context);
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