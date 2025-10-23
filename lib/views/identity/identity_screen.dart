// ÉCRAN 6: IDENTITY SCREEN (sous-catégorie Identité et citoyenneté)
import 'package:flutter/material.dart';
import '../history/history_screen.dart';
// import '../residence_screen.dart'; // TODO: Create ResidenceScreen

class IdentityScreen extends StatelessWidget {
  const IdentityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardColor = isDarkMode ? Colors.grey.shade900 : Colors.white;
    final borderColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.chevron_left,
            color: Colors.green,
          ),
        ),
        title: Text(
          'Identité et citoyenneté',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header avec logo FasoDocs et profil utilisateur

            

            
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
                      context: context,
                      icon: Icons.person_outline,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Extrait d\'acte de naissance',
                    ),
                    // Extrait d'acte de mariage
                    _buildIdentityCard(
                      context: context,
                      icon: Icons.favorite_border,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Extrait d\'acte de mariage',
                    ),
                    // Demande de divorce
                    _buildIdentityCard(
                      context: context,
                      icon: Icons.favorite_border,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Demande de divorce',
                    ),
                    // Acte de décès
                    _buildIdentityCard(
                      context: context,
                      icon: Icons.close,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Acte de décès',
                    ),
                    // Certificat de nationalité
                    _buildIdentityCard(
                      context: context,
                      icon: Icons.flag_outlined,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Certificat de nationalité',
                    ),
                    // Certificat de casier judiciaire
                    _buildIdentityCard(
                      context: context,
                      icon: Icons.gavel,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Certificat de casier judiciaire',
                    ),
                    // Carte d'identité nationale
                    _buildIdentityCard(
                      context: context,
                      icon: Icons.credit_card,
                      backgroundColor: const Color(0xFFF5F5F5),
                      iconColor: const Color(0xFF424242),
                      title: 'Carte d\'identité nationale',
                    ),
                    // Passeport malien
                    _buildIdentityCard(
                      context: context,
                      icon: Icons.credit_card,
                      backgroundColor: const Color(0xFFF5F5F5),
                      iconColor: const Color(0xFF424242),
                      title: 'Passeport malien',
                    ),
                    // Nationalité (par voie de naturalisation, par mariage)
                    _buildIdentityCard(
                      context: context,
                      icon: Icons.flag_circle_outlined,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Nationalité (par voie de naturalisation, par mariage)',
                    ),
                    // Carte d'électeur
                    _buildIdentityCard(
                      context: context,
                      icon: Icons.how_to_vote_outlined,
                      backgroundColor: const Color(0xFFF5F5F5),
                      iconColor: const Color(0xFF424242),
                      title: 'Carte d\'électeur',
                    ),
                    // Fiche de résidence
                    _buildIdentityCard(
                      context: context,
                      icon: Icons.home_outlined,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Fiche de résidence',
                      onTap: () {
                        // TODO: Implement ResidenceScreen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fonctionnalité en cours de développement')),
                        );
                      },
                    ),
                    // Inscription liste électorale
                    _buildIdentityCard(
                      context: context,
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
          color: cardColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Icon(
          Icons.headset_mic,
          color: textColor,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildIdentityCard({
    required BuildContext context,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String title,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardColor = isDarkMode ? Colors.grey.shade900 : Colors.white;
    final borderColor = isDarkMode ? Colors.grey.shade800 : Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: isDarkMode ? [] : [
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
                color: isDarkMode ? backgroundColor.withOpacity(0.2) : backgroundColor,
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
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}