// ========================================================================================
// TAX SCREEN - ÉCRAN IMPÔT ET DOUANE
// ========================================================================================
// Cet écran affiche toutes les procédures liées aux impôts et douanes
// disponibles dans l'application FasoDocs. Il permet aux utilisateurs de gérer
// leurs obligations fiscales de manière simplifiée.
//
// Fonctionnalités :
// - Affichage des procédures fiscales en grille
// - Interface responsive et intuitive
// - Navigation vers les procédures spécialisées
// ========================================================================================

import 'package:flutter/material.dart';

/// Écran des procédures fiscales et douanières
/// 
/// Affiche une grille des différentes procédures liées aux impôts et douanes
/// que les utilisateurs peuvent effectuer selon leurs besoins.
class TaxScreen extends StatelessWidget {
  const TaxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;
    final iconColor = Theme.of(context).iconTheme.color!;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.green,
          ),
        ),
        title: Text(
          'Impot et Douane',
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
                    // Déclaration de revenu foncier
                    _buildTaxCard(
                      icon: Icons.home,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Déclaration de revenu foncier',
                    ),
                    // Déclaration de TVA
                    _buildTaxCard(
                      icon: Icons.receipt,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Déclaration de TVA (Taxe sur la Valeur Ajoutée)',
                    ),
                    // Enregistrement d'un contrat
                    _buildTaxCard(
                      icon: Icons.assignment,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Enregistrement d\'un contrat',
                    ),
                    // L'Impôt sur les traitements et salaires
                    _buildTaxCard(
                      icon: Icons.work,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'L\'Impôt sur les traitements et salaires (I.T.S)',
                    ),
                    // La Contribution forfaitaire à la charge des employeurs
                    _buildTaxCard(
                      icon: Icons.business,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'La Contribution forfaitaire à la charge des employeurs (CFE)',
                    ),
                    // La Taxe logement
                    _buildTaxCard(
                      icon: Icons.apartment,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'La Taxe logement (TL)',
                    ),
                    // La Contribution Générale de solidarité
                    _buildTaxCard(
                      icon: Icons.volunteer_activism,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'La Contribution Générale de solidarité (CGS)',
                    ),
                    // La Taxe de Solidarité et de Lutte contre le Tabagisme
                    _buildTaxCard(
                      icon: Icons.smoke_free,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'La Taxe de Solidarité et de Lutte contre le Tabagisme (TSLT)',
                    ),
                    // L'Impôt sur les bénéfices industriels et commerciaux
                    _buildTaxCard(
                      icon: Icons.factory,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'L\'Impôt sur les bénéfices industriels et commerciaux (IBIC /IS)',
                    ),
                    // L'Impôt synthétique
                    _buildTaxCard(
                      icon: Icons.calculate,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'L\'Impôt synthétique',
                    ),
                    // L'Impôt sur les bénéfices agricoles
                    _buildTaxCard(
                      icon: Icons.agriculture,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'L\'Impôt sur les bénéfices agricoles (IBA)',
                    ),
                    // L'Impôt sur les revenus de valeurs Mobilières
                    _buildTaxCard(
                      icon: Icons.trending_up,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'L\'Impôt sur les revenus de valeurs Mobilières (IRVM)',
                    ),
                    // L'Impôt sur les revenus fonciers
                    _buildTaxCard(
                      icon: Icons.landscape,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'L\'Impôt sur les revenus fonciers (IRF)',
                    ),
                    // La Taxe foncière
                    _buildTaxCard(
                      icon: Icons.home_work,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'La Taxe foncière (T.F)',
                    ),
                    // La Patente professionnelle et licence
                    _buildTaxCard(
                      icon: Icons.badge,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'La Patente professionnelle et licence',
                    ),
                    // La Patente sur marchés
                    _buildTaxCard(
                      icon: Icons.store,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'La Patente sur marchés',
                    ),
                    // La Taxe touristique
                    _buildTaxCard(
                      icon: Icons.travel_explore,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'La Taxe touristique (T.T)',
                    ),
                    // La taxe sur les véhicules automobiles
                    _buildTaxCard(
                      icon: Icons.directions_car,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'La taxe sur les véhicules automobiles (Vignettes ordinaires)',
                    ),
                    // La Taxe sur les transports routiers
                    _buildTaxCard(
                      icon: Icons.local_shipping,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'La Taxe sur les transports routiers (TTR)',
                    ),
                    // Les prélèvements
                    _buildTaxCard(
                      icon: Icons.payments,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Les prélèvements',
                    ),
                    // La redevance et le recouvrement de régulation sur les marchés publics
                    _buildTaxCard(
                      icon: Icons.account_balance,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'La redevance et le recouvrement de régulation sur les marchés publics',
                    ),
                    // Impôt spécial sur certains produits
                    _buildTaxCard(
                      icon: Icons.inventory,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Impôt spécial sur certains produits (ISCP)',
                    ),
                    // Taxe sur les activités financières
                    _buildTaxCard(
                      icon: Icons.account_balance_wallet,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Taxe sur les activités financières (TAF)',
                    ),
                    // Taxe intérieure sur les produits pétroliers
                    _buildTaxCard(
                      icon: Icons.local_gas_station,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Taxe intérieure sur les produits pétroliers (TIPP)',
                    ),
                    // Contribution de solidarité sur les billets d'avion
                    _buildTaxCard(
                      icon: Icons.flight,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Contribution de solidarité sur les billets d\'avion (CSB)',
                    ),
                    // Taxe sur l'accès au réseau des télécommunications
                    _buildTaxCard(
                      icon: Icons.phone,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Taxe sur l\'accès au réseau des télécommunications ouvert au public (TARTOP)',
                    ),
                    // Taxe sur les contrats d'assurance
                    _buildTaxCard(
                      icon: Icons.security,
                      backgroundColor: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFE91E63),
                      title: 'Taxe sur les contrats d\'assurance (TCA)',
                    ),
                    // Taxe sur les exportateurs d'or non régis par le code minier
                    _buildTaxCard(
                      icon: Icons.diamond,
                      backgroundColor: const Color(0xFFE8F5E8),
                      iconColor: const Color(0xFF4CAF50),
                      title: 'Taxe sur les exportateurs d\'or non régis par le code minier',
                    ),
                    // Taxe sur les armes à feu
                    _buildTaxCard(
                      icon: Icons.warning,
                      backgroundColor: const Color(0xFFFFF9C4),
                      iconColor: const Color(0xFFFFB300),
                      title: 'Taxe sur les armes à feu',
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
          border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.black, width: 1),
        ),
        child: Icon(
          Icons.headset_mic,
          color: iconColor,
          size: 24,
        ),
      ),
    );
  }

  /// Construit une carte de procédure fiscale avec icône, couleur et titre
  ///
  /// [icon] : L'icône à afficher
  /// [backgroundColor] : Couleur de fond de l'icône
  /// [iconColor] : Couleur de l'icône
  /// [title] : Titre de la procédure
  Widget _buildTaxCard({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required String title,
  }) {
    return Builder(
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final cardColor = Theme.of(context).cardColor;
        final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
        
        return Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.black, width: 1),
            boxShadow: isDarkMode ? null : [
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
        );
      },
    );
  }
}