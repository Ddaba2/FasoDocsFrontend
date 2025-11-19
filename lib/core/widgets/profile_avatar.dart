// ========================================================================================
// WIDGET AVATAR PROFIL - Affichage de la photo de profil avec Base64
// ========================================================================================

import 'dart:convert';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? photoBase64;
  final double radius;
  final Color? backgroundColor;
  final IconData defaultIcon;
  final double? defaultIconSize;

  const ProfileAvatar({
    super.key,
    this.photoBase64,
    this.radius = 50,
    this.backgroundColor,
    this.defaultIcon = Icons.person,
    this.defaultIconSize,
  });

  @override
  Widget build(BuildContext context) {
    // Si une photo Base64 est fournie
    if (photoBase64 != null && photoBase64!.isNotEmpty) {
      try {
        debugPrint('📸 ProfileAvatar: Photo fournie (${photoBase64!.length} caractères)');
        
        // Extraire les données Base64 (après la virgule)
        // Format attendu: "data:image/jpeg;base64,/9j/4AAQSkZJRg..."
        String base64Data;
        if (photoBase64!.contains(',')) {
          base64Data = photoBase64!.split(',')[1];
          debugPrint('📸 ProfileAvatar: Préfixe détecté, extraction des données Base64');
        } else {
          // Si pas de préfixe, on assume que c'est déjà du Base64 pur
          base64Data = photoBase64!;
          debugPrint('📸 ProfileAvatar: Pas de préfixe, utilisation directe du Base64');
        }

        // Décoder le Base64 en bytes
        final bytes = base64Decode(base64Data);
        debugPrint('📸 ProfileAvatar: Base64 décodé en ${bytes.length} bytes');

        // Afficher l'avatar avec l'image
        return CircleAvatar(
          radius: radius,
          backgroundImage: MemoryImage(bytes),
          backgroundColor: backgroundColor ?? Colors.grey.shade300,
          onBackgroundImageError: (exception, stackTrace) {
            debugPrint('❌ ProfileAvatar: Erreur chargement image: $exception');
          },
        );
      } catch (e, stackTrace) {
        debugPrint('❌ ProfileAvatar: Erreur décodage photo Base64 : $e');
        debugPrint('❌ StackTrace: $stackTrace');
        // En cas d'erreur, afficher l'avatar par défaut
        return _buildDefaultAvatar(context);
      }
    }

    // Photo par défaut si aucune photo n'est fournie
    debugPrint('📸 ProfileAvatar: Aucune photo fournie, affichage avatar par défaut');
    return _buildDefaultAvatar(context);
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.2),
      child: Icon(
        defaultIcon,
        size: defaultIconSize ?? radius,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

// ========================================================================================
// WIDGET AVATAR ÉDITABLE - Avec bouton pour changer la photo
// ========================================================================================

class EditableProfileAvatar extends StatelessWidget {
  final String? photoBase64;
  final VoidCallback onEditPressed;
  final double radius;
  final Color? backgroundColor;
  final bool isLoading;

  const EditableProfileAvatar({
    super.key,
    this.photoBase64,
    required this.onEditPressed,
    this.radius = 50,
    this.backgroundColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Avatar
        ProfileAvatar(
          photoBase64: photoBase64,
          radius: radius,
          backgroundColor: backgroundColor,
        ),

        // Indicateur de chargement
        if (isLoading)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black54,
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),

        // Bouton d'édition
        if (!isLoading)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEditPressed,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

