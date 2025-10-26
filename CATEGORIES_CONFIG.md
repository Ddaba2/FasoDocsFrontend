# 📋 Configuration des Catégories

## ✅ Mapping des catégories de la base de données

J'ai configuré le mapping pour les **7 catégories** de votre base de données :

### 1️⃣ Identité et citoyenneté 🪪
- **Icône** : `Icons.perm_identity`
- **Couleur** : Vert (#4CAF50)
- **Emoji** : 🪪

### 2️⃣ Création d'entreprise 🏢
- **Icône** : `Icons.business_center`
- **Couleur** : Jaune (#FFB300)
- **Emoji** : 🏢

### 3️⃣ Documents auto 🚗
- **Icône** : `Icons.directions_car`
- **Couleur** : Rouge (#E91E63)
- **Emoji** : 🚗

### 4️⃣ Service fonciers 🏗️
- **Icône** : `Icons.construction`
- **Couleur** : Vert (#4CAF50)
- **Emoji** : 🏗️

### 5️⃣ Eau et électricité 💡
- **Icône** : `Icons.bolt`
- **Couleur** : Jaune (#FFB300)
- **Emoji** : 💡

### 6️⃣ Justice ⚖️
- **Icône** : `Icons.balance`
- **Couleur** : Gris foncé (#424242)
- **Emoji** : ⚖️

### 7️⃣ Impôt et Douane 💰
- **Icône** : `Icons.account_balance`
- **Couleur** : Bleu (#2196F3)
- **Emoji** : 💰

---

## 📁 Fichiers créés/modifiés

### ✅ Nouveau fichier : `lib/core/config/category_mapping.dart`
Contient le mapping centralisé des catégories avec :
- Fonction `getIcon()` pour obtenir l'icône selon le nom
- Fonction `getColors()` pour obtenir les couleurs personnalisées
- Liste des catégories attendues de la BD

### ✅ Modifié : `lib/views/category/category_screen.dart`
- Utilise maintenant `CategoryMapping.getIcon()` 
- Utilise maintenant `CategoryMapping.getColors()`
- Mapping automatique basé sur le nom exact de la catégorie

---

## 🔍 Fonctionnement

Quand l'application charge les catégories depuis la base de données :

```dart
// 1. Appel API pour obtenir les catégories
final categories = await categoryService.getAllCategories();

// 2. Pour chaque catégorie, mapping automatique
for (var category in categories) {
  final icon = CategoryMapping.getIcon(category.nom);
  final colors = CategoryMapping.getColors(category.nom, index);
  // Afficher avec l'icône et les couleurs correspondantes
}
```

---

## 🎨 Personnalisation des couleurs

Si tu veux changer les couleurs pour certaines catégories, modifie le fichier :

**`lib/core/config/category_mapping.dart`**

Dans la fonction `getColors()`, tu peux ajouter/modifier :

```dart
'nom de la catégorie': {
  'backgroundColor': const Color(0xFF...),
  'iconColor': const Color(0xFF...),
},
```

---

## 🔧 Structure de la base de données attendue

```sql
categories (
  id,
  titre VARCHAR,              -- Nom de la catégorie (exact comme ci-dessus)
  description VARCHAR,         -- Description de la catégorie
  icone_url VARCHAR,           -- Emoji ou URL d'icône
  date_creation DATETIME       -- Date de création
)
```

---

## ✅ Exemples de requêtes API

### Endpoint utilisé
```
GET http://10.0.2.2:8080/categories
```

### Réponse attendue
```json
[
  {
    "id": "1",
    "nom": "Identité et citoyenneté",
    "description": "Documents d'identité...",
    "icone": "🪪"
  },
  {
    "id": "2",
    "nom": "Création d'entreprise",
    "description": "Création et immatriculation...",
    "icone": "🏢"
  },
  ...
]
```

---

## 🚀 Tests

Pour vérifier que tout fonctionne :

1. **Lancez l'app** : `flutter run`
2. **Cliquez sur "Catégories"**
3. **Vérifiez dans la console** :
   ```
   🔍 Chargement des catégories depuis l'API...
   🌐 Appel API: GET http://10.0.2.2:8080/categories
   📦 Réponse reçue - Status: 200
   ✅ 7 catégorie(s) reçue(s) du backend
   ✅ 7 catégorie(s) chargée(s) depuis la base de données
   ```

4. **Les 7 catégories** doivent s'afficher avec leurs icônes et couleurs correspondantes !

---

## 📝 Notes

- Les icônes sont automatiquement mappées selon le nom exact de la catégorie
- Les couleurs sont personnalisées pour chaque catégorie
- Le système est extensible : ajouter de nouvelles catégories dans la BD les affichera automatiquement
- Les catégories s'affichent dans l'ordre retourné par l'API

