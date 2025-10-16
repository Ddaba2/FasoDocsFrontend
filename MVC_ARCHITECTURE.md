# Architecture MVC - FasoDocs

## Vue d'ensemble

L'application FasoDocs suit maintenant le modèle architectural **MVC (Model-View-Controller)** pour une meilleure organisation du code et une séparation claire des responsabilités.

## Structure des dossiers

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── models/                   # Modèles de données (M)
│   ├── models.dart          # Export de tous les modèles
│   ├── user_model.dart      # Modèle utilisateur
│   ├── document_model.dart  # Modèle document
│   └── notification_model.dart # Modèle notification
├── views/                    # Vues/Écrans (V)
│   ├── splash/              # Écran de démarrage
│   ├── onboarding/          # Écran d'introduction
│   ├── auth/                # Écrans d'authentification
│   ├── home/                # Écran d'accueil
│   ├── profile/             # Écrans de profil
│   ├── history/             # Écran d'historique
│   ├── report/              # Écran de signalement
│   ├── settings/            # Écran de paramètres
│   ├── help/                # Écran d'aide
│   ├── notifications/       # Écran de notifications
│   ├── identity/            # Écrans d'identité
│   └── category/            # Écrans de catégories
└── controllers/              # Contrôleurs (C)
    ├── controllers.dart     # Export de tous les contrôleurs
    ├── user_controller.dart # Contrôleur utilisateur
    ├── document_controller.dart # Contrôleur document
    ├── notification_controller.dart # Contrôleur notification
    └── report_controller.dart # Contrôleur signalement
```

## Composants MVC

### 1. Models (Modèles) - `lib/models/`

Les modèles représentent les données et la logique métier de l'application.

#### UserModel
- Gère les informations utilisateur (nom, email, téléphone, photo)
- Méthodes de validation et conversion JSON
- Gestion des données de profil

#### DocumentModel
- Représente les documents administratifs
- Statuts et types de documents
- Gestion des frais et références

#### NotificationModel
- Gère les notifications système
- Types et priorités de notifications
- Métadonnées et statuts de lecture

### 2. Views (Vues) - `lib/views/`

Les vues représentent l'interface utilisateur et l'affichage des données.

- **SplashScreen** : Écran de démarrage
- **OnboardingScreen** : Introduction à l'application
- **LoginScreen/SignupScreen** : Authentification
- **HomeScreen** : Écran principal
- **ProfileScreen** : Gestion du profil
- **Et tous les autres écrans...**

### 3. Controllers (Contrôleurs) - `lib/controllers/`

Les contrôleurs gèrent la logique métier et la communication entre les modèles et les vues.

#### UserController
- Authentification et gestion des sessions
- Opérations CRUD sur le profil utilisateur
- Validation des données utilisateur
- Gestion des images de profil

#### DocumentController
- Gestion des documents administratifs
- Suivi des statuts et traitements
- Calculs de statistiques et frais
- Opérations CRUD sur les documents

#### NotificationController
- Gestion des notifications
- Marquage comme lu/non lu
- Filtrage et tri des notifications
- Statistiques de notifications

#### ReportController
- Gestion des signalements de problèmes
- Validation des données de signalement
- Soumission des rapports

## Avantages de cette architecture

### 1. Séparation des responsabilités
- **Models** : Gestion des données
- **Views** : Interface utilisateur
- **Controllers** : Logique métier

### 2. Réutilisabilité
- Les modèles peuvent être utilisés dans plusieurs vues
- Les contrôleurs peuvent gérer plusieurs vues
- Code modulaire et maintenable

### 3. Testabilité
- Chaque composant peut être testé indépendamment
- Logique métier isolée dans les contrôleurs
- Modèles de données bien définis

### 4. Évolutivité
- Facile d'ajouter de nouvelles fonctionnalités
- Modification d'un composant sans affecter les autres
- Structure claire pour les nouveaux développeurs

## Utilisation

### Import des modèles
```dart
import '../models/models.dart';
```

### Import des contrôleurs
```dart
import '../controllers/controllers.dart';
```

### Exemple d'utilisation dans une vue
```dart
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final UserController _userController = UserController();
  final DocumentController _documentController = DocumentController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await _userController.loadUserData();
    await _documentController.loadUserDocuments(_userController.currentUser?.id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Interface utilisateur utilisant les données des contrôleurs
    );
  }
}
```

## Migration depuis l'ancienne structure

L'application a été migrée depuis une structure monolithique vers MVC :

1. **Avant** : Tout dans `main.dart` (4823 lignes)
2. **Après** : Structure MVC organisée et modulaire

### Fichiers déplacés
- Tous les écrans de `lib/features/` vers `lib/views/`
- Logique métier extraite vers `lib/controllers/`
- Modèles de données créés dans `lib/models/`

### Imports mis à jour
- `main.dart` utilise maintenant les imports depuis `views/`
- Les contrôleurs sont accessibles via `controllers.dart`
- Les modèles sont accessibles via `models.dart`

## Bonnes pratiques

1. **Models** : Ne contiennent que les données et la logique de validation
2. **Views** : Se concentrent uniquement sur l'affichage
3. **Controllers** : Gèrent la logique métier et la communication
4. **Imports** : Utiliser les fichiers d'export pour un code plus propre
5. **Nommage** : Suivre les conventions Dart/Flutter

Cette architecture MVC garantit une application maintenable, évolutive et facile à comprendre.
