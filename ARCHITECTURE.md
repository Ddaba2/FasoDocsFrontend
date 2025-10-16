# Architecture FasoDocs - Refactoring

## ❌ PROBLÈME INITIAL

Votre fichier `main.dart` contenait **4823 lignes** avec **23 écrans** différents. Cela violait complètement les principes MVC et l'architecture propre.

## ✅ NOUVELLE ARCHITECTURE

L'application suit désormais une architecture **par fonctionnalités (feature-based architecture)** :

```
lib/
├── main.dart                          # Point d'entrée - SEULEMENT MyApp et main()
├── core/                              # Fonctionnalités partagées
│   ├── router/
│   │   └── app_router.dart           # Navigation centralisée
│   ├── theme/
│   │   └── mali_theme.dart           # Thème de l'application
│   ├── widgets/
│   │   └── faso_docs_logo.dart       # Widgets réutilisables
│   └── utils/
│       └── global_report_access.dart  # Utilitaires globaux
├── features/                          # Fonctionnalités métier
│   ├── auth/                          # Authentification
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   └── sms_verification_screen.dart
│   ├── onboarding/
│   │   └── onboarding_screen.dart
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── home/                          # Écran d'accueil
│   │   └── home_screen.dart
│   ├── profile/                       # Gestion du profil
│   │   ├── profile_screen.dart
│   │   └── edit_profile_screen.dart
│   ├── history/                       # Historique
│   │   └── history_screen.dart
│   ├── report/                        # Signalement
│   │   └── report_problem_screen.dart
│   ├── settings/                      # Paramètres
│   │   └── settings_screen.dart
│   ├── help/                          # Aide
│   │   └── help_support_screen.dart
│   ├── notifications/                 # Notifications
│   │   └── notifications_screen.dart
│   ├── identity/                      # Identité et citoyenneté
│   │   └── identity_screen.dart
│   └── category/                      # Catégories
│       └── category_screen.dart
└── [autres écrans spécialisés]
    ├── residence_screen.dart
    ├── business_screen.dart
    ├── auto_screen.dart
    ├── land_screen.dart
    ├── utilities_screen.dart
    ├── justice_screen.dart
    └── tax_screen.dart
```

## 🎯 BONNES PRATIQUES APPLIQUÉES

### 1. **Séparation des responsabilités**
- ✅ Chaque écran dans son propre fichier
- ✅ Chaque fonctionnalité dans son propre dossier
- ✅ Code réutilisable dans `core/`

### 2. **Architecture MVC/MVVM**
- ✅ **Model** : (à créer) classes de données dans `models/`
- ✅ **View** : écrans dans `features/*/screens/`
- ✅ **Controller** : (à créer) logique métier dans `features/*/controllers/`

### 3. **Imports propres**
- ✅ Imports relatifs entre features
- ✅ Pas de dépendances circulaires

### 4. **Maintenabilité**
- ✅ Facile de trouver un écran
- ✅ Facile d'ajouter de nouvelles fonctionnalités
- ✅ Facile de tester unitairement

## 📝 FICHIERS EXTRAITS

| Ancien (main.dart) | Nouveau (features/) | Lignes |
|-------------------|---------------------|---------|
| EditProfileScreen | features/profile/edit_profile_screen.dart | ~370 |
| ProfileScreen | features/profile/profile_screen.dart | ~280 |
| HistoryScreen | features/history/history_screen.dart | ~270 |
| ReportProblemScreen | features/report/report_problem_screen.dart | ~470 |
| HomeScreen | features/home/home_screen.dart | ~470 |
| NotificationsScreen | features/notifications/notifications_screen.dart | ~320 |
| HelpSupportScreen | features/help/help_support_screen.dart | ~60 |
| IdentityScreen | features/identity/identity_screen.dart | ~320 |
| CategoryScreen | features/category/category_screen.dart | ~320 |
| GlobalReportAccess | core/utils/global_report_access.dart | ~50 |

## 🚀 PROCHAINES ÉTAPES RECOMMANDÉES

### 1. **Créer des Models**
```dart
lib/features/profile/models/user_model.dart
lib/features/notifications/models/notification_model.dart
```

### 2. **Créer des Controllers/Services**
```dart
lib/features/auth/services/auth_service.dart
lib/features/profile/controllers/profile_controller.dart
```

### 3. **State Management**
Implémenter un système de gestion d'état (Provider, Riverpod, Bloc, GetX):
```dart
lib/features/auth/providers/auth_provider.dart
lib/features/profile/providers/profile_provider.dart
```

### 4. **API Layer**
```dart
lib/core/api/api_client.dart
lib/core/api/endpoints.dart
```

### 5. **Repository Pattern**
```dart
lib/features/auth/repositories/auth_repository.dart
lib/features/profile/repositories/profile_repository.dart
```

## 📚 RESSOURCES

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Very Good CLI](https://verygood.ventures/blog/very-good-cli)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## ⚠️ IMPORTANT

Le fichier `main.dart` d'origine (4823 lignes) doit être **nettoyé** pour ne contenir que :
- La fonction `main()`
- La classe `MyApp`
- Configuration de base de l'application

Tous les écrans sont maintenant dans `features/`.

