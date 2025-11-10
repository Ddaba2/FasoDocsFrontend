import 'package:flutter/material.dart';

class ConditionsUtilisationScreen extends StatelessWidget {
  const ConditionsUtilisationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Conditions d\'utilisation',
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo en haut au milieu
            Center(
              child: Image.asset(
                'assets/images/FasoDocs.png',
                height: 80,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.account_balance,
                    size: 80,
                    color: Color(0xFF14B53A),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 30),

            // Introduction
            _buildSectionTitle('Introduction', textColor),
            const SizedBox(height: 10),
            _buildParagraph(
              'Bienvenue sur FasoDocs, votre plateforme de gestion d\'élevage de pigeons. Cette politique d\'utilisation décrit comment nous collectons, utilisons et protégeons vos informations personnelles lorsque vous utilisez notre service.',
              textColor,
            ),

            const SizedBox(height: 20),

            // Collecte d'Informations
            _buildSectionTitle('Collecte d\'Informations', textColor),
            const SizedBox(height: 10),
            _buildParagraph(
              'Informations que nous collectons :',
              textColor,
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Informations de compte : numéro de téléphone, email, photo.', textColor),
            _buildBulletPoint('Données d\'utilisation : statistiques, historiques', textColor),

            const SizedBox(height: 20),

            // Utilisation des Données
            _buildSectionTitle('Utilisation des Données', textColor),
            const SizedBox(height: 10),
            _buildParagraph(
              'Nous utilisons vos données pour :',
              textColor,
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Fournir et maintenir le service FasoDocs', textColor),
            _buildBulletPoint('Personnalisez votre expérience utilisateur', textColor),
            _buildBulletPoint('Améliorer nos services et fonctionnalités', textColor),
            _buildBulletPoint('Communiquer avec vous concernant votre compte', textColor),

            const SizedBox(height: 20),

            // Protection des données
            _buildSectionTitle('Protection des données', textColor),
            const SizedBox(height: 10),
            _buildParagraph(
              'Conformément à la Loi malienne sur la protection des données personnelles du 21 mai 2013, nous mettons en place des mesures de sécurité appropriées pour protéger vos informations :',
              textColor,
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Chiffrement des données sensibles', textColor),
            _buildBulletPoint('Accès restreint aux données personnelles', textColor),
            _buildBulletPoint('Surveillance continue de la sécurité', textColor),
            _buildBulletPoint('Sauvegardes régulières et sécurisées', textColor),

            const SizedBox(height: 20),

            // Conformité Loi Malienne
            _buildSectionTitle('Conformité Loi Malienne', textColor),
            const SizedBox(height: 10),
            _buildParagraph(
              'FasoDocs respecte scrupuleusement la Loi malienne sur la protection des données personnelles du 21 mai 2013 :',
              textColor,
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Article 3 : Consentement libre et éclairé pour la collecte des données', textColor),
            _buildBulletPoint('Article 4 : Finalité légitime et déterminée de la collecte', textColor),
            _buildBulletPoint('Article 5 : Proportionnalité et adéquation des données collectées', textColor),
            _buildBulletPoint('Article 6 : Conservation limitée dans le temps', textColor),
            _buildBulletPoint('Article 7 : Sécurité et confidentialité des données', textColor),

            const SizedBox(height: 20),

            // Partage des Données
            _buildSectionTitle('Partage des Données', textColor),
            const SizedBox(height: 10),
            _buildParagraph(
              'Nous ne vendons, n\'échangeons ni ne louons vos informations personnelles à des tiers. Vos données peuvent être partagées uniquement dans les cas suivants :',
              textColor,
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Avec votre consentement explicite', textColor),
            _buildBulletPoint('Pour respecter les obligations légales', textColor),
            _buildBulletPoint('Avec nos prestataires de services de confiance', textColor),

            const SizedBox(height: 20),

            // Vos Droits
            _buildSectionTitle('Vos Droits', textColor),
            const SizedBox(height: 10),
            _buildParagraph(
              'Vous avez le droit de :',
              textColor,
            ),
            const SizedBox(height: 8),
            _buildBulletPoint('Accéder à vos données personnelles', textColor),
            _buildBulletPoint('Corriger ou mettre à jour vos informations', textColor),
            _buildBulletPoint('Exiger la suppression de vos données', textColor),
            _buildBulletPoint('Retirez votre consentement à tout moment', textColor),

            const SizedBox(height: 20),

            // Contact
            _buildSectionTitle('Contact', textColor),
            const SizedBox(height: 10),
            _buildParagraph(
              'Si vous avez des questions concernant cette politique d\'utilisation ou souhaitez exercer vos droits, contactez-nous :',
              textColor,
            ),
            const SizedBox(height: 8),
            _buildContactInfo('Courriel', 'contactpigeonfarm@gmail.com', textColor),
            _buildContactInfo('Adresse', 'FasoDocs, ACI 2000, Mali', textColor),
            _buildContactInfo('Téléphone', '(+223) 83 78 40 97 / 74 32 38 74', textColor),

            const SizedBox(height: 30),

            // Note finale
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF14B53A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF14B53A).withOpacity(0.3),
                ),
              ),
              child: Text(
                'Cette politique d\'utilisation est conforme à la Loi malienne sur la protection des données personnelles du 21 mai 2013 et respecte les droits des citoyens maliens.',
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  Widget _buildParagraph(String text, Color textColor) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        color: textColor.withOpacity(0.9),
        height: 1.6,
      ),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildBulletPoint(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 15,
              color: const Color(0xFF14B53A),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: textColor.withOpacity(0.85),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label : ',
            style: TextStyle(
              fontSize: 15,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                color: textColor.withOpacity(0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

