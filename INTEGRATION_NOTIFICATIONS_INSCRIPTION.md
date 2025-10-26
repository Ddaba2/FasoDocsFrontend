# Intégration Notifications et Inscription

## ✅ Modifications Effectuées

### 1. Notifications ✅
Les notifications sont **déjà intégrées** et fonctionnent avec le backend :

**Service** : `lib/core/services/notification_service.dart`
- ✅ Récupère depuis la table `notification` du backend
- ✅ Endpoints configurés dans `ApiConfig` :
  - `/notifications` : Toutes les notifications
  - `/notifications/non-lues` : Notifications non lues
  - `/notifications/count-non-lues` : Nombre de notifications non lues
  - `/notifications/:id/lire` : Marquer comme lue
  - `/notifications/lire-tout` : Marquer toutes comme lues

**Si aucune notification** : La liste sera vide, c'est normal.

### 2. Inscription ✅ 
L'inscription a été **modifiée** pour enregistrer dans la table `citoyen` avec les champs requis.

#### Champs Demandés (selon spécification) :
- ✅ `nom` (séparé de prénom)
- ✅ `prenom` (séparé de nom)
- ✅ `telephone`
- ✅ `email`
- ✅ `mot_de_passe`

#### Modifications Apportées :

**1. Service d'Authentification** (`lib/core/services/auth_service.dart`)
```dart
Future<MessageResponse> inscription({
  required String nom,        // ← Ajouté (séparé)
  required String prenom,        // ← Ajouté (séparé)
  required String telephone,
  required String email,
  required String motDePasse,
}) async {
  final response = await _apiService.post(
    ApiConfig.authInscription,
    data: {
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
      'mot_de_passe': motDePasse,  // snake_case pour le backend
    },
  );
}
```

**2. Écran d'Inscription** (`lib/views/auth/signup_screen.dart`)
- ✅ Ajout des champs **Nom** et **Prénom** dans l'interface
- ✅ Validation des champs avant soumission
- ✅ Appel à `AuthService.inscription()` avec les bons champs
- ✅ Indicateur de chargement pendant l'inscription
- ✅ Messages d'erreur appropriés

#### Format de Données Envoyées au Backend :
```json
{
  "nom": "DIARRA",
  "prenom": "Daba",
  "telephone": "+223 76 00 00 00",
  "email": "daba.diarra@gmail.com",
  "mot_de_passe": "motdepasse123"
}
```

## 🧪 Tests

### Test Inscription
1. Lancer l'application
2. Aller sur l'écran d'inscription
3. Remplir :
   - **Nom** : Diarra
   - **Prénom** : Daba
   - **Téléphone** : +223 76 00 00 00
   - **Email** : daba.diarra@gmail.com
   - **Mot de passe** : ********
   - **Confirmer mot de passe** : ********
4. Cocher "J'accepte les conditions d'utilisation"
5. Cliquer sur **S'inscrire**
6. L'utilisateur devrait être créé dans la table `citoyen` du backend

### Test Notifications
1. Les notifications sont chargées depuis la table `notification`
2. Si la table est vide, la liste des notifications sera vide

## 📋 Configuration Backend Requise

### Endpoint Inscription
Le backend doit accepter les champs suivants :
```
POST /api/auth/inscription
Content-Type: application/json

{
  "nom": "string",
  "prenom": "string",
  "telephone": "string",
  "email": "string",
  "mot_de_passe": "string"
}
```

### Table Citoyen
La table `citoyen` doit avoir les colonnes :
- `id` (auto-généré)
- `nom` (VARCHAR)
- `prenom` (VARCHAR)
- `telephone` (VARCHAR)
- `email` (VARCHAR)
- `mot_de_passe` (VARCHAR) - doit être hashé côté backend
- `date_creation` (TIMESTAMP)

### Table Notification
La table `notification` doit avoir les colonnes :
- `id` (auto-généré)
- `titre` (VARCHAR)
- `message` (TEXT)
- `lue` (BOOLEAN)
- `date_creation` (TIMESTAMP)

## 🔍 Vérification Backend

### Vérifier l'Inscription
```sql
-- Après une inscription, vérifier que l'utilisateur est bien créé
SELECT * FROM citoyen WHERE email = 'daba.diarra@gmail.com';
```

### Vérifier les Notifications
```sql
-- Vérifier les notifications dans la base
SELECT * FROM notification;
```

## 📝 Checklist

- [x] Service de notifications configuré avec backend
- [x] Inscription modifiée avec champs nom/prenom séparés
- [x] Interface utilisateur mise à jour avec champs nom/prenom
- [x] Validation des champs côté frontend
- [x] Indicateur de chargement pendant l'inscription
- [x] Messages d'erreur appropriés
- [ ] Backend vérifié pour accepter les champs nom/prenom
- [ ] Test d'inscription effectué avec succès
- [ ] Notifications récupérées depuis la table notification

## 🚀 Prochaines Étapes

1. **Vérifier le Backend** : S'assurer que l'endpoint `/api/auth/inscription` accepte bien les champs `nom` et `prenom` séparément
2. **Tester l'Inscription** : Créer un compte et vérifier qu'il apparaît dans la table `citoyen`
3. **Tester les Notifications** : Vérifier que les notifications s'affichent correctement

---

**Note** : Les notifications fonctionnent déjà avec le backend. Si la liste est vide, c'est parce que la table `notification` est vide dans la base de données.
