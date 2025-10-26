// Fichier : communiquee_global/com_global.dart

import 'package:flutter/material.dart';
import '../../locale/locale_helper.dart';

// Définition de l'écran principal
class ComGlobalScreen extends StatelessWidget {
  const ComGlobalScreen({super.key});

  // Couleur principale fixe de l'application
  static const Color primaryColor = Color(0xFF14B53A);

  // Chemin de l'asset pour l'image de profil (à remplacer si nécessaire)
  static const String _profileAssetPath = 'assets/images/profile_pic.png';
  // Chemin de l'asset pour l'illustration (à remplacer si nécessaire)
  static const String _illustrationAssetPath = 'assets/images/justice_scale.png';

  @override
  Widget build(BuildContext context) {
    // 1. Récupération des couleurs du thème
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final Color iconColor = Theme.of(context).iconTheme.color!;
    final Color cardColor = Theme.of(context).cardColor;
    final Color shadowColor = isDarkMode ? Colors.black.withOpacity(0.5) : Colors.grey.withOpacity(0.1);

    // Correction de la bordure : Utilisation d'un fallback non-nullable
    final Color borderColor = isDarkMode ? (Colors.grey[700] ?? const Color(0xFF333333)) : Colors.black12;

    return Scaffold(
      backgroundColor: backgroundColor, // FOND: Couleur dynamique du thème

      // 1. AppBar personnalisée
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title:  Text(

          LocaleHelper.getText(context, 'allArticleLaws'),

          style: TextStyle(

            fontSize: 20,

            fontWeight: FontWeight.bold,

            color: textColor,

          ),

        ),
      ),

      // BOUTON FLOTTANT IDENTIQUE À LA PAGE D'ACCUEIL
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 75, right: 0),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: cardColor,
            shape: BoxShape.circle,
            border: Border.all(color: iconColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(isDarkMode ? 0.8 : 0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.headset_mic_outlined,
            color: iconColor,
            size: 24,
          ),
        ),
      ),

      // Contenu du corps de l'écran
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // 3. Bouton "Tout voir"
            _buildToutVoirSection(),

            const SizedBox(height: 15),

            // 2. Première carte d'information
            _buildInfoCard(
              cardColor,
              shadowColor,
              borderColor,
              textColor,
              'Articles 74 à 79 de la loi n°06-024 du 28 juin 2006 régissant l\'État Civil (pour l\'Extrait d\'acte de naissance) et Articles 63, 64, 65 de la loi n°06-024 (pour la copie).',
            ),

            const SizedBox(height: 15),

            // 2. Deuxième carte d'information
            _buildInfoCard(
              cardColor,
              shadowColor,
              borderColor,
              textColor,
              'Le Décret n°2022-0639/ PT-RM du 03 novembre 2022 du Mali a institué et réglementé la Carte Nationale d\'Identité biométrique sécurisée (CNIbs).',
            ),

            const SizedBox(height: 50),

            // 4. Illustration (Balance de la justice)
            Center(
              child: Image.asset(
                _illustrationAssetPath,
                width: screenWidth * 0.5,
                height: screenWidth * 0.5,
                // Le widget est remplacé par une icône si l'image n'est pas trouvée
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.balance,
                    size: 150,
                    color: isDarkMode ? (Colors.grey[600] ?? Colors.white70) : (Colors.grey[400] ?? Colors.black54),
                  );
                },
              ),
            ),

            const SizedBox(height: 100), // Espace supplémentaire
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // WIDGETS DE COMPOSITION
  // ===========================================================================

  // 1. Fonction pour construire l'AppBar personnalisée
  PreferredSizeWidget _buildCustomAppBar(
      BuildContext context,
      double screenWidth,
      Color textColor,
      Color iconColor,
      ) {
    // Nécessaire pour forcer le fond de l'AppBar en mode sombre s'il est transparent
    final Color appBarBgColor = Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor;

    return AppBar(
      backgroundColor: appBarBgColor, // FOND: Couleur dynamique du thème
      elevation: 0,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: iconColor), // Couleur des icônes de l'AppBar

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Partie gauche (Logo et Titre)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                // Logo avec les couleurs du Mali (Vert-Jaune-Rouge)
                _buildMaliLogo(screenWidth * 0.08),
                const SizedBox(width: 8),
                Text(
                  'FacoDocs',
                  style: TextStyle(
                    color: textColor, // TEXTE: Couleur dynamique du thème
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Partie droite (Photo de profil, Notification, Menu)
          Row(
            children: [
              // Photo de profil
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // BORDURE: Couleur dynamique
                  border: Border.all(color: iconColor.withOpacity(0.3)),
                ),
                child: ClipOval(
                  child: Image.asset(
                    _profileAssetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.person, color: iconColor, size: 20); // Placeholder
                    },
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Icône de notification
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_none, color: iconColor), // ICÔNE: Couleur dynamique
                    onPressed: () {},
                  ),
                  // Indicateur de notification (petit cercle rouge)
                  Positioned(
                    right: 8,
                    top: 8,
                    // CORRECTION APPORTÉE ICI
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        // CORRECTION : Utilisation du constructeur constant BorderRadius.all
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: const Text(
                        '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),

              // Icône de menu
              IconButton(
                icon: Icon(Icons.more_vert, color: iconColor), // ICÔNE: Couleur dynamique
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget pour le Logo du Mali (Vert-Jaune-Rouge)
  Widget _buildMaliLogo(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Row(
          children: [
            // Vert
            Container(width: size / 3, color: primaryColor), // Reste Vert
            // Jaune
            Container(width: size / 3, color: const Color(0xFFFFD700)), // Reste Jaune
            // Rouge
            Container(width: size / 3, color: const Color(0xFFDC143C)), // Reste Rouge
          ],
        ),
      ),
    );
  }

  // 3. Fonction pour construire la section "Tout voir"
  Widget _buildToutVoirSection() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Action "Tout voir"
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tout voir',
              style: TextStyle(
                color: primaryColor, // Reste Vert
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: primaryColor, // Reste Vert
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  // 2. Fonction pour construire les cartes d'information
  Widget _buildInfoCard(
      Color cardColor,
      Color shadowColor,
      Color borderColor,
      Color textColor,
      String text,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor, // FOND: Couleur dynamique de carte
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor, width: 1.0), // BORDURE: Couleur dynamique
        boxShadow: [
          BoxShadow(
            color: shadowColor, // OMBRE: Couleur dynamique
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.5,
          color: textColor, // TEXTE: Couleur dynamique
          height: 1.4,
        ),
      ),
    );
  }
}