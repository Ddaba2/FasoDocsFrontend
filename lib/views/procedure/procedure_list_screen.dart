// ========================================================================================
// PROCEDURE LIST SCREEN - Écran de liste des procédures d'une catégorie
// ========================================================================================

import 'package:flutter/material.dart';
import '../../core/services/procedure_service.dart';
import '../../models/api_models.dart';
import '../../locale/locale_helper.dart';
import 'procedure_detail_screen.dart';

class ProcedureListScreen extends StatefulWidget {
  final String? categorieId;
  final String? categorieNom;
  final List<ProcedureResponse>? procedures; // Liste optionnelle de procédures déjà chargées
  final String? title; // Titre personnalisé pour les résultats de recherche
  
  const ProcedureListScreen({
    super.key,
    this.categorieId,
    this.categorieNom,
    this.procedures, // Si fourni, on ne recharge pas depuis l'API
    this.title, // Titre optionnel
  });

  @override
  State<ProcedureListScreen> createState() => _ProcedureListScreenState();
}

class _ProcedureListScreenState extends State<ProcedureListScreen> {
  List<ProcedureResponse> _procedures = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    
    // Si des procédures sont déjà fournies, les utiliser directement
    if (widget.procedures != null && widget.procedures!.isNotEmpty) {
      setState(() {
        _procedures = widget.procedures!;
        _isLoading = false;
      });
    } else {
      // Sinon, charger depuis l'API
      _loadProcedures();
    }
  }
  
  // Charger les procédures de la catégorie depuis l'API
  Future<void> _loadProcedures() async {
    // Ne charger que si categorieId est fourni
    if (widget.categorieId == null) {
      setState(() {
        _errorMessage = 'Aucune catégorie spécifiée';
        _isLoading = false;
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final procedures = await procedureService.getProceduresByCategorie(widget.categorieId!);
      setState(() {
        _procedures = procedures;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de chargement: $e';
        _isLoading = false;
      });
      print('Erreur lors du chargement des procédures: $e');
    }
  }
  
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
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.chevron_left, color: Colors.green),
        ),
        title: Text(
          widget.title ?? widget.categorieNom ?? 'Procédures',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: SafeArea(
        child: _buildContent(),
      ),
      floatingActionButton: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: cardColor,
          shape: BoxShape.circle,
          border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.black, width: 1),
          boxShadow: isDarkMode ? null : [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          Icons.mic,
          color: Colors.green,
          size: 24,
        ),
      ),
    );
  }
  
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProcedures,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }
    
    if (_procedures.isEmpty) {
      return const Center(
        child: Text('Aucune procédure disponible'),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: _procedures.length,
        itemBuilder: (context, index) {
          return _buildProcedureCard(_procedures[index]);
        },
      ),
    );
  }
  
  Widget _buildProcedureCard(ProcedureResponse procedure) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final colors = _getProcedureColors(procedure.titre.toLowerCase());
    
    return GestureDetector(
      onTap: () {
        // Naviguer vers l'écran de détail
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProcedureDetailScreen(procedure: procedure),
          ),
        );
      },
      child: Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.black,
          width: 1,
        ),
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
              color: isDarkMode ? colors['backgroundColor']!.withOpacity(0.2) : colors['backgroundColor'],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              _getProcedureIcon(procedure.titre.toLowerCase()),
              size: 24,
              color: colors['iconColor'],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              procedure.titre,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      ),
    );
  }
  
  Map<String, Color> _getProcedureColors(String title) {
    final colors = [
      {'backgroundColor': const Color(0xFFE8F5E8), 'iconColor': const Color(0xFF4CAF50)},
      {'backgroundColor': const Color(0xFFFFF9C4), 'iconColor': const Color(0xFFFFB300)},
      {'backgroundColor': const Color(0xFFFFEBEE), 'iconColor': const Color(0xFFE91E63)},
      {'backgroundColor': const Color(0xFFE3F2FD), 'iconColor': const Color(0xFF2196F3)},
    ];
    return colors[title.hashCode.abs() % colors.length];
  }
  
  IconData _getProcedureIcon(String titre) {
    final lowerTitre = titre.toLowerCase();
    if (lowerTitre.contains('naissance')) return Icons.person;
    if (lowerTitre.contains('mariage')) return Icons.favorite;
    if (lowerTitre.contains('décès')) return Icons.close;
    if (lowerTitre.contains('permis') || lowerTitre.contains('conduire')) return Icons.directions_car;
    if (lowerTitre.contains('passeport')) return Icons.credit_card;
    if (lowerTitre.contains('carte') || lowerTitre.contains('identité')) return Icons.badge;
    if (lowerTitre.contains('visite') || lowerTitre.contains('technique')) return Icons.build;
    return Icons.description;
  }
}

