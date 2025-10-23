// Fichier: home/certificat_residence_screen.dart

import 'package:flutter/material.dart';
import 'centre_screen.dart';

class CertificatResidenceScreen extends StatelessWidget {
  const CertificatResidenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final Color cardColor = Theme.of(context).cardColor;
    final Color borderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Certificat de résidence'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre principal avec icône
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Color(0xFF4CAF50),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Demande de certificat de residence',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Tableau d'informations HORIZONTAL avec toutes les icônes sur une seule ligne
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _InfoItemWithIcon(
                    icon: Icons.list_alt,
                    title: 'Etapes',
                    value: '4',
                    iconColor: const Color(0xFF2196F3),
                  ),
                  _InfoItemWithIcon(
                    icon: Icons.money,
                    title: 'Montant',
                    value: 'Gratuit',
                    iconColor: const Color(0xFF4CAF50),
                    isBold: true,
                  ),
                  _InfoItemWithIcon(
                    icon: Icons.description,
                    title: 'Documents',
                    value: '4',
                    iconColor: const Color(0xFFFF9800),
                  ),
                  _InfoItemWithIcon(
                    icon: Icons.gavel,
                    title: 'Loi(s)',
                    value: '1',
                    iconColor: const Color(0xFF9C27B0),
                  ),
                  _InfoItemWithIcon(
                    icon: Icons.location_on,
                    title: 'Centres',
                    value: '2',
                    iconColor: const Color(0xFFF44336),
                    onTap: () {
                      // Navigation vers la page des centres
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CentresScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Section Étapes à suivre
            Text(
              'Étapes à suivre',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 20),

            // Étape 1
            _buildStep(
              number: 1,
              title: 'Visite au commissariat',
              description: 'Présentez-vous au commissariat de police de votre quartier',
              cardColor: cardColor,
              borderColor: borderColor,
              textColor: textColor,
            ),

            const SizedBox(height: 16),

            // Étape 2
            _buildStep(
              number: 2,
              title: 'Remplir le formulaire',
              description: 'Remplissez le formulaire de demande de certificat de résidence',
              cardColor: cardColor,
              borderColor: borderColor,
              textColor: textColor,
            ),

            const SizedBox(height: 16),

            // Étape 3
            _buildStep(
              number: 3,
              title: 'Vérification de domicile',
              description: 'Un agent pourrait venir vérifier votre lieu de résidence',
              cardColor: cardColor,
              borderColor: borderColor,
              textColor: textColor,
            ),

            const SizedBox(height: 16),

            // Étape 4
            _buildStep(
              number: 4,
              title: 'Paiement et réception',
              description: 'Payez les frais et récupérez votre certificat (généralement le même jour ou le lendemain)',
              cardColor: cardColor,
              borderColor: borderColor,
              textColor: textColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required int number,
    required String title,
    required String description,
    required Color cardColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF14B53A),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor.withOpacity(0.8),
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

class _InfoItemWithIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;
  final bool isBold;
  final VoidCallback? onTap;

  const _InfoItemWithIcon({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    this.isBold = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icône
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(height: 6),
          // Titre
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: textColor.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          // Valeur
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}