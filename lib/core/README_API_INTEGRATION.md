# Intégration Backend Spring Boot - Guide

## 📋 Configuration

### 1. Modifier l'URL du backend

Editez le fichier `lib/core/config/api_config.dart` :

```dart
static const String baseUrl = 'http://10.0.2.2:8080/api';
```

**URLs selon l'environnement :**
- **Android Emulator** : `http://10.0.2.2:8080/api`
- **iOS Simulator** : `http://localhost:8080/api`
- **Appareil physique** : `http://VOTRE_IP_LOCALE:8080/api`

### 2. Installer les dépendances

Exécutez la commande suivante dans le terminal :

```bash
flutter pub get
```

## 🔌 Endpoints requis dans votre Spring Boot

Assurez-vous que votre backend Spring Boot expose ces endpoints :

### Authentification
```
POST /api/auth/login      - Connexion
POST /api/auth/register    - Inscription
POST /api/auth/logout      - Déconnexion
```

### Documents
```
GET    /api/documents              - Liste des documents
GET    /api/documents/{id}         - Document par ID
POST   /api/documents              - Créer un document
PUT    /api/documents/{id}         - Mettre à jour un document
DELETE /api/documents/{id}         - Supprimer un document
GET    /api/documents/category/{id} - Documents par catégorie
```

### Catégories
```
GET /api/categories       - Liste des catégories
GET /api/categories/{id}  - Catégorie par ID
```

## 📝 Exemples d'utilisation

### 1. Authentification dans login_screen.dart

```dart
import '../../core/services/auth_service.dart';

// Dans votre méthode de connexion
try {
  final user = await authService.login(phone, password);
  // Navigation vers l'écran principal
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const HomeScreen()),
  );
} catch (e) {
  // Afficher l'erreur
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Erreur: $e')),
  );
}
```

### 2. Récupération des documents

```dart
import '../../core/services/document_service.dart';

// Dans votre widget
try {
  final documents = await documentService.getAllDocuments();
  // Utiliser les documents
  setState(() {
    _documents = documents;
  });
} catch (e) {
  print('Erreur: $e');
}
```

### 3. Création d'un document

```dart
try {
  final document = await documentService.createDocument({
    'title': 'Mon titre',
    'description': 'Ma description',
    'category': 'identity',
    // autres champs
  });
  print('Document créé: ${document.id}');
} catch (e) {
  print('Erreur: $e');
}
```

## 🔐 Gestion de l'authentification

L'authentification est gérée automatiquement. Le token est sauvegardé automatiquement après connexion et ajouté aux headers de toutes les requêtes.

```dart
// Vérifier si l'utilisateur est connecté
final isLoggedIn = await authService.isLoggedIn();

// Obtenir l'utilisateur actuel
final user = await authService.getCurrentUser();

// Déconnexion
await authService.logout();
```

## 📱 Configuration pour appareils physiques

### Android

1. Assurez-vous que votre appareil et votre ordinateur sont sur le même réseau WiFi
2. Trouvez l'IP locale de votre ordinateur :
   - Windows : `ipconfig` (cherchez IPv4)
   - Mac/Linux : `ifconfig` (cherchez inet)
3. Modifiez `api_config.dart` :
   ```dart
   static const String baseUrl = 'http://VOTRE_IP:8080/api';
   ```

### iOS

1. Même réseau WiFi
2. Utilisez l'IP locale comme pour Android
3. Éditez `ios/Runner/Info.plist` pour autoriser le HTTP :
   ```xml
   <key>NSAppTransportSecurity</key>
   <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
   </dict>
   ```

## 🧪 Tester la connexion

Créez un fichier de test :

```dart
// test_connection.dart
import 'package:flutter/material.dart';
import '../core/services/api_service.dart';

void testConnection() async {
  try {
    final response = await apiService.get('/test');
    print('Connexion OK: ${response.data}');
  } catch (e) {
    print('Erreur: $e');
  }
}
```

## 🎯 Structure Spring Boot recommandée

Votre backend Spring Boot devrait suivre cette structure :

```
src/
  main/
    java/
      controller/
        - AuthController.java
        - DocumentController.java
        - CategoryController.java
      service/
        - AuthService.java
        - DocumentService.java
      repository/
        - UserRepository.java
        - DocumentRepository.java
      model/
        - User.java
        - Document.java
```

## 🔄 Format de réponse attendu

### Login
```json
{
  "token": "jwt_token_here",
  "user": {
    "id": "1",
    "firstName": "John",
    "lastName": "Doe",
    "phone": "+223012345678"
  }
}
```

### Document
```json
{
  "id": "1",
  "title": "Extrait d'acte de naissance",
  "description": "Description...",
  "category": "identity",
  "requiredDocuments": ["document1", "document2"]
}
```

## ⚠️ Important

1. **CORS** : Assurez-vous que votre backend Spring Boot autorise les requêtes depuis Flutter
2. **Sécurité** : Utilisez HTTPS en production
3. **Validation** : Validez toutes les données côté client et serveur
4. **Gestion d'erreurs** : Implémentez une gestion robuste des erreurs

## 🚀 Prochaines étapes

1. Testez la connexion avec votre backend
2. Intégrez les appels API dans vos écrans
3. Ajoutez la gestion d'état pour les données
4. Implémentez la gestion du cache si nécessaire
5. Ajoutez le refresh token pour la sécurité

