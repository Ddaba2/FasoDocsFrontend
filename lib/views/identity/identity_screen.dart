// ÉCRAN 6: IDENTITY SCREEN (sous-catégorie Identité et citoyenneté)
import 'package:flutter/material.dart';
import '../history/history_screen.dart';
// import '../residence_screen.dart'; // TODO: Create ResidenceScreen

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
                        'assets/images/FasoDocs 1.png',
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
                        // TODO: Implement ResidenceScreen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fonctionnalité en cours de développement')),
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