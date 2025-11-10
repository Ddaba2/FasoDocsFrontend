# 📡 Intégration Backend - FasoDocs

Ce document décrit en détail l'intégration entre l'application mobile FasoDocs et le backend Spring Boot.

## 🏗️ Architecture

L'application communique avec un backend **Spring Boot** via une API REST. Les requêtes HTTP sont gérées par **Dio** avec authentification JWT.

```
┌─────────────────┐         HTTP/REST          ┌──────────────────┐
│  Flutter App    │ ◄────────────────────────► │  Spring Boot API │
│  (FasoDocs)     │     JSON + JWT Token       │  (Backend)       │
└─────────────────┘                            └──────────────────┘
        │                                               │
        ▼                                               ▼
  SharedPreferences                              PostgreSQL DB
  (Stockage local)                              (Base de données)
```

## 📁 Structure des fichiers

### 1. Configuration API

#### `lib/core/config/api_config.dart`
**Rôle** : Configuration centralisée de toutes les URLs et endpoints de l'API

**Contenu** :
- URL de base du backend (adaptative selon la plateforme)
- Tous les endpoints de l'API organisés par module
- Méthode helper pour construire les URLs complètes

**Configuration dynamique de l'URL** :
```dart
static String get baseUrl {
  // 1. Override via --dart-define
  const String override = String.fromEnvironment('API_BASE_URL');
  if (override.isNotEmpty) return override;
  
  // 2. Web: utiliser l'hôte courant
  final String webHost = Uri.base.host;
  if (webHost.isNotEmpty) {
    return 'http://$webHost:8080/api';
  }
  
  // 3. Par défaut (émulateur Android)
  return 'http://10.0.2.2:8080/api';
}
```

**Endpoints définis** :
```dart
// Authentification
static const String authInscription = '/auth/inscription';
static const String authConnexion = '/auth/connexion';
static const String authVerifierSms = '/auth/verifier-sms';
static const String authProfil = '/auth/profil';

// Catégories
static const String categories = '/categories';
static String categoryById(String id) => '/categories/$id';

// Procédures
static const String procedures = '/procedures';
static const String procedureRechercher = '/procedures/rechercher';

// Notifications
static const String notifications = '/notifications';
static const String notificationsNonLues = '/notifications/non-lues';

// Signalements
static const String signalements = '/signalements';
```

**Utilisation** :
```dart
final url = ApiConfig.buildUrl(ApiConfig.authConnexion);
// Résultat: http://10.0.2.2:8080/api/auth/connexion
```

---

### 2. Service API principal

#### `lib/core/services/api_service.dart`
**Rôle** : Service principal pour effectuer les requêtes HTTP vers le backend

**Fonctionnalités** :
- Client HTTP basé sur **Dio**
- Gestion automatique des headers
- Timeouts configurables
- Logging des requêtes/réponses en mode debug
- Gestion des tokens JWT

**Configuration Dio** :
```dart
_dio = Dio(
  BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    connectTimeout: Duration(seconds: 30),
    receiveTimeout: Duration(seconds: 120),
    sendTimeout: Duration(seconds: 30),
  ),
);
```

**Méthodes disponibles** :
- `get(endpoint, {queryParameters})` : Requête GET
- `post(endpoint, {data, options})` : Requête POST
- `put(endpoint, {data})` : Requête PUT
- `delete(endpoint)` : Requête DELETE
- `getAudio(endpoint)` : GET spécial pour fichiers audio
- `setAuthToken(token)` : Ajouter le token JWT
- `removeAuthToken()` : Supprimer le token JWT

**Exemple d'utilisation** :
```dart
final response = await apiService.get(
  ApiConfig.categories,
  queryParameters: {'langue': 'fr'},
);
```

---

### 3. Services métier

#### `lib/core/services/auth_service.dart`
**Rôle** : Gestion de l'authentification et des utilisateurs

**Méthodes principales** :

##### Inscription
```dart
Future<MessageResponse> inscription({
  required String nom,
  required String prenom,
  required String telephone,
  required String email,
  required String motDePasse,
  required String confirmerMotDePasse,
})
```
- Endpoint : `POST /auth/inscription`
- Corps : JSON avec les données utilisateur
- Réponse : Message de succès ou erreur

##### Connexion par téléphone
```dart
Future<MessageResponse> connexionTelephone(String telephone)
```
- Endpoint : `POST /auth/connexion-telephone`
- Envoie un code SMS au numéro
- Réponse : Message de confirmation

##### Vérification SMS
```dart
Future<JwtResponse> verifierSms(String telephone, String code)
```
- Endpoint : `POST /auth/verifier-sms`
- Vérifie le code SMS
- Réponse : Token JWT + données utilisateur
- Sauvegarde automatique du token

##### Récupération du profil
```dart
Future<User> getProfil()
```
- Endpoint : `GET /auth/profil`
- Nécessite un token JWT valide
- Réponse : Objet User complet
- Sauvegarde en local

##### Déconnexion
```dart
Future<void> logout()
```
- Endpoint : `POST /auth/deconnexion`
- Supprime le token local
- Nettoie les données utilisateur

**Gestion du token JWT** :
```dart
// Sauvegarde
await prefs.setString('auth_token', token);
apiService.setAuthToken(token);

// Récupération
final token = await prefs.getString('auth_token');

// Suppression
await prefs.remove('auth_token');
apiService.removeAuthToken();
```

---

#### `lib/core/services/category_service.dart`
**Rôle** : Gestion des catégories de services administratifs

**Méthodes** :
```dart
// Récupérer toutes les catégories
Future<List<Category>> getCategories()

// Récupérer une catégorie par ID
Future<Category> getCategoryById(String id)
```

**Endpoints** :
- `GET /categories` : Liste des catégories
- `GET /categories/{id}` : Détails d'une catégorie

---

#### `lib/core/services/procedure_service.dart`
**Rôle** : Gestion des procédures administratives

**Méthodes principales** :
```dart
// Toutes les procédures
Future<List<Procedure>> getProcedures()

// Procédures d'une catégorie
Future<List<Procedure>> getProceduresByCategorie(String categorieId)

// Procédures d'une sous-catégorie
Future<List<Procedure>> getProceduresBySousCategorie(String sousCategorieId)

// Détails d'une procédure
Future<Procedure> getProcedureById(String id)

// Recherche
Future<List<Procedure>> searchProcedures(String query)
```

**Endpoints** :
- `GET /procedures` : Toutes les procédures
- `GET /procedures/{id}` : Détails d'une procédure
- `GET /procedures/categorie/{id}` : Procédures par catégorie
- `GET /procedures/sous-categorie/{id}` : Procédures par sous-catégorie
- `GET /procedures/rechercher?q=xxx` : Recherche

---

#### `lib/core/services/notification_service.dart`
**Rôle** : Gestion des notifications utilisateur

**Méthodes** :
```dart
// Toutes les notifications
Future<List<Notification>> getNotifications()

// Notifications non lues
Future<List<Notification>> getUnreadNotifications()

// Nombre de notifications non lues
Future<int> getUnreadCount()

// Marquer comme lue
Future<void> markAsRead(String notificationId)

// Marquer toutes comme lues
Future<void> markAllAsRead()
```

**Endpoints** :
- `GET /notifications` : Toutes les notifications
- `GET /notifications/non-lues` : Non lues uniquement
- `GET /notifications/count-non-lues` : Compteur
- `PUT /notifications/{id}/lire` : Marquer comme lue
- `PUT /notifications/lire-tout` : Tout marquer comme lu

---

#### `lib/core/services/signalement_service.dart`
**Rôle** : Gestion des signalements de problèmes

**Méthodes** :
```dart
// Créer un signalement
Future<MessageResponse> createSignalement({
  required String typeSignalement,
  required String description,
  String? procedureId,
})

// Types de signalements disponibles
Future<List<String>> getSignalementTypes()

// Mes signalements
Future<List<Signalement>> getMesSignalements()
```

**Endpoints** :
- `POST /signalements` : Créer un signalement
- `GET /signalements/types` : Types disponibles
- `GET /signalements` : Liste des signalements

---

#### `lib/core/services/profil_service.dart`
**Rôle** : Gestion du profil utilisateur

**Méthodes** :
```dart
// Récupérer le profil
Future<User> getProfil()

// Mettre à jour le profil
Future<MessageResponse> updateProfil(Map<String, dynamic> data)

// Changer le mot de passe
Future<MessageResponse> changePassword({
  required String oldPassword,
  required String newPassword,
})
```

---

#### `lib/core/services/djelia_service.dart`
**Rôle** : Service de traduction audio en langues locales

**Méthodes** :
```dart
// Traduire un texte en audio
Future<String> translateToAudio({
  required String text,
  required String targetLanguage, // 'bm', 'snk', 'ff'
  String speaker = 'default',
})

// Tester la connexion
Future<bool> testConnection()
```

**Endpoints** :
- `POST /djelia/translate` : Traduction en audio
- `GET /health` : Test de connexion

**Langues supportées** :
- `bm` : Bambara
- `snk` : Soninké
- `ff` : Peul

---

## 📦 Modèles de données

### `lib/models/user_model.dart`
```dart
class User {
  final String? id;
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String? photo;
  final DateTime? createdAt;
  
  // Méthodes
  factory User.fromJson(Map<String, dynamic> json)
  Map<String, dynamic> toJson()
}
```

### `lib/models/api_models.dart`
```dart
// Réponse avec message
class MessageResponse {
  final String message;
  final bool success;
}

// Réponse avec JWT
class JwtResponse {
  final String token;
  final String type;
  final User user;
}

// Catégorie
class Category {
  final String id;
  final String nom;
  final String description;
  final String icone;
  final List<SubCategory>? sousCategories;
}

// Procédure
class Procedure {
  final String id;
  final String titre;
  final String description;
  final List<String> documentsRequis;
  final List<String> etapes;
  final String? montant;
  final String? delai;
  final String? centreTraitement;
}
```

### `lib/models/notification_model.dart`
```dart
class NotificationModel {
  final String id;
  final String titre;
  final String message;
  final DateTime createdAt;
  final bool lue;
  final String? type;
}
```

---

## 🔄 Flux d'authentification

### 1. Inscription
```
User Input ──► SignupScreen
                    │
                    ▼
            AuthService.inscription()
                    │
                    ▼
            POST /auth/inscription
                    │
                    ▼
         MessageResponse (succès)
                    │
                    ▼
          Auto-connexion + JWT
                    │
                    ▼
           Redirect to HomeScreen
```

### 2. Connexion par téléphone + SMS
```
User enters phone ──► LoginScreen
                           │
                           ▼
             AuthService.connexionTelephone()
                           │
                           ▼
            POST /auth/connexion-telephone
                           │
                           ▼
              SMS sent (backend)
                           │
                           ▼
            SMSVerificationScreen
                           │
                User enters code
                           │
                           ▼
              AuthService.verifierSms()
                           │
                           ▼
             POST /auth/verifier-sms
                           │
                           ▼
             JwtResponse + User data
                           │
                           ▼
          Token saved + User saved
                           │
                           ▼
             Redirect to HomeScreen
```

---

## 🔐 Gestion des tokens JWT

### Sauvegarde du token
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setString('auth_token', token);
apiService.setAuthToken(token);
```

### Utilisation du token
Le token est automatiquement ajouté aux headers de toutes les requêtes :
```dart
_dio.options.headers['Authorization'] = 'Bearer $token';
```

### Vérification de connexion
```dart
Future<bool> isLoggedIn() async {
  final token = await _getToken();
  if (token != null) {
    _apiService.setAuthToken(token);
    return true;
  }
  return false;
}
```

---

## 🛠️ Configuration selon l'environnement

### Développement sur Web (localhost)
```dart
// lib/core/config/api_config.dart
// URL automatique: http://localhost:8080/api
```

### Émulateur Android
```dart
// URL par défaut: http://10.0.2.2:8080/api
// 10.0.2.2 = localhost de la machine hôte
```

### Appareil Android réel
```dart
// Modifier manuellement dans api_config.dart
return 'http://192.168.x.x:8080/api';
// Remplacer par l'IP de votre ordinateur sur le réseau local
```

### Production
```bash
flutter build apk --dart-define=API_BASE_URL=https://api.fasodocs.ml/api
```

---

## 🧪 Tests de l'API

### Écran de test Djelia
**Fichier** : `lib/views/djelia/test_djelia_screen.dart`

Permet de tester :
- Connexion au backend
- Traduction audio
- Différents speakers et langues

### Configuration URL personnalisée
**Fichier** : `lib/views/djelia/settings_screen.dart`

Permet de :
- Changer l'URL du backend
- Tester la connexion
- Voir les exemples d'URL

---

## ⚠️ Gestion des erreurs

### Codes HTTP
```dart
// Succès
200 OK - Requête réussie
201 Created - Ressource créée

// Erreurs client
400 Bad Request - Données invalides
401 Unauthorized - Token manquant/invalide
404 Not Found - Ressource introuvable

// Erreurs serveur
500 Internal Server Error - Erreur backend
503 Service Unavailable - Backend indisponible
```

### Timeouts
```dart
connectTimeout: Duration(seconds: 30)    // Connexion
receiveTimeout: Duration(seconds: 120)   // Réception (audio)
sendTimeout: Duration(seconds: 30)       // Envoi
```

### Try-Catch pattern
```dart
try {
  final response = await apiService.post(endpoint, data: data);
  if (response.statusCode == 200) {
    return MessageResponse.fromJson(response.data);
  } else {
    throw Exception(response.data['message']);
  }
} catch (e) {
  print('❌ Erreur: $e');
  rethrow;
}
```

---

## 📊 Logging

En mode debug, toutes les requêtes sont loggées :
```
🌐 Appel API: POST /auth/connexion
✅ Réponse API: 200 - OK
ou
❌ Erreur API POST /auth/connexion: DioException...
```

---

## 🔗 Ressources

- **Backend Spring Boot** : `http://localhost:8080`
- **API Documentation** : `http://localhost:8080/swagger-ui.html` (si configuré)
- **Base de données** : PostgreSQL

---

**Auteur** : Équipe FasoDocs  
**Dernière mise à jour** : Novembre 2024

