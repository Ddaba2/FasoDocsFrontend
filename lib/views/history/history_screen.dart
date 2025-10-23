// ÉCRAN: HISTORIQUE
import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.chevron_left,
            color: Colors.green,

          ),),
        title:  Text(

          'Historique',

          style: TextStyle(

            fontSize: 20,

            fontWeight: FontWeight.bold,



          ),

        ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        
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