// ÉCRAN: HISTORIQUE
import 'package:flutter/material.dart';
import '../../core/services/history_service.dart';
import '../procedure/procedure_detail_screen.dart';
import '../../core/services/procedure_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<HistoryItem> _historyItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final history = await historyService.getHistory();
      setState(() {
        _historyItems = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('❌ Erreur chargement historique: $e');
    }
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Effacer l\'historique'),
        content: const Text(
          'Êtes-vous sûr de vouloir effacer tout votre historique de navigation ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Effacer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await historyService.clearHistory();
      _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Historique effacé'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  void _onHistoryItemTap(HistoryItem item) async {
    if (item.type == HistoryType.procedure) {
      try {
        // Recharger les détails de la procédure
        final procedures = await procedureService.getAllProcedures();
        final procedure = procedures.firstWhere(
          (p) => p.id == item.id,
          orElse: () => throw Exception('Procédure non trouvée'),
        );

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProcedureDetailScreen(procedure: procedure),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Impossible d\'ouvrir cette procédure: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  IconData _getIconForType(HistoryType type) {
    switch (type) {
      case HistoryType.procedure:
        return Icons.description;
      case HistoryType.category:
        return Icons.category;
      case HistoryType.search:
        return Icons.search;
      case HistoryType.report:
        return Icons.warning;
      case HistoryType.notification:
        return Icons.notifications;
      case HistoryType.center:
        return Icons.location_on;
    }
  }

  Color _getColorForType(HistoryType type) {
    switch (type) {
      case HistoryType.procedure:
        return Colors.blue;
      case HistoryType.category:
        return Colors.green;
      case HistoryType.search:
        return Colors.orange;
      case HistoryType.report:
        return Colors.red;
      case HistoryType.notification:
        return Colors.purple;
      case HistoryType.center:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final cardColor = Theme.of(context).cardColor;
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.green,
          ),
        ),
        title: Text(
          'Historique',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        actions: [
          if (_historyItems.isNotEmpty)
            IconButton(
              onPressed: _clearHistory,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: 'Effacer l\'historique',
            ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final horizontalPadding = screenWidth * 0.05;
            
            if (_isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF14B53A)),
              );
            }
            
            if (_historyItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Aucun historique',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Les procédures que vous consultez\napparaîtront ici',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return Column(
              children: [
                // Contenu principal
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadHistory,
                    color: const Color(0xFF14B53A),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: screenHeight * 0.02,
                      ),
                      itemCount: _historyItems.length,
                      itemBuilder: (context, index) {
                        final item = _historyItems[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                          child: _buildHistoryItem(
                            context,
                            screenWidth,
                            screenHeight,
                            _getIconForType(item.type),
                            _getColorForType(item.type),
                            item.title,
                            item.getRelativeTime(),
                            isDarkMode,
                            textColor,
                            cardColor,
                            () => _onHistoryItemTap(item),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHistoryItem(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    IconData icon,
    Color iconColor,
    String title,
    String time,
    bool isDarkMode,
    Color textColor,
    Color cardColor,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: isDarkMode ? cardColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: isDarkMode ? Border.all(color: Colors.grey.shade700, width: 1) : null,
          boxShadow: isDarkMode ? null : [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: screenWidth * 0.12,
              height: screenWidth * 0.12,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: screenWidth * 0.06,
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: isDarkMode ? Colors.grey.shade400 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}