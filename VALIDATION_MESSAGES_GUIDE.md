# 📝 Guide des Messages d'Erreur Clairs et Précis

## Vue d'ensemble

Votre application FasoDocs dispose maintenant d'un système de validation centralisé avec des **messages d'erreur clairs, précis et informatifs** pour guider l'utilisateur.

---

## 📱 Messages de Validation Téléphone

### Exemples de messages affichés

| Situation | Message affiché |
|-----------|----------------|
| Champ vide | `📱 Le numéro de téléphone est obligatoire` |
| Numéro incomplet (5 chiffres) | `📞 Numéro de téléphone incomplet (5/8 chiffres minimum)` |
| Numéro trop long (16 chiffres) | `❌ Numéro trop long (16 chiffres, maximum 15)` |
| Préfixe invalide (Mali) | `❌ Préfixe invalide "12". Vérifiez votre numéro` |
| Numéro malien invalide | `🇲🇱 Un numéro malien doit avoir exactement 8 chiffres` |

### Code utilisé

```dart
final phoneError = FormValidators.validatePhone(
  phoneText,
  completeNumber: _completeNumber,
);
```

---

## 📧 Messages de Validation Email

### Exemples de messages affichés

| Situation | Message affiché |
|-----------|----------------|
| Champ vide | `📧 L'adresse email est obligatoire` |
| Pas de @ | `❌ L'email doit contenir le symbole @` |
| Pas de point | `❌ L'email doit contenir un point (.) après le @` |
| Format invalide | `❌ Format d'email invalide (ex: exemple@mail.com)` |
| Contient des espaces | `❌ L'email ne doit pas contenir d'espaces` |
| @ au début | `❌ Le symbole @ ne peut pas être au début ou à la fin` |
| Rien avant @ | `❌ L'email doit avoir du texte avant le @` |
| Domaine invalide | `❌ L'email doit avoir un domaine valide après le @` |

### Code utilisé

```dart
final emailError = FormValidators.validateEmail(
  _emailController.text,
);
```

---

## 🔒 Messages de Validation Mot de Passe

### Exemples de messages affichés

| Situation | Message affiché |
|-----------|----------------|
| Champ vide | `🔒 Le mot de passe est obligatoire` |
| Trop court (3 caractères / min 6) | `❌ Mot de passe trop court (3/6 caractères minimum)` |
| Moins de 8 caractères | `⚠️ Mot de passe faible. Recommandé : 8 caractères minimum` |
| Confirmation différente | `❌ Les mots de passe ne correspondent pas` |
| Confirmation vide | `🔒 Veuillez confirmer votre mot de passe` |

### Code utilisé

```dart
// Validation du mot de passe
final passwordError = FormValidators.validatePassword(
  _passwordController.text,
  minLength: 6,
);

// Validation de la confirmation
final confirmError = FormValidators.validateConfirmPassword(
  _confirmPasswordController.text,
  _passwordController.text,
);
```

---

## 📝 Messages de Validation Nom/Prénom

### Exemples de messages affichés

| Situation | Message affiché |
|-----------|----------------|
| Champ vide | `📝 Le nom est obligatoire` |
| Trop court (1 caractère) | `❌ Le nom est trop court (minimum 2 caractères)` |
| Trop long (60 caractères) | `❌ Le nom est trop long (maximum 50 caractères)` |
| Contient des chiffres | `❌ Le nom ne doit pas contenir de chiffres` |
| Caractères spéciaux | `❌ Le nom ne doit contenir que des lettres` |

### Code utilisé

```dart
final nomError = FormValidators.validateName(
  _nomController.text,
  fieldName: 'Le nom',
);

final prenomError = FormValidators.validateName(
  _prenomController.text,
  fieldName: 'Le prénom',
);
```

---

## 📱 Messages de Validation Code SMS

### Exemples de messages affichés

| Situation | Message affiché |
|-----------|----------------|
| Champ vide | `📱 Le code de vérification est obligatoire` |
| Code incomplet (3/4) | `❌ Code incomplet (3/4 chiffres)` |
| Code trop long (5/4) | `❌ Code trop long (5 chiffres, attendu 4)` |
| Contient des lettres | `❌ Le code doit contenir uniquement des chiffres` |
| Code incorrect (backend) | `❌ Code incorrect. Vérifiez le SMS reçu et réessayez` |
| Code expiré (backend) | `⏰ Code expiré. Veuillez demander un nouveau code` |

### Code utilisé

```dart
final codeError = FormValidators.validateSmsCode(
  code,
  length: 4,
);
```

---

## 🆔 Messages de Validation CNI

### Exemples de messages affichés

| Situation | Message affiché |
|-----------|----------------|
| Champ vide | `🆔 Le numéro de CNI est obligatoire` |
| Trop court | `❌ Numéro de CNI trop court (minimum 8 caractères)` |
| Trop long | `❌ Numéro de CNI trop long (maximum 15 caractères)` |

### Code utilisé

```dart
final cniError = FormValidators.validateCNI(
  _cniController.text,
);
```

---

## 💰 Messages de Validation Montant

### Exemples de messages affichés

| Situation | Message affiché |
|-----------|----------------|
| Champ vide | `💰 Le montant est obligatoire` |
| Pas un nombre | `❌ Montant invalide (utilisez uniquement des chiffres)` |
| Montant négatif ou 0 | `❌ Le montant doit être supérieur à 0 FCFA` |
| Montant trop élevé | `❌ Montant trop élevé (maximum 1 milliard FCFA)` |

### Code utilisé

```dart
final amountError = FormValidators.validateAmount(
  _montantController.text,
  currency: 'FCFA',
);
```

---

## ✅ Messages de Validation Générique

### Champ obligatoire

```dart
final error = FormValidators.validateRequired(
  value,
  fieldName: 'La description',
);
// Message: "❌ La description est obligatoire"
```

### Longueur

```dart
final error = FormValidators.validateLength(
  value,
  minLength: 10,
  maxLength: 500,
  fieldName: 'Le commentaire',
);
// Messages possibles:
// "❌ Le commentaire trop court (5/10 caractères minimum)"
// "❌ Le commentaire trop long (600/500 caractères maximum)"
```

---

## 🎨 Style des Messages

### Caractéristiques

✅ **Émojis** - Rendent les messages plus visuels et compréhensibles
✅ **Compteurs** - Indiquent la progression (ex: `3/8 chiffres`)
✅ **Contexte** - Expliquent le problème précisément
✅ **Solutions** - Guident l'utilisateur sur ce qu'il doit faire

### Affichage

Tous les messages sont affichés via des **SnackBar modernes** :
- 🎨 Couleur rouge pour les erreurs
- 🎨 Couleur verte pour les succès
- ⏱️ Durée de 3-4 secondes
- 📍 Position flottante
- 🔘 Coins arrondis

---

## 📦 Comment Utiliser dans Votre Code

### Exemple complet (Formulaire)

```dart
import 'package:fasodocs/core/utils/form_validators.dart';

class MyFormScreen extends StatefulWidget {
  // ...
}

class _MyFormScreenState extends State<MyFormScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  void _submitForm() {
    // Validation du nom
    final nameError = FormValidators.validateName(
      _nameController.text,
      fieldName: 'Le nom',
    );
    if (nameError != null) {
      _showError(nameError);
      return;
    }

    // Validation de l'email
    final emailError = FormValidators.validateEmail(_emailController.text);
    if (emailError != null) {
      _showError(emailError);
      return;
    }

    // Validation du téléphone
    final phoneError = FormValidators.validatePhone(_phoneController.text);
    if (phoneError != null) {
      _showError(phoneError);
      return;
    }

    // Si tout est valide, procéder...
    print('✅ Formulaire valide !');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 15, color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
```

---

## 🌍 Messages Multilingues

Les validateurs sont prêts pour être traduits ! Pour ajouter le support multilingue :

1. **Créer un fichier de traduction des erreurs**
   ```dart
   // lib/locale/locale_errors.dart
   class LocaleErrors {
     static String phoneRequired(String locale) {
       if (locale == 'en') return '📱 Phone number is required';
       return '📱 Le numéro de téléphone est obligatoire';
     }
   }
   ```

2. **Modifier les validateurs**
   ```dart
   static String? validatePhone(String? value, {String locale = 'fr'}) {
     if (value == null || value.isEmpty) {
       return LocaleErrors.phoneRequired(locale);
     }
     // ...
   }
   ```

---

## 📊 Récapitulatif

| Type de validation | Fichier | Nombre de scénarios |
|-------------------|---------|---------------------|
| Téléphone | `form_validators.dart` | 6 scénarios |
| Email | `form_validators.dart` | 8 scénarios |
| Mot de passe | `form_validators.dart` | 5 scénarios |
| Nom/Prénom | `form_validators.dart` | 5 scénarios |
| Code SMS | `form_validators.dart` | 5 scénarios |
| CNI | `form_validators.dart` | 3 scénarios |
| Montant | `form_validators.dart` | 4 scénarios |

**Total : 36+ scénarios de validation avec messages clairs ! ✅**

---

## 🎯 Avantages

✅ **Messages clairs** - L'utilisateur comprend exactement le problème
✅ **Centralisé** - Toutes les validations au même endroit
✅ **Réutilisable** - Utilisable dans tous les formulaires
✅ **Maintenable** - Facile à mettre à jour
✅ **UX optimale** - Améliore l'expérience utilisateur
✅ **Professionnel** - Donne une image soignée de l'app

---

## 🚀 Prochaines Étapes

Pour étendre ce système :

1. **Ajouter de nouveaux validateurs** selon vos besoins
2. **Traduire les messages** pour le support multilingue
3. **Ajouter la validation en temps réel** sur les TextFormField
4. **Créer des validateurs métier** spécifiques à votre domaine

---

## 💡 Bonnes Pratiques

1. ✅ Toujours utiliser les validateurs centralisés
2. ✅ Afficher les erreurs immédiatement après validation
3. ✅ Ne pas valider un champ vide s'il n'est pas obligatoire
4. ✅ Donner des exemples de format attendu
5. ✅ Utiliser des émojis pour une meilleure visibilité

---

Votre application offre maintenant une expérience utilisateur professionnelle avec des messages d'erreur clairs et précis ! 🎉

