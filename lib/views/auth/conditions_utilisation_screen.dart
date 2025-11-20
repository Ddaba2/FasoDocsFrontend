import 'package:flutter/material.dart';

class ConditionsUtilisationScreen extends StatelessWidget {
  const ConditionsUtilisationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF14B53A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Conditions d\'utilisation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header avec gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF4D4E4C),
                    const Color(0xFFA6D8B3).withOpacity(0.1),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/FasoDocs.png',
                      height: 60,
                      width: 60,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.account_balance,
                          size: 60,
                          color: Color(0xFF14B53A),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Politique d\'Utilisation',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Dernière mise à jour : 13 Nov 2024',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Introduction Card
                  _buildModernSection(
                    context,
                    icon: Icons.info_outline,
                    iconColor: Colors.blue,
                    title: 'Introduction',
                    content:
                        'Bienvenue sur FasoDocs, une application mobile intuitive qui centralise et simplifie l\'accès aux informations et services administratifs au Mali. Cette politique d\'utilisation décrit comment nous collectons, utilisons et protégeons vos informations personnelles lorsque vous utilisez notre service.',
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                    cardColor: cardColor,
                  ),

                  const SizedBox(height: 16),

                  // Collecte d'Informations Card
                  _buildModernSection(
                    context,
                    icon: Icons.inventory_2_outlined,
                    iconColor: Colors.orange,
                    title: 'Collecte d\'Informations',
                    content: 'Informations que nous collectons :',
                    bullets: [
                      'Informations de compte : numéro de téléphone, email, photo',
                      'Données d\'utilisation : statistiques, historiques de navigation',
                      'Localisation géographique (avec votre permission)',
                    ],
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                    cardColor: cardColor,
                  ),

                  const SizedBox(height: 16),

                  // Utilisation des Données Card
                  _buildModernSection(
                    context,
                    icon: Icons.trending_up,
                    iconColor: Colors.green,
                    title: 'Utilisation des Données',
                    content: 'Nous utilisons vos données pour :',
                    bullets: [
                      'Fournir et maintenir le service FasoDocs',
                      'Personnaliser votre expérience utilisateur',
                      'Améliorer nos services et fonctionnalités',
                      'Communiquer avec vous concernant votre compte',
                      'Vous tenir informé des nouvelles procédures',
                    ],
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                    cardColor: cardColor,
                  ),

                  const SizedBox(height: 16),

                  // Protection des données Card
                  _buildModernSection(
                    context,
                    icon: Icons.security,
                    iconColor: Colors.red,
                    title: 'Protection des Données',
                    content:
                        'Conformément à la Loi malienne sur la protection des données personnelles du 21 mai 2013, nous mettons en place des mesures de sécurité appropriées :',
                    bullets: [
                      'Chiffrement des données sensibles',
                      'Accès restreint aux données personnelles',
                      'Surveillance continue de la sécurité',
                      'Sauvegardes régulières et sécurisées',
                      'Audits de sécurité périodiques',
                    ],
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                    cardColor: cardColor,
                  ),

                  const SizedBox(height: 16),

                  // Conformité Loi Malienne - Highlight Card
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF14B53A).withOpacity(0.1),
                          const Color(0xFF14B53A).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF14B53A).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF14B53A),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF14B53A).withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.gavel,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Conformité Légale',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Loi malienne n°2013-015',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF14B53A),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'FasoDocs respecte scrupuleusement la Loi malienne sur la protection des données personnelles du 21 mai 2013 :',
                          style: TextStyle(
                            fontSize: 15,
                            color: textColor.withOpacity(0.9),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...[
                          'Article 3 : Consentement libre et éclairé',
                          'Article 4 : Finalité légitime et déterminée',
                          'Article 5 : Proportionnalité des données',
                          'Article 6 : Conservation limitée dans le temps',
                          'Article 7 : Sécurité et confidentialité',
                        ].map((article) => _buildLegalArticle(article, textColor)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Partage des Données Card
                  _buildModernSection(
                    context,
                    icon: Icons.share_outlined,
                    iconColor: Colors.purple,
                    title: 'Partage des Données',
                    content:
                        'Nous ne vendons, n\'échangeons ni ne louons vos informations personnelles à des tiers. Vos données peuvent être partagées uniquement dans les cas suivants :',
                    bullets: [
                      'Avec votre consentement explicite',
                      'Pour respecter les obligations légales',
                      'Avec nos prestataires de services de confiance',
                      'En cas de fusion ou acquisition (avec notification préalable)',
                    ],
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                    cardColor: cardColor,
                  ),

                  const SizedBox(height: 16),

                  // Vos Droits Card
                  _buildModernSection(
                    context,
                    icon: Icons.account_circle_outlined,
                    iconColor: Colors.teal,
                    title: 'Vos Droits',
                    content: 'Vous avez le droit de :',
                    bullets: [
                      'Accéder à vos données personnelles',
                      'Corriger ou mettre à jour vos informations',
                      'Exiger la suppression de vos données',
                      'Retirer votre consentement à tout moment',
                      'Obtenir une copie de vos données (portabilité)',
                    ],
                    isDarkMode: isDarkMode,
                    textColor: textColor,
                    cardColor: cardColor,
                  ),

                  const SizedBox(height: 16),

                  // Contact Card - Modern Design
                  Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? cardColor : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.contact_support,
                                color: Colors.blue,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Nous Contacter',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Des questions ? Contactez-nous :',
                          style: TextStyle(
                            fontSize: 15,
                            color: textColor.withOpacity(0.7),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildContactCard(
                          icon: Icons.email,
                          label: 'Email',
                          value: 'contactfasodocs@gmail.com',
                          color: Colors.red,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 8),
                        _buildContactCard(
                          icon: Icons.location_on,
                          label: 'Adresse',
                          value: 'ACI 2000, Bamako, Mali',
                          color: Colors.green,
                          isDarkMode: isDarkMode,
                        ),
                        const SizedBox(height: 8),
                        _buildContactCard(
                          icon: Icons.phone,
                          label: 'Téléphone',
                          value: '(+223) 83 78 40 97 / 74 32 38 74',
                          color: Colors.blue,
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer Badge
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF14B53A).withOpacity(0.1),
                          const Color(0xFF14B53A).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF14B53A).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user,
                          color: Color(0xFF14B53A),
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Cette politique est conforme à la Loi malienne sur la protection des données personnelles (21 mai 2013) et respecte les droits des citoyens maliens.',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSection(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
    List<String>? bullets,
    required bool isDarkMode,
    required Color textColor,
    required Color cardColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: textColor.withOpacity(0.85),
              height: 1.6,
            ),
          ),
          if (bullets != null && bullets.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...bullets.map((bullet) => Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: iconColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          bullet,
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildLegalArticle(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF14B53A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.85),
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
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

