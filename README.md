# FasoDocs - Application Mobile

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue)
![License](https://img.shields.io/badge/license-Private-red)

## 📱 À propos

**FasoDocs** est une application mobile qui simplifie les démarches administratives au Mali. Elle permet aux citoyens maliens d'accéder facilement aux informations sur les procédures administratives, de localiser les centres de service à proximité et de suivre leurs démarches.

## ✨ Fonctionnalités principales

### 🔐 Authentification
- Inscription avec téléphone, email et mot de passe
- Connexion par téléphone avec vérification SMS
- Gestion sécurisée des tokens JWT
- Profil utilisateur modifiable

### 📋 Catégories de services
- **Identité et citoyenneté** : Extraits d'actes, CNI, passeport
- **Création d'entreprise** : Registre de commerce, NIF
- **Documents automobiles** : Permis, carte grise
- **Services fonciers** : Titres de propriété
- **Eau et électricité** : Raccordements SOMAGEP et EDM
- **Justice** : Services judiciaires
- **Impôts et douanes** : Services fiscaux

### 🌍 Localisation
- Recherche des centres de service à proximité avec **Mapbox**
- Affichage sur carte interactive
- Calcul de distance et itinéraire
- Géolocalisation en temps réel

### 🔊 Accessibilité
- **Djelia** : Service de traduction audio en langues locales (Bambara, Soninké, Peul)
- Lecture audio des procédures administratives
- Interface multilingue (Français/Anglais)

### 📬 Notifications
- Système de notifications push
- Notifications lors de l'inscription
- Suivi des mises à jour de démarches

### 🆘 Support
- Signalement de problèmes
- Centre d'aide et support
- Historique des démarches

## 🏗️ Architecture

L'application suit l'architecture **MVC (Model-View-Controller)** :

```
lib/
├── main.dart                    # Point d'entrée de l'application
├── models/                      # 📦 Modèles de données
│   ├── user_model.dart
│   ├── document_model.dart
│   ├── notification_model.dart
│   └── api_models.dart
├── views/                       # 🎨 Interfaces utilisateur
│   ├── splash/
│   ├── onboarding/
│   ├── auth/
│   ├── home/
│   ├── profile/
│   ├── category/
│   └── ...
├── controllers/                 # 🎮 Logique métier
│   ├── user_controller.dart
│   ├── document_controller.dart
│   └── notification_controller.dart
├── core/                        # 🔧 Services et configuration
│   ├── config/                  # Configuration API
│   ├── services/                # Services (API, Auth, Mapbox, etc.)
│   ├── theme/                   # Thème et style
│   └── widgets/                 # Widgets réutilisables
└── locale/                      # 🌐 Internationalisation
```

## 🔧 Technologies utilisées

### Frontend
- **Flutter** 3.0+ (Dart)
- **Provider** : Gestion d'état
- **Dio** : Client HTTP
- **Mapbox** : Cartographie et géolocalisation
- **Just Audio** : Lecture audio

### Backend
- **Spring Boot** (Java) - API REST
- **PostgreSQL** - Base de données
- **JWT** - Authentification
- **Djelia API** - Service de traduction audio

### Packages principaux
```yaml
dependencies:
  # UI & Design
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  lottie: ^2.7.0
  
  # State Management
  provider: ^6.1.1
  flutter_bloc: ^8.1.3
  
  # HTTP & API
  http: ^1.2.0
  dio: ^5.4.0
  
  # Navigation
  go_router: ^12.1.3
  
  # Maps & Location
  mapbox_maps_flutter: ^2.12.0
  geolocator: ^14.0.2
  permission_handler: ^12.0.1
  
  # Audio
  just_audio: ^0.9.40
  
  # Storage
  shared_preferences: ^2.2.2
```

## 🚀 Installation et lancement

### Prérequis
- Flutter SDK 3.0+
- Android Studio / VS Code
- Émulateur Android/iOS ou appareil physique

### Étapes

1. **Cloner le projet**
```bash
git clone https://github.com/votre-repo/FasoDocsFrontend.git
cd FasoDocsFrontend
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configurer l'API Backend**
   
   Modifier `lib/core/config/api_config.dart` selon votre environnement :
   - Web : `http://localhost:8080/api`
   - Émulateur Android : `http://10.0.2.2:8080/api`
   - Appareil réel : `http://192.168.x.x:8080/api`

4. **Générer les icônes de l'application** (optionnel)
```bash
flutter pub run flutter_launcher_icons
```

5. **Lancer l'application**
```bash
# En développement
flutter run

# Version release
flutter build apk --release
```

## 📱 Écrans principaux

1. **Splash Screen** : Logo FasoDocs avec animation
2. **Onboarding** : Présentation de l'application (3 écrans)
3. **Authentification** : Connexion et inscription
4. **Accueil** : Catégories de services et recherche
5. **Détails procédure** : Informations détaillées avec documents requis, montants, centres
6. **Carte des centres** : Localisation des centres de service
7. **Profil** : Gestion du compte utilisateur
8. **Notifications** : Centre de notifications
9. **Paramètres** : Configuration de l'application

## 🌐 Multilingue

L'application supporte :
- **Français** (par défaut)
- **Anglais**
- **Audio en langues locales** : Bambara, Soninké, Peul (via Djelia)

Configuration dans `lib/locale/` :
- `locale_fr.dart` : Traductions françaises
- `locale_en.dart` : Traductions anglaises
- `locale_provider.dart` : Gestion des langues

## 🎨 Thème

L'application dispose d'un thème clair et sombre configurables :
- Thème clair avec couleurs inspirées du Mali
- Thème sombre pour économie d'énergie
- Changement dynamique via `ThemeModeProvider`

Configuration dans `lib/core/theme/mali_theme.dart`

## 🔐 Sécurité

- Tokens JWT pour l'authentification
- Stockage sécurisé avec `SharedPreferences`
- Validation des données côté client et serveur
- Timeouts configurables pour les requêtes API

## 📖 Documentation complémentaire

- [📡 Intégration Backend](INTEGRATION_BACKEND.md) : Documentation complète de l'intégration avec le backend Spring Boot
- [🗺️ Intégration Mapbox](INTEGRATION_MAPBOX.md) : Configuration et utilisation de Mapbox
- [🎨 Configuration du logo](CONFIGURATION_LOGO.md) : Comment afficher le logo de l'application

## 👥 Contributeurs

- **Équipe FasoDocs**

## 📄 Licence

Projet privé - Tous droits réservés

## 📞 Support

Pour toute question ou problème :
- Email : support@fasodocs.ml
- Dans l'app : Menu → Aide et support

---

**Version** : 1.0.0+1  
**Dernière mise à jour** : Novembre 2024

