# 🚀 Guide d'Intégration API FasoDocs

## ✅ Structure créée pour votre API Spring Boot

Votre application Flutter est maintenant **100% prête** à communiquer avec votre backend Spring Boot avec les **46 endpoints documentés**.

### 📁 Services créés

1. **AuthService** - Authentification complète
2. **CategoryService** - Gestion des catégories et sous-catégories
3. **ProcedureService** - Gestion des procédures avec recherche
4. **ChatbotService** - Intégration Djelia AI
5. **NotificationService** - Gestion des notifications
6. **SignalementService** - Gestion des signalements

### 📦 Modèles créés

Tous les modèles de données sont dans `lib/models/api_models.dart` :
- `InscriptionRequest`, `ConnexionTelephoneRequest`, `VerificationSmsRequest`
- `JwtResponse`, `MessageResponse`
- `CategorieResponse`, `SousCategorieResponse`
- `ProcedureResponse` (avec références légales, étapes, documents, centres, coûts)
- `ChatRequest`, `ChatResponse`
- `TranslationRequest`, `TranslationResponse`
- `SpeakRequest`, `SpeakResponse`
- `NotificationResponse`
- `SignalementRequest`, `SignalementResponse`

---

## 🔧 Configuration rapide

### 1. Modifier l'URL du backend

Dans `lib/core/config/api_config.dart` :

```dart
static const String baseUrl = 'http://10.0.2.2:8080';
```

**URL selon l'environnement :**
- Android Emulator : `http://10.0.2.2:8080`
- iOS Simulator : `http://localhost:8080`
- Appareil physique : `http://VOTRE_IP:8080`

### 2. Vérifier que les packages sont installés

```bash
flutter pub get
```

✅ Déjà fait : les packages `http` et `dio` sont déjà installés.

---

## 💡 Exemples d'utilisation

### Exemple 1 : Connexion par SMS

```dart
import 'package:fasodocs/core/services/auth_service.dart';

// Étape 1 : Envoyer le code SMS
try {
  final message = await authService.connexionTelephone('+22370123456');
  print(message.message); // "Code envoyé"
  
  // Étape 2 : Vérifier le code
  final jwt = await authService.verifierSms('+22370123456', '123456');
  print('Token: ${jwt.token}');
  
  // Navigation vers l'écran principal
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => HomeScreen()),
  );
} catch (e) {
  print('Erreur: $e');
}
```

### Exemple 2 : Obtenir toutes les procédures

```dart
import 'package:fasodocs/core/services/procedure_service.dart';

try {
  final procedures = await procedureService.getAllProcedures();
  print('Nombre de procédures: ${procedures.length}');
  
  procedures.forEach((p) {
    print('${p.nom} - ${p.titre}');
    // Accès aux références légales
    if (p.referencesLegales != null) {
      p.referencesLegales!.forEach((ref) {
        print('Loi: ${ref.description}');
        print('Article: ${ref.article}');
        if (ref.audioUrl != null) {
          print('Audio: ${ref.audioUrl}');
        }
      });
    }
  });
} catch (e) {
  print('Erreur: $e');
}
```

### Exemple 3 : Recherche de procédures

```dart
try {
  final procedures = await procedureService.searchProcedures('acte naissance');
  print('Trouvé ${procedures.length} procédure(s)');
} catch (e) {
  print('Erreur: $e');
}
```

### Exemple 4 : Chat avec Djelia AI

```dart
import 'package:fasodocs/core/services/chatbot_service.dart';

// Chat simple
try {
  final response = await chatbotService.chat(
    'Quelle est la procédure pour un acte de naissance?',
    'fr',
  );
  print(response.reponse);
} catch (e) {
  print('Erreur: $e');
}

// Chat avec audio bambara
try {
  final response = await chatbotService.chatAudio(
    'Comment obtenir un passeport?',
    'bambara',
  );
  print(response.reponse);
  if (response.audioUrl != null) {
    // Jouer l'audio
    print('URL audio: ${response.audioUrl}');
  }
} catch (e) {
  print('Erreur: $e');
}
```

### Exemple 5 : Traduction FR vers Bambara

```dart
try {
  final translation = await chatbotService.translateFrToBm(
    'Bonjour, comment allez-vous?',
  );
  print('Original: ${translation.texteOriginal}');
  print('Traduit: ${translation.texteTraduit}');
} catch (e) {
  print('Erreur: $e');
}
```

### Exemple 6 : Notifications

```dart
import 'package:fasodocs/core/services/notification_service.dart';

// Obtenir les notifications non lues
try {
  final notifications = await notificationService.getNonLuesNotifications();
  print('${notifications.length} notification(s) non lue(s)');
  
  // Marquer comme lue
  if (notifications.isNotEmpty) {
    await notificationService.marquerCommeLue(notifications.first.id);
  }
  
  // Compter les non lues
  final count = await notificationService.countNonLues();
  print('Total non lues: $count');
} catch (e) {
  print('Erreur: $e');
}
```

### Exemple 7 : Créer un signalement

```dart
import 'package:fasodocs/core/services/signalement_service.dart';
import 'package:fasodocs/models/api_models.dart';

try {
  final signalement = SignalementRequest(
    type: 'Problème technique',
    message: 'Le formulaire ne s\'affiche pas correctement',
    procedureId: '123',
  );
  
  final result = await signalementService.createSignalement(signalement);
  print('Signalement créé: ${result.message}');
} catch (e) {
  print('Erreur: $e');
}
```

### Exemple 8 : Obtenir les catégories et sous-catégories

```dart
import 'package:fasodocs/core/services/category_service.dart';

try {
  // Toutes les catégories
  final categories = await categoryService.getAllCategories();
  print('Nombre de catégories: ${categories.length}');
  
  // Sous-catégories d'une catégorie
  if (categories.isNotEmpty) {
    final sousCategories = await categoryService.getSousCategoriesByCategorie(
      categories.first.id,
    );
    print('Sous-catégories: ${sousCategories.length}');
  }
  
  // Procédures d'une catégorie
  final procedures = await procedureService.getProceduresByCategorie(
    categories.first.id,
  );
  print('Procédures: ${procedures.length}');
} catch (e) {
  print('Erreur: $e');
}
```

---

## 🎯 Intégration dans vos écrans existants

### Mise à jour de login_screen.dart

```dart
void _handleLogin() async {
  final phone = _phoneController.text;
  
  // Afficher un loader
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
  
  try {
    // Étape 1 : Envoyer le code SMS
    await authService.connexionTelephone(phone);
    
    if (mounted) Navigator.of(context).pop();
    
    // Étape 2 : Navigation vers la vérification SMS
    // Le code sera saisi dans sms_verification_screen.dart
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SMSVerificationScreen(telephone: phone),
        ),
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
```

### Dans sms_verification_screen.dart

```dart
void _handleVerification() async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );
  
  try {
    // Vérifier le code SMS
    final jwt = await authService.verifierSms(
      widget.telephone,
      codeController.text,
    );
    
    if (mounted) {
      Navigator.of(context).pop();
      // Navigation vers l'écran principal
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  } catch (e) {
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code invalide: $e')),
      );
    }
  }
}
```

---

## 🔒 Sécurité et tokens

Le token JWT est **automatiquement** :
- ✅ Sauvegardé après connexion
- ✅ Ajouté aux headers de toutes les requêtes
- ✅ Supprimé après déconnexion
- ✅ Restauré au démarrage de l'app

Pour vérifier la connexion :
```dart
if (await authService.isLoggedIn()) {
  final user = await authService.getCurrentUser();
  // Utilisateur connecté
}
```

---

## 📊 Mapping endpoints ↔️ services

| Endpoint | Service | Méthode |
|----------|---------|---------|
| `POST /auth/connexion-telephone` | AuthService | `connexionTelephone()` |
| `POST /auth/verifier-sms` | AuthService | `verifierSms()` |
| `GET /procedures` | ProcedureService | `getAllProcedures()` |
| `GET /procedures/{id}` | ProcedureService | `getProcedureById()` |
| `GET /procedures/rechercher` | ProcedureService | `searchProcedures()` |
| `GET /categories` | CategoryService | `getAllCategories()` |
| `POST /chatbot/chat-audio` | ChatbotService | `chatAudio()` |
| `POST /chatbot/translate/fr-to-bm` | ChatbotService | `translateFrToBm()` |
| `GET /notifications` | NotificationService | `getAllNotifications()` |
| `POST /signalements` | SignalementService | `createSignalement()` |

---

## ✨ Fonctionnalités spéciales

### 🎙️ Audio en Bambara

Vos procédures incluent maintenant des **audio en bambara** via les références légales :

```dart
procedure.referencesLegales?.forEach((ref) {
  if (ref.audioUrl != null) {
    // Jouer l'audio
    // Utilisez un package comme audio_player
    print('Audio: ${ref.audioUrl}');
  }
});
```

### 🔍 Recherche intelligente

La recherche fonctionne sur tous les champs des procédures.

### 🌍 Traduction automatique

Tous les contenus peuvent être traduits en bambara avec synthèse vocale.

---

## 📝 Checklist d'intégration

- [x] Configuration API créée
- [x] Services créés (Auth, Category, Procedure, Chatbot, Notification, Signalement)
- [x] Modèles de données créés
- [x] Gestion des tokens JWT
- [x] Gestion d'erreurs
- [x] Documentation
- [ ] Modifier l'URL dans `api_config.dart` (requis)
- [ ] Tester la connexion avec votre backend
- [ ] Intégrer dans les écrans de login
- [ ] Intégrer dans les écrans de catégories/procédures
- [ ] Implémenter le chatbot Djelia
- [ ] Ajouter les notifications en temps réel
- [ ] Tester sur appareil physique

---

## 🎉 Résumé

Votre architecture est **100% prête** pour les 46 endpoints !

**Pour commencer :**
1. Modifiez l'URL dans `api_config.dart`
2. Testez avec : `flutter pub get && flutter run`
3. Les services sont prêts à l'emploi

Bonne intégration ! 🚀

