# 🎨 Configuration du Logo - FasoDocs

Ce document explique comment configurer et afficher le logo de l'application FasoDocs, à la fois dans l'icône de l'application et dans l'interface.

## 📱 Icône de l'application (Launcher Icon)

### Configuration dans `pubspec.yaml`

```yaml
# ========================================================================================
# CONFIGURATION DE L'ICÔNE DE L'APPLICATION (Logo + Nom sur l'écran d'accueil)
# Logo réduit de 40% pour être visible en entier même sur les icônes rondes
# ========================================================================================
flutter_launcher_icons:
  android: true                                      # Générer pour Android
  ios: true                                          # Générer pour iOS
  image_path: "assets/images/FasoDocs 1.png"        # Chemin vers le logo
  
  # Icône adaptative Android (API 26+)
  adaptive_icon_background: "#FFFFFF"                # Fond blanc
  adaptive_icon_foreground: "assets/images/FasoDocs 1.png"  # Logo au premier plan
  adaptive_icon_padding: 40                          # 40% de padding autour du logo
  
  # Configuration iOS
  remove_alpha_ios: true                             # Enlever la transparence pour iOS
```

### Pourquoi 40% de padding ?

Sur Android, les icônes adaptatives peuvent être affichées de différentes manières :
- 🔴 **Cercle** (Google Pixel)
- ⬜ **Carré** (Samsung)
- ⬜ **Carré arrondi** (OnePlus, Xiaomi)
- 🔶 **Squircle** (iOS-like)

Le padding de 40% garantit que le logo reste **visible en entier** quelle que soit la forme de l'icône.

### Fichier source du logo

**Emplacement** : `assets/images/FasoDocs 1.png`

**Spécifications recommandées** :
- **Format** : PNG avec transparence
- **Dimensions** : 1024x1024 px minimum
- **Résolution** : 72 DPI ou plus
- **Couleurs** : RVB (pas CMYK)

### Génération des icônes

#### 1. Première installation
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

#### 2. Après modification du logo
```bash
flutter pub run flutter_launcher_icons
```

Cette commande génère automatiquement toutes les tailles d'icônes pour :

**Android** :
- `mipmap-mdpi/ic_launcher.png` (48x48)
- `mipmap-hdpi/ic_launcher.png` (72x72)
- `mipmap-xhdpi/ic_launcher.png` (96x96)
- `mipmap-xxhdpi/ic_launcher.png` (144x144)
- `mipmap-xxxhdpi/ic_launcher.png` (192x192)
- Icônes adaptatives avec foreground et background séparés

**iOS** :
- Toutes les tailles requises dans `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Fichiers générés

```
android/app/src/main/res/
├── mipmap-mdpi/
│   └── ic_launcher.png
├── mipmap-hdpi/
│   └── ic_launcher.png
├── mipmap-xhdpi/
│   └── ic_launcher.png
├── mipmap-xxhdpi/
│   └── ic_launcher.png
├── mipmap-xxxhdpi/
│   └── ic_launcher.png
├── mipmap-anydpi-v26/
│   └── ic_launcher.xml
└── drawable-*/
    └── ic_launcher_foreground.png
```

### Nom de l'application sous l'icône

Configuré dans `android/app/src/main/AndroidManifest.xml` :

```xml
<application
    android:label="FasoDocs"
    android:icon="@mipmap/ic_launcher">
```

**"FasoDocs"** apparaîtra sous l'icône sur l'écran d'accueil.

---

## 🖼️ Affichage du logo dans l'application

### 1. Écran Splash (Splash Screen)

**Fichier** : `lib/views/splash/splash_screen.dart`

```dart
// LOGO FASODOCS - Affiché au centre de l'écran
Image.asset(
  'assets/images/FasoDocs 1.png',
  width: logoSize,              // 70% de la largeur de l'écran
  fit: BoxFit.contain,          // Garde les proportions
),

SizedBox(height: screenWidth * 0.02),

// TEXTE "FasoDocs" en dessous
Text(
  'FasoDocs',
  style: TextStyle(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    color: textColor,
    letterSpacing: 0.5,
  ),
),
```

**Taille du logo** : 70% de la largeur de l'écran
```dart
final logoSize = screenWidth * 0.7;  // 70% responsive
```

**Avantages** :
- ✅ Logo affiché en entier
- ✅ Responsive (s'adapte à toutes les tailles d'écran)
- ✅ Garde les proportions originales
- ✅ Centre parfait (vertical et horizontal)

### 2. Widget réutilisable

**Fichier** : `lib/core/widgets/faso_docs_logo.dart`

Pour réutiliser le logo ailleurs dans l'app :

```dart
class FasoDocsLogo extends StatelessWidget {
  final double size;
  final bool showText;
  
  const FasoDocsLogo({
    super.key,
    this.size = 100.0,
    this.showText = true,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/FasoDocs 1.png',
          width: size,
          fit: BoxFit.contain,
        ),
        if (showText) ...[
          SizedBox(height: size * 0.05),
          Text(
            'FasoDocs',
            style: TextStyle(
              fontSize: size * 0.2,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}
```

**Utilisation** :
```dart
// Logo petit sans texte
FasoDocsLogo(size: 50, showText: false)

// Logo moyen avec texte
FasoDocsLogo(size: 120)

// Logo grand avec texte
FasoDocsLogo(size: 200)
```

---

## 🎯 Déclaration des assets

Dans `pubspec.yaml` :

```yaml
flutter:
  uses-material-design: true
  
  assets:
    - assets/images/              # Tous les fichiers du dossier
```

Cette déclaration permet d'accéder à tous les fichiers dans `assets/images/` :
- `FasoDocs 1.png` (logo principal)
- Autres images de l'application

---

## 🔧 Résolution des problèmes courants

### Le logo ne s'affiche pas

**Vérifications** :
1. Le fichier existe à `assets/images/FasoDocs 1.png`
2. Le dossier assets est déclaré dans `pubspec.yaml`
3. Relancer `flutter pub get`
4. Hot restart (pas hot reload) : `r` dans le terminal

### Le logo est déformé

**Solution** : Utiliser `BoxFit.contain`
```dart
Image.asset(
  'assets/images/FasoDocs 1.png',
  fit: BoxFit.contain,  // Garde les proportions
)
```

**Options de BoxFit** :
- `BoxFit.contain` : Garde les proportions, peut laisser des espaces blancs ✅
- `BoxFit.cover` : Remplit l'espace, peut rogner l'image ❌
- `BoxFit.fill` : Étire l'image pour remplir ❌
- `BoxFit.fitWidth` : Adapte à la largeur
- `BoxFit.fitHeight` : Adapte à la hauteur

### Le logo est trop petit/grand

**Ajuster la taille** :
```dart
// Dans splash_screen.dart, ligne 85
final logoSize = screenWidth * 0.7;  // Changer 0.7 (70%)

// Valeurs recommandées :
// - 0.5 = 50% (petit)
// - 0.7 = 70% (moyen) ✅
// - 0.9 = 90% (grand)
```

### L'icône de l'app ne change pas

**Solutions** :
1. Désinstaller l'application de l'appareil
2. Nettoyer le build : `flutter clean`
3. Régénérer les icônes : `flutter pub run flutter_launcher_icons`
4. Réinstaller : `flutter run`

### Le logo a un fond noir au lieu de transparent

**Problème** : Le PNG n'a pas de transparence

**Solution** :
1. Ouvrir le logo dans un éditeur d'image (Photoshop, GIMP, etc.)
2. Supprimer le fond
3. Exporter en PNG avec transparence (canal alpha)
4. Remplacer `assets/images/FasoDocs 1.png`
5. Régénérer : `flutter pub run flutter_launcher_icons`

---

## 📐 Dimensions recommandées par plateforme

### Icône Android (avant génération)
- **Taille source** : 1024x1024 px
- **Format** : PNG avec transparence
- **Marges** : Le padding de 40% est appliqué automatiquement

### Icône iOS (avant génération)
- **Taille source** : 1024x1024 px
- **Format** : PNG **sans transparence** (fond blanc)
- `remove_alpha_ios: true` gère cela automatiquement

### Logo dans l'app (Splash Screen)
- **Taille** : Flexible (responsive)
- **Format** : PNG avec transparence
- **Proportions** : Conservées avec `BoxFit.contain`

---

## 🎨 Personnalisation avancée

### Ajouter une ombre au logo

```dart
Container(
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  ),
  child: Image.asset(
    'assets/images/FasoDocs 1.png',
    width: logoSize,
    fit: BoxFit.contain,
  ),
),
```

### Ajouter une animation au logo

```dart
import 'package:flutter_animate/flutter_animate.dart';

Image.asset(
  'assets/images/FasoDocs 1.png',
  width: logoSize,
  fit: BoxFit.contain,
)
.animate()
.fadeIn(duration: 600.ms)
.scale(duration: 600.ms, curve: Curves.elasticOut);
```

### Couleur de fond personnalisée pour l'icône adaptative

Dans `pubspec.yaml` :
```yaml
adaptive_icon_background: "#2E7D32"  # Vert
# ou
adaptive_icon_background: "#FFD700"  # Doré
```

---

## 📊 Checklist finale

Avant de publier l'application, vérifier :

- [ ] Le logo `FasoDocs 1.png` est en 1024x1024 px
- [ ] Le logo a un fond transparent (sauf iOS)
- [ ] `flutter pub run flutter_launcher_icons` exécuté avec succès
- [ ] L'icône s'affiche correctement sur un appareil Android
- [ ] L'icône s'affiche correctement sur un appareil iOS (si applicable)
- [ ] Le splash screen affiche le logo en entier
- [ ] Le nom "FasoDocs" apparaît sous l'icône
- [ ] Le logo n'est pas déformé
- [ ] Le logo est centré

---

## 🔗 Ressources

- **Plugin flutter_launcher_icons** : https://pub.dev/packages/flutter_launcher_icons
- **Adaptive Icons Android** : https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive
- **Icon Guidelines iOS** : https://developer.apple.com/design/human-interface-guidelines/app-icons

---

## 💡 Conseils de design

### Pour un logo professionnel :

1. **Simplicité** : Éviter trop de détails
2. **Contraste** : Bien visible sur fond clair ET sombre
3. **Lisibilité** : Reconnaissable même en petite taille
4. **Originalité** : Unique et mémorable
5. **Cohérence** : Respecter l'identité visuelle

### Outils de création recommandés :

- **Adobe Illustrator** : Vectoriel professionnel
- **Figma** : Design collaboratif en ligne
- **Canva** : Création simplifiée
- **GIMP** : Gratuit et open-source
- **Inkscape** : Vectoriel gratuit

---

**Auteur** : Équipe FasoDocs  
**Dernière mise à jour** : Novembre 2024

