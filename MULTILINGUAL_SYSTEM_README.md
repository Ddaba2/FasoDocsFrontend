# 🌍 Système Multilingue FasoDocs

## Vue d'ensemble

FasoDocs supporte maintenant **2 langues** :
- 🇫🇷 **Français** (défaut)
- 🇬🇧 **English**

Le système synchronise automatiquement la langue choisie avec votre backend via le header `Accept-Language`.

---

## 📁 Architecture du système

```
lib/
├── providers/
│   └── language_provider.dart       # 🔥 Provider principal de gestion de langue
├── locale/
│   ├── locale_fr.dart                # Traductions françaises
│   ├── locale_en.dart                # Traductions anglaises
│   ├── locale_helper.dart            # Helper pour accéder aux traductions
│   └── locale_provider.dart          # Provider simple (ancien)
├── core/services/
│   └── api_service.dart              # 🔥 Service API avec Accept-Language automatique
└── views/settings/
    └── settings_screen.dart          # 🔥 Écran de paramètres avec sélecteur de langue
```

---

## 🚀 Fonctionnalités

### 1. **Persistance locale**
- La langue choisie est sauvegardée dans `SharedPreferences`
- Elle persiste même après fermeture de l'application

### 2. **Synchronisation backend**
- Mise à jour automatique du profil utilisateur
- Envoi du header `Accept-Language` sur toutes les requêtes API
- Le backend reçoit automatiquement la langue préférée

### 3. **UI moderne**
- Sélecteur avec drapeaux 🇫🇷 🇬🇧
- Badge de langue actuelle avec drapeau + nom
- Animation de confirmation avec SnackBar

---

## 📝 Comment utiliser

### Changer la langue dans l'interface

1. Ouvrir **Paramètres** depuis le menu
2. Cliquer sur la ligne **Langue**
3. Sélectionner la langue souhaitée
4. ✅ Confirmation automatique

### Accéder à la langue dans le code

```dart
// Obtenir le provider
final languageProvider = Provider.of<LanguageProvider>(context);

// Obtenir le code de la langue actuelle
String currentLang = languageProvider.currentLanguage; // 'fr' ou 'en'

// Obtenir le nom de la langue
String langName = languageProvider.languageName; // 'Français' ou 'English'

// Obtenir le drapeau
String flag = languageProvider.languageFlag; // '🇫🇷' ou '🇬🇧'

// Changer la langue programmatiquement
await languageProvider.changeLanguage('en', userToken);
```

### Utiliser les traductions

```dart
import '../../locale/locale_helper.dart';

// Dans un widget
Text(LocaleHelper.getText(context, 'welcome')),
Text(LocaleHelper.getText(context, 'paramettre')),
Text(LocaleHelper.getText(context, 'birthCertificate')),
```

---

## 🔧 Configuration Backend

### Header Accept-Language automatique

Toutes vos requêtes API incluent maintenant automatiquement le header :
```
Accept-Language: fr   (ou 'en')
```

### Endpoint de mise à jour

Le système appelle automatiquement l'endpoint suivant lors du changement de langue :

```http
PUT /api/auth/profil
Authorization: Bearer {token}
Content-Type: application/json

{
  "languePreferee": "fr"
}
```

**⚠️ À FAIRE** : Mettez à jour l'URL dans `lib/providers/language_provider.dart` ligne 54 :
```dart
Uri.parse('http://VOTRE_IP:8080/api/auth/profil'),
```

---

## 📱 Test du système

### Vérification manuelle

1. **Lancer l'application**
   ```bash
   flutter run
   ```

2. **Tester le changement de langue**
   - Ouvrir les Paramètres
   - Changer la langue (Français ↔ English)
   - Vérifier que l'interface se met à jour instantanément

3. **Vérifier les requêtes API**
   - Regarder les logs de la console
   - Vous devriez voir : `🌐 Accept-Language: fr` (ou en)

4. **Tester la persistance**
   - Changer la langue
   - Fermer et relancer l'app
   - La langue doit être conservée

### Logs attendus

```
✅ Langue chargée: fr
🌐 Accept-Language: fr
✅ Langue changée: en
✅ Langue mise à jour sur le backend: en
🌐 Accept-Language: en
```

---

## 🎨 Personnalisation

### Ajouter une nouvelle langue

1. **Créer le fichier de traductions**
   ```dart
   // lib/locale/locale_xx.dart
   class LocaleXx {
     static const String appName = 'FasoDocs';
     static const String paramettre = 'Traduction...';
     // ...
   }
   ```

2. **Ajouter dans LanguageProvider**
   ```dart
   final List<Map<String, String>> languages = [
     {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
     {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
     {'code': 'xx', 'name': 'Nouvelle Langue', 'flag': '🏳️'},  // 🔥
   ];
   ```

3. **Ajouter dans LocaleHelper**
   ```dart
   if (locale.languageCode == 'xx') {
     return _getNewLanguageText(key);
   }
   ```

4. **Ajouter dans main.dart**
   ```dart
   supportedLocales: const [
     Locale('fr'),
     Locale('en'),
     Locale('xx'),  // 🔥
   ],
   ```

---

## 🐛 Dépannage

### La langue ne change pas

1. Vérifier que le LanguageProvider est bien enregistré dans `main.dart`
2. Vérifier les logs dans la console
3. Nettoyer et reconstruire :
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Le backend ne reçoit pas la langue

1. Vérifier l'URL dans `language_provider.dart`
2. Vérifier que le token JWT est valide
3. Regarder les logs réseau :
   ```dart
   print('🌐 Accept-Language: $language');
   ```

### Les traductions manquent

1. Ajouter les clés manquantes dans `locale_xx.dart`
2. Ajouter dans `LocaleHelper._getXxxText()`
3. La clé elle-même s'affichera si la traduction manque

---

## ✅ Checklist d'intégration

- [x] LanguageProvider créé
- [x] ApiService avec Accept-Language automatique
- [x] UI avec drapeaux dans Settings
- [x] Persistance avec SharedPreferences
- [x] Synchronisation backend
- [ ] **Mettre à jour l'URL backend** dans `language_provider.dart`
- [ ] Tester sur Android
- [ ] Tester sur iOS
- [ ] Vérifier la réception backend

---

## 📚 Ressources

- **Provider package** : https://pub.dev/packages/provider
- **SharedPreferences** : https://pub.dev/packages/shared_preferences
- **Dio interceptors** : https://pub.dev/packages/dio

---

## 🎉 Conclusion

Votre application FasoDocs dispose maintenant d'un système multilingue complet avec :
- ✅ 2 langues (Français, English)
- ✅ Persistance locale
- ✅ Synchronisation backend automatique
- ✅ UI moderne avec drapeaux
- ✅ Header Accept-Language sur toutes les requêtes

**Prochaine étape** : Mettez à jour l'URL de votre backend et testez ! 🚀

