// ========================================================================================
// TARIF SERVICE MODAL - Modal affichant le tarif de service
// ========================================================================================

import 'package:flutter/material.dart';
import '../../models/service_models.dart';

class TarifServiceModal extends StatelessWidget {
  final TarifService tarif;
  final VoidCallback onContinuer;
  final VoidCallback onAnnuler;

  const TarifServiceModal({
    super.key,
    required this.tarif,
    required this.onContinuer,
    required this.onAnnuler,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '💰 Tarif de Service',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onAnnuler,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Nom de la procédure
            Text(
              tarif.procedureNom,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue[700],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Détails du tarif
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildTarifLigne(
                    'Service',
                    tarif.tarifService,
                    textColor: textColor,
                  ),
                  if (tarif.coutLegal != null)
                    _buildTarifLigne(
                      'Coût légal',
                      tarif.coutLegal!,
                      textColor: textColor,
                    ),
                  const Divider(height: 24),
                  _buildTarifLigne(
                    'TOTAL',
                    tarif.tarifTotal,
                    isTotal: true,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Délai estimé
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Délai estimé: ${tarif.delaiEstime}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Services inclus
            Text(
              '✅ Services inclus:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Prise en charge complète\n'
              '• Suivi des démarches\n'
              '• Récupération des documents',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Boutons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onAnnuler,
                    child: const Text('Annuler'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onContinuer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Continuer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTarifLigne(
    String label,
    double montant, {
    bool isTotal = false,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
          Text(
            '${montant.toStringAsFixed(0)} FCFA',
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.orange[700] : textColor,
            ),
          ),
        ],
      ),
    );
  }
}

