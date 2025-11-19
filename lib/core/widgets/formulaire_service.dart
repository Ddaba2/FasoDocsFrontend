// ========================================================================================
// FORMULAIRE SERVICE - Formulaire pour créer une demande de service
// ========================================================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/services/service_service.dart';

class FormulaireService extends StatefulWidget {
  final String procedureId;
  final String procedureNom;
  final double tarifTotal;
  final String communeInitiale;

  const FormulaireService({
    super.key,
    required this.procedureId,
    required this.procedureNom,
    required this.tarifTotal,
    this.communeInitiale = '',
  });

  @override
  State<FormulaireService> createState() => _FormulaireServiceState();
}

class _FormulaireServiceState extends State<FormulaireService> {
  final _formKey = GlobalKey<FormState>();
  
  final _communeController = TextEditingController();
  final _quartierController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _commentairesController = TextEditingController();
  
  DateTime? _dateSouhaitee;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _communeController.text = widget.communeInitiale;
  }

  @override
  void dispose() {
    _communeController.dispose();
    _quartierController.dispose();
    _telephoneController.dispose();
    _commentairesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      setState(() {
        _dateSouhaitee = picked;
      });
    }
  }

  Future<void> _soumettreDemande() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await serviceService.creerDemande(
        procedureId: widget.procedureId,
        commune: _communeController.text.trim(),
        quartier: _quartierController.text.trim().isEmpty 
            ? null 
            : _quartierController.text.trim(),
        adresseComplete: null,
        telephoneContact: _telephoneController.text.trim().isEmpty 
            ? null 
            : _telephoneController.text.trim(),
        dateSouhaitee: _dateSouhaitee,
        commentaires: _commentairesController.text.trim().isEmpty 
            ? null 
            : _commentairesController.text.trim(),
      );
      
      // Afficher un message de succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demande créée avec succès!'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.of(context).pop(true); // Retour avec succès
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demande de Service'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // En-tête
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.blue[900] : Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.procedureNom,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tarif: ${widget.tarifTotal.toStringAsFixed(0)} FCFA',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Commune (obligatoire)
            TextFormField(
              controller: _communeController,
              decoration: const InputDecoration(
                labelText: 'Commune *',
                hintText: 'Ex: Commune I, Kati, etc.',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La commune est obligatoire';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Quartier
            TextFormField(
              controller: _quartierController,
              decoration: const InputDecoration(
                labelText: 'Quartier',
                hintText: 'Ex: Hamdallaye',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.home),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Téléphone de contact
            TextFormField(
              controller: _telephoneController,
              decoration: const InputDecoration(
                labelText: 'Téléphone de contact',
                hintText: '+22370123456',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            
            const SizedBox(height: 16),
            
            // Date souhaitée
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date souhaitée',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _dateSouhaitee != null
                      ? DateFormat('dd/MM/yyyy').format(_dateSouhaitee!)
                      : 'Sélectionner une date',
                  style: TextStyle(
                    color: _dateSouhaitee != null 
                        ? textColor 
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Commentaires
            TextFormField(
              controller: _commentairesController,
              decoration: const InputDecoration(
                labelText: 'Commentaires / Instructions spéciales',
                hintText: 'Ex: Besoin urgent pour voyage...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 4,
            ),
            
            const SizedBox(height: 32),
            
            // Bouton de soumission
            ElevatedButton(
              onPressed: _isLoading ? null : _soumettreDemande,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Soumettre la demande',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

