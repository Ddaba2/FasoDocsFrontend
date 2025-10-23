// ÉCRAN: SIGNALER UN PROBLÈME
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// CORRECTION : Imports absolus basés sur le paquet pour résoudre les erreurs de chemin
import 'package:fasodocs/views/profile/profile_screen.dart'; // REMPLACER 'fasodocs' si nécessaire
import 'package:fasodocs/views/history/history_screen.dart';   // REMPLACER 'fasodocs' si nécessaire

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

  final List<String> _reportTypes = const [
    'Problème technique',
    'Erreur de contenu',
    'Suggestion d\'amélioration',
    'Signalement d\'abus',
    'Autre',
  ];

  // Couleur principale
  static const Color primaryColor = Color(0xFF14B53A);

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de l\'image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Récupération des couleurs du thème
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final Color textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final Color iconColor = Theme.of(context).iconTheme.color!;
    final Color secondaryIconColor = isDarkMode ? (Colors.grey[400] ?? Colors.white70) : (Colors.grey[600] ?? Colors.black54);
    final Color hintColor = isDarkMode ? (Colors.grey[500] ?? Colors.white54) : (Colors.grey[600] ?? Colors.black54);

    // Couleur de fond pour le cercle du profil
    final Color profileIconBg = isDarkMode ? Theme.of(context).colorScheme.surface : (Colors.grey[300] ?? const Color(0xFFCCCCCC));
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

          'Signaler un problème',

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
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final horizontalPadding = screenWidth * 0.05;
            final verticalPadding = screenHeight * 0.02;

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
                          child: DropdownButtonHideUnderline(
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
                              items: _reportTypes.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
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
                            onPressed: () {
                              // TODO: Implémenter la logique d'envoi du signalement
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Signalement envoyé (Logique non implémentée)')),
                              );
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
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