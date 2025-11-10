// ÉCRAN: SIGNALER UN PROBLÈME
import 'package:flutter/material.dart';
import '../../locale/locale_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/services/signalement_service.dart';
import '../../models/api_models.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  String? _selectedReportType;
  final TextEditingController _structureController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  final SignalementService _signalementService = signalementService;
  bool _isSubmitting = false;
  List<SignalementType> _reportTypes = [
    SignalementType(id: '1', nom: 'ABSENCE_DU_SERVICE', description: 'Absence du service'),
    SignalementType(id: '2', nom: 'NON_RESPECT_DU_DELAI', description: 'Non-respect du délai'),
    SignalementType(id: '3', nom: 'MAUVAISE_QUALITE_DU_SERVICE', description: 'Mauvaise qualité du service'),
    SignalementType(id: '4', nom: 'AUTRE', description: 'Autre type de signalement'),
  ];
  bool _isLoadingTypes = false;

  // Couleur principale
  static const Color primaryColor = Color(0xFF14B53A);

  @override
  void initState() {
    super.initState();
    _loadReportTypes();
  }
  Future<void> _loadReportTypes() async {
    setState(() {
      _isLoadingTypes = true;
    });
    try {
      final types = await _signalementService.getSignalementTypes();
      setState(() {
        // Si des types sont retournés du backend, on les utilise
        if (types.isNotEmpty) {
          _reportTypes = types;
        }
        // Sinon, on garde les valeurs par défaut déjà définies
        _isLoadingTypes = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingTypes = false;
      });
      // Fallback silencieux: utiliser les valeurs par défaut
      print('Impossible de charger les types depuis le backend: $e');
    }
  }

  @override
  void dispose() {
    _structureController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la sélection de l\'image: $e')),
        );
      }
    }
  }

  // Convert image to base64 string
  /*Future<String?> _convertImageToBase64() async {
    if (_selectedImage == null) return null;
    
    try {
      final bytes = await _selectedImage!.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      // Log the error for debugging (in production, you might want to use a proper logger)
      // print('Erreur lors de la conversion de l\'image: $e');
      return null;
    }
  }*/

  // Envoyer le signalement au backend
  Future<void> _submitSignalement() async {
    // Validation des champs
    if (_selectedReportType == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner un type de signalement'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_structureController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez indiquer la structure concernée'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez décrire le problème'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Créer un titre basé sur la structure
      String titre = _structureController.text.trim();

      // Créer la requête de signalement
      final signalementRequest = SignalementRequest(
        titre: titre,
        description: _descriptionController.text.trim(),
        type: _selectedReportType!,
        structure: _structureController.text.trim(),
      );

      // Envoyer au backend
      await _signalementService.createSignalement(signalementRequest);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signalement envoyé avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Retourner à l'écran précédent
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Log the error for debugging (in production, you might want to use a proper logger)
      // print('❌ Erreur envoi signalement: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'envoi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  /// Obtenir le label localisé pour un type de signalement
  /*String _getLocalizedLabel(String type) {
    switch (type) {
      case 'ABSENCE_DU_SERVICE':
        return 'Absence du service';
      case 'NON_RESPECT_DU_DELAI':
        return 'Non-respect du délai';
      case 'MAUVAISE_QUALITE_DU_SERVICE':
        return 'Mauvaise qualité du service';
      case 'AUTRE':
        return 'Autre';
      default:
        return type;
    }
  }*/

  @override
  Widget build(BuildContext context) {
    // 1. Récupération des couleurs du thème
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final Color iconColor = Theme.of(context).iconTheme.color!;
    final Color secondaryIconColor = isDarkMode ? (Colors.grey[400] ?? Colors.white70) : (Colors.grey[600] ?? Colors.black54);
    final Color hintColor = isDarkMode ? (Colors.grey[500] ?? Colors.white54) : (Colors.grey[600] ?? Colors.black54);

    // Couleur de fond pour le cercle du profil
    // final Color profileIconBg = isDarkMode ? Theme.of(context).colorScheme.surface : (Colors.grey[300] ?? const Color(0xFFCCCCCC)); // Not used, so commented out
    // Couleur de la bordure des champs (moins agressif que le primaryColor en mode sombre)
    final Color inputBorderColor = isDarkMode ? primaryColor.withOpacity(0.7) : primaryColor;

    return Scaffold(
      backgroundColor: backgroundColor, // FOND: Couleur du thème

      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
          icon: Icon(
          Icons.chevron_left,
          color: Colors.green,

        ),),
        title:  Text(

          LocaleHelper.getText(context, 'reportProblem'),

          style: TextStyle(

            fontSize: 20,

            fontWeight: FontWeight.bold,

            color: textColor,

          ),

        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final double screenHeight = constraints.maxHeight;
            final double horizontalPadding = screenWidth * 0.05;
            // final double verticalPadding = screenHeight * 0.02; // Not used, so commented out

            return Column(
              children: [


                // Contenu principal
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre avec bouton retour

                        SizedBox(height: screenHeight * 0.04),

                        // Type de signalement
                        Text(
                          'Type de report',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: textColor, // TEXTE: Couleur du thème
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: inputBorderColor, width: 1), // BORDURE: Couleur dynamique
                            borderRadius: BorderRadius.circular(8),
                            color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white, // FOND: Couleur de carte
                          ),
                          child: _isLoadingTypes
                              ? const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedReportType,
                                    hint: Text(
                                      'Sélectionnez un type',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: hintColor, // TEXTE HINT: Couleur du thème
                                      ),
                                    ),
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: iconColor, // ICÔNE: Couleur du thème
                                      size: screenWidth * 0.05,
                                    ),
                                    // <--- CORRECTION APPLIQUÉE ICI : Utilisation de colorScheme.surface
                                    dropdownColor: Theme.of(context).colorScheme.surface,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      color: textColor, // TEXTE ITEM: Couleur du thème
                                    ),
                                    items: _reportTypes.map((SignalementType t) {
                                      return DropdownMenuItem<String>(
                                        value: t.nom,
                                        child: Text(
                                          t.nom,
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.04,
                                            color: textColor, // TEXTE ITEM: Couleur du thème
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedReportType = newValue;
                                      });
                                    },
                                  ),
                                ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // Structure concernée
                        Text(
                          'Structure concernée',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: textColor, // TEXTE: Couleur du thème
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: inputBorderColor, width: 1), // BORDURE: Couleur dynamique
                            borderRadius: BorderRadius.circular(8),
                            color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white, // FOND: Couleur de carte
                          ),
                          child: TextField(
                            controller: _structureController,
                            decoration: InputDecoration(
                              hintText: 'Nom de la structure',
                              hintStyle: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: hintColor, // TEXTE HINT: Couleur du thème
                              ),
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: secondaryIconColor, // ICÔNE: Couleur du thème
                                size: screenWidth * 0.05,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: textColor, // TEXTE SAISI: Couleur du thème
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // Description
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: textColor, // TEXTE: Couleur du thème
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.15,
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            border: Border.all(color: inputBorderColor, width: 1), // BORDURE: Couleur dynamique
                            borderRadius: BorderRadius.circular(8),
                            color: isDarkMode ? Theme.of(context).colorScheme.surface : Colors.white, // FOND: Couleur de carte
                          ),
                          child: TextField(
                            controller: _descriptionController,
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
                              hintText: 'Description du problème rencontré...',
                              hintStyle: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: hintColor, // TEXTE HINT: Couleur du thème
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: textColor, // TEXTE SAISI: Couleur du thème
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // Ajouter une photo
                        Text(
                          'Ajouter une photo (optionel)',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                            color: textColor, // TEXTE: Couleur du thème
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: screenHeight * 0.2,
                            decoration: BoxDecoration(
                              // BORDURE: Utilisation d'une couleur plus visible en mode sombre
                              border: Border.all(color: isDarkMode ? (Colors.grey[600] ?? Colors.white54) : (Colors.grey[400] ?? Colors.black54), width: 2, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _selectedImage != null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              // Utilisation de Image.file pour les images locales
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            )
                                : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    color: secondaryIconColor, // ICÔNE: Couleur du thème
                                    size: screenWidth * 0.08,
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    'Appuyez pour ajouter une photo',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: hintColor, // TEXTE HINT: Couleur du thème
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // Bouton Envoyer le signalement
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitSignalement,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Envoyer le report',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.02),
                                      Icon(
                                        Icons.send,
                                        size: screenWidth * 0.05,
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),
                      ],
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
}