import 'package:flutter/material.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final Color cardColor = Theme.of(context).cardColor;
    final Color borderColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Documents requis'),
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
            // Titre principal
            Text(
              'Pour le certificat de résidence',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              '4 documents nécessaires',
              style: TextStyle(
                fontSize: 16,
                color: textColor.withOpacity(0.7),
              ),
            ),

            const SizedBox(height: 30),

            // Liste des documents avec cases à cocher
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildDocumentItem(
                    title: 'Pièce d\'identité valide',
                    description: 'Carte d\'identité nationale ou passeport en cours de validité',
                    isRequired: true,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 16),
                  _buildDocumentItem(
                    title: 'Contrat de bail ou titre de propriété',
                    description: 'Document prouvant votre lieu de résidence',
                    isRequired: true,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 16),
                  _buildDocumentItem(
                    title: 'Facture récente d\'électricité ou d\'eau',
                    description: 'Facture datant de moins de 3 mois',
                    isRequired: true,
                    textColor: textColor,
                  ),
                  const SizedBox(height: 16),
                  _buildDocumentItem(
                    title: 'Photo d\'identité',
                    description: 'Photo récente format passeport',
                    isRequired: true,
                    textColor: textColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Informations importantes
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFC107).withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: const Color(0xFFFF9800),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Informations importantes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoText('Tous les documents doivent être des originaux', Colors.grey.shade800),
                  _buildInfoText('Les copies doivent être certifiées conformes', Colors.grey.shade800),
                  _buildInfoText('Présentez-vous avec tous les documents requis', Colors.grey.shade800),
                  _buildInfoText('Les documents doivent être en français', Colors.grey.shade800),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Conseils pratiques
            Text(
              'Conseils pratiques:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBulletPoint('Faites des photocopies de tous vos documents', textColor),
                  _buildBulletPoint('Vérifiez les dates de validité', textColor),
                  _buildBulletPoint('Arrivez tôt pour éviter les longues attentes', textColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem({
    required String title,
    required String description,
    required bool isRequired,
    required Color textColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Case à cocher
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF14B53A),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.check,
            color: Color(0xFF14B53A),
            size: 16,
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
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor.withOpacity(0.7),
                ),
              ),
              if (isRequired) ...[
                const SizedBox(height: 4),
                Text(
                  'Obligatoire',
                  style: TextStyle(
                    fontSize: 12,
                    color: const Color(0xFFF44336),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Color(0xFFFF9800),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: Color(0xFF14B53A),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: textColor.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}