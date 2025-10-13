# FasoDocs - Application Mobile Mali

## 🎯 Description
Application mobile pour simplifier les démarches administratives au Mali. FasoDocs permet aux citoyens maliens d'accéder facilement aux informations sur les procédures administratives, les tarifs officiels et les guides pas-à-pas.

## 🚀 Fonctionnalités Implémentées

### ✅ Écrans Créés
- **Splash Screen** : Écran de démarrage avec logo FasoDocs
- **Onboarding** : 3 écrans d'introduction avec animations
- **Connexion** : Formulaire de connexion avec validation
- **Inscription** : Formulaire d'inscription complet
- **Navigation** : Système de navigation entre écrans

### ✅ Design System
- **Couleurs Mali** : Vert, Jaune, Rouge du drapeau malien
- **Logo FasoDocs** : Logo avec les couleurs nationales
- **Thème** : Design moderne et accessible
- **Typographie** : Police Poppins pour une lisibilité optimale

## 📱 Structure du Projet

```
lib/
├── core/
│   ├── theme/
│   │   └── mali_theme.dart          # Thème et couleurs Mali
│   ├── widgets/
│   │   └── faso_docs_logo.dart      # Widget logo FasoDocs
│   └── router/
│       └── app_router.dart          # Navigation entre écrans
├── features/
│   ├── splash/
│   │   └── splash_screen.dart       # Écran de démarrage
│   ├── onboarding/
│   │   └── onboarding_screen.dart   # Écrans d'introduction
│   └── auth/
│       ├── login_screen.dart        # Écran de connexion
│       └── signup_screen.dart       # Écran d'inscription
└── main.dart                        # Point d'entrée de l'app
```

## 🎨 Design Reproduit

### Splash Screen
- Logo FasoDocs centré avec animation
- Fond blanc épuré
- Animation de fade-in et scale

### Onboarding (3 écrans)
1. **Écran 1** : "Obtenir un document administratif au Mali ?"
2. **Écran 2** : "Vos démarches administratives sans complexité"
3. **Écran 3** : "La complexité, nous la gérons. La simplicité, nous vous la livrons"

### Connexion
- Formulaire avec email et mot de passe
- Validation des champs
- Bouton de connexion avec loading
- Lien vers inscription

### Inscription
- Formulaire complet (téléphone, email, mot de passe)
- Confirmation mot de passe
- Checkbox conditions d'utilisation
- Validation complète

## 🛠️ Technologies Utilisées

- **Flutter** : Framework de développement mobile
- **Dart** : Langage de programmation
- **Material Design 3** : Design system Google
- **Google Fonts** : Police Poppins
- **Animations** : Animations fluides entre écrans

## 📦 Dépendances

```yaml
dependencies:
  flutter: sdk
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  lottie: ^2.7.0
  flutter_animate: ^4.3.0
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  go_router: ^12.1.3
  shared_preferences: ^2.2.2
  intl: ^0.18.1
```

## 🚀 Installation et Lancement

1. **Cloner le projet**
   ```bash
   git clone [url-du-repo]
   cd FasoDocs_flutter
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Lancer l'application**
   ```bash
   flutter run
   ```

## 📸 Images Nécessaires

Pour que l'application fonctionne parfaitement, ajoutez ces images dans `assets/images/` :

- `onboarding1.jpg` - Femme avec documents
- `onboarding2.jpg` - Femme souriante avec smartphone
- `onboarding3.jpg` - Arrière-plan écran sombre
- `login_background.jpg` - Arrière-plan connexion
- `signup_background.jpg` - Arrière-plan inscription

## 🎯 Prochaines Étapes

1. **Ajouter les vraies images** depuis le design Figma
2. **Implémenter la logique métier** (authentification, API)
3. **Ajouter les écrans principaux** (accueil, démarches, etc.)
4. **Intégrer la base de données** locale et cloud
5. **Ajouter les fonctionnalités** (recherche, favoris, etc.)

## 📱 Compatibilité

- **Android** : API 21+ (Android 5.0+)
- **iOS** : iOS 11.0+
- **Orientation** : Portrait uniquement
- **Langues** : Français, Bambara (préparé)

## 🎨 Couleurs Mali

```dart
static const Color vert = Color(0xFF14B53A);   // Vert Mali
static const Color jaune = Color(0xFFFCD116);  // Jaune Mali
static const Color rouge = Color(0xFFCE1126);  // Rouge Mali
```

## 📞 Support

Pour toute question ou problème :
- Vérifiez que toutes les images sont présentes
- Assurez-vous que Flutter est correctement installé
- Consultez les logs pour les erreurs éventuelles

---

**FasoDocs** - Simplifions les démarches administratives au Mali 🇲🇱
