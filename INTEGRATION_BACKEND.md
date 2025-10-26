# 🔗 Intégration Backend Spring Boot - FasoDocs

## ✅ Ce qui a été fait

### 1. Packages ajoutés
- `http: ^1.2.0` - Package HTTP standard
- `dio: ^5.4.0` - Client HTTP avancé avec interceptors

### 2. Services créés
- ✅ `lib/core/config/api_config.dart` - Configuration de l'URL du backend
- ✅ `lib/core/services/api_service.dart` - Service HTTP principal
- ✅ `lib/core/services/auth_service.dart` - Service d'authentification
- ✅ `lib/core/services/document_service.dart` - Service de gestion des documents

### 3. Documentation
- ✅ `lib/core/README_API_INTEGRATION.md` - Guide complet d'intégration
- ✅ `lib/core/examples/login_with_api_example.dart` - Exemples de code

## 🚀 Configuration

### Étape 1 : Modifier l'URL du backend

Ouvrez `lib/core/config/api_config.dart` et modifiez :

```dart
static const String baseUrl = 'http://10.0.2.2:8080/api';
```

**Selon votre environnement :**
- **Android Emulator** : `http://10.0.2.2:8080/api`
- **iOS Simulator** : `http://localhost:8080/api`
- **Appareil physique** : `http://VOTRE_IP_LOCALE:8080/api`

Pour trouver votre IP locale :
- **Windows** : Ouvrez cmd et tapez `ipconfig`
- **Mac/Linux** : Tapez `ifconfig` dans le terminal

### Étape 2 : Configurer votre backend Spring Boot

Assurez-vous que votre backend expose ces endpoints :

#### Authentification
```
POST /api/auth/login      - {phone, password}
POST /api/auth/register   - {firstName, lastName, phone, password, email?}
POST /api/auth/logout     - Headers: Authorization: Bearer {token}
```

#### Documents
```
GET    /api/documents              - Liste de tous les documents
GET    /api/documents/{id}         - Document par ID
POST   /api/documents              - Créer un document
PUT    /api/documents/{id}         - Mettre à jour
DELETE /api/documents/{id}         - Supprimer
GET    /api/documents/category/{categoryId}  - Documents par catégorie
```

#### Format de réponse attendu

**Login :**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "1",
    "firstName": "Moussa",
    "lastName": "Diallo",
    "phone": "+22370123456",
    "email": "moussa@example.com"
  }
}
```

**Document :**
```json
{
  "id": "1",
  "title": "Extrait d'acte de naissance",
  "description": "Document officiel d'identité",
  "category": "identity",
  "requiredDocuments": ["carte d'identité", "certificat"],
  "steps": [
    {
      "number": 1,
      "title": "Se rendre à la mairie",
      "description": "Avec les documents requis"
    }
  ],
  "amount": "Gratuit",
  "centers": ["Mairie de Bamako"]
}
```

## 🔌 Utilisation dans votre code

### Exemple 1 : Connexion

Dans `lib/views/auth/login_screen.dart` :

```dart
import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../home/home_screen.dart';

class _LoginScreenState extends State<LoginScreen> {
  void _handleLogin() async {
    final phone = _phoneController.text;
    
    try {
      // Afficher un loader
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      
      // Appel API
      final user = await authService.login(phone, password);
      
      // Fermer le loader
      if (mounted) Navigator.of(context).pop();
      
      // Navigation
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }
}
```

### Exemple 2 : Récupérer les documents

```dart
import '../../core/services/document_service.dart';

void loadDocuments() async {
  try {
    final documents = await documentService.getAllDocuments();
    setState(() {
      _documents = documents;
    });
  } catch (e) {
    print('Erreur: $e');
  }
}
```

### Exemple 3 : Vérifier l'authentification

```dart
import '../../core/services/auth_service.dart';

Future<void> checkAuth() async {
  final isLoggedIn = await authService.isLoggedIn();
  
  if (isLoggedIn) {
    // Utilisateur connecté
    final user = await authService.getCurrentUser();
    print('Utilisateur: ${user?.firstName}');
  } else {
    // Rediriger vers login
  }
}
```

## 🔧 Configuration CORS (Important)

Dans votre backend Spring Boot, ajoutez cette configuration :

```java
@Configuration
public class CorsConfig {
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/api/**")
                        .allowedOrigins("*")
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                        .allowedHeaders("*")
                        .exposedHeaders("Authorization")
                        .maxAge(3600);
            }
        };
    }
}
```

## 📱 Test sur appareil physique

### Android

1. Connectez votre appareil en USB
2. Activez le débogage USB
3. Trouvez votre IP locale : `ipconfig` (Windows) ou `ifconfig` (Mac/Linux)
4. Modifiez `api_config.dart` : `http://VOTRE_IP:8080/api`
5. Installez l'app : `flutter run`

### iOS

1. Dans `ios/Runner/Info.plist`, ajoutez :
```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
  <key>NSAllowsArbitraryLoadsInWebContent</key>
  <true/>
</dict>
```

## 🎯 Prochaines étapes

1. **Tester la connexion** :
   ```dart
   // Créez un bouton de test temporaire
   ElevatedButton(
     onPressed: () async {
       try {
         final response = await apiService.get('/test');
         print('✅ Connexion OK: ${response.data}');
       } catch (e) {
         print('❌ Erreur: $e');
       }
     },
     child: Text('Tester connexion'),
   )
   ```

2. **Intégrer dans l'écran de connexion** : Voir `lib/core/examples/login_with_api_example.dart`

3. **Créer les models manquants** : Adaptez `lib/models/user_model.dart` et `document_model.dart` selon votre backend

4. **Ajouter la gestion d'état** : Utilisez Bloc ou Provider pour gérer les données

## 📚 Ressources

- [Documentation Dio](https://pub.dev/packages/dio)
- [Documentation HTTP](https://pub.dev/packages/http)
- [Shared Preferences](https://pub.dev/packages/shared_preferences)

## 🐛 Dépannage

### Erreur "Connection refused"
- Vérifiez que votre backend est en cours d'exécution
- Vérifiez l'URL dans `api_config.dart`
- Vérifiez le port (défaut : 8080)

### Erreur "Timeout"
- Augmentez le timeout dans `api_service.dart`
- Vérifiez votre connexion réseau

### Erreur CORS
- Configurez CORS dans votre backend Spring Boot
- Ajoutez les headers nécessaires

### Token expiré
- Implémentez le refresh token dans `auth_service.dart`

---

## ✨ Résumé

Votre application Flutter peut maintenant communiquer avec votre backend Spring Boot ! Il suffit de :

1. Modifier l'URL dans `api_config.dart`
2. Implémenter les appels API dans vos écrans
3. Tester la connexion

Bonne chance avec votre intégration ! 🚀

