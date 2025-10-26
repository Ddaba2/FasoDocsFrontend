# 🧪 Test de l'Intégration API - Catégories

## ✅ Modifications effectuées

Votre écran `CategoryScreen` a été modifié pour afficher **uniquement les catégories venant de la base de données**.

### Fichiers modifiés :
1. ✅ `lib/views/category/category_screen.dart` - Converti en StatefulWidget avec appel API
2. ✅ `lib/views/procedure/procedure_list_screen.dart` - Nouvel écran pour les procédures
3. ✅ `lib/core/services/category_service.dart` - Ajout de logs de debug

---

## 🔧 Configuration requise

### 1. Vérifier l'URL du backend

**IMPORTANT :** Assurez-vous que votre backend Spring Boot est en cours d'exécution !

Ouvrez `lib/core/config/api_config.dart` et vérifiez :

```dart
// Pour Android Emulator
static const String baseUrl = 'http://10.0.2.2:8080';

// Pour iOS Simulator  
// static const String baseUrl = 'http://localhost:8080';

// Pour appareil physique, utilisez votre IP locale
// static const String baseUrl = 'http://192.168.1.XXX:8080';
```

### 2. Vérifier que votre backend répond

Testez l'endpoint dans votre navigateur ou avec curl :

```bash
curl http://10.0.2.2:8080/categories
```

Vous devriez voir un JSON avec vos catégories.

---

## 🚀 Tester l'application

### Commandes de test

```bash
# Nettoyer le build
flutter clean

# Obtenir les dépendances
flutter pub get

# Lancer l'app en mode debug (pour voir les logs)
flutter run
```

### Messages dans la console

Quand vous cliquez sur l'onglet "Catégories", vous devriez voir :

```
🔍 Chargement des catégories depuis l'API...
🌐 Appel API: GET http://10.0.2.2:8080/categories
📦 Réponse reçue - Status: 200
✅ X catégorie(s) reçue(s) du backend
✅ X catégorie(s) chargée(s) depuis la base de données
```

---

## 🔍 Dépannage

### Problème 1 : "Connection refused" ou timeout

**Cause :** Le backend n'est pas en cours d'exécution

**Solution :**
```bash
# Démarrez votre backend Spring Boot
cd /chemin/vers/votre/backend
mvn spring-boot:run
# ou
./mvnw spring-boot:run
```

### Problème 2 : "Aucune catégorie disponible"

**Cause :** Aucune catégorie dans la base de données

**Solution :** 
- Ajoutez des catégories dans votre table `categories` via votre backend admin
- Vérifiez que l'endpoint `/categories` retourne bien des données

### Problème 3 : "Erreur HTTP 404"

**Cause :** L'endpoint n'existe pas dans votre backend

**Solution :**
- Vérifiez que votre backend expose l'endpoint `GET /categories`
- Vérifiez le port (8080 par défaut)
- Vérifiez les logs du backend

### Problème 4 : Affichage des anciennes catégories

**Cause :** Cache ou code ancien

**Solution :**
```bash
# Nettoyer complètement
flutter clean
flutter pub get
flutter run
```

---

## 📋 Checklist

- [ ] Backend Spring Boot démarré sur le port 8080
- [ ] Base de données contient des catégories dans la table `categories`
- [ ] URL modifiée dans `api_config.dart` si nécessaire
- [ ] App lancée avec `flutter run`
- [ ] Console affiche les messages de debug
- [ ] Les catégories s'affichent depuis la base de données

---

## 🎯 Résultat attendu

Quand vous cliquez sur l'onglet **Catégories** :

1. **Pendant le chargement** : Un cercle de chargement s'affiche
2. **En cas de succès** : Les catégories de votre base de données s'affichent en grille
3. **En cas d'erreur** : Un message d'erreur avec bouton "Réessayer"

**Les données statiques ne sont plus affichées !** ✅

---

## 💡 Test rapide

1. Démarrez votre backend Spring Boot
2. Vérifiez que l'endpoint fonctionne : `curl http://10.0.2.2:8080/categories`
3. Lancez l'app Flutter : `flutter run`
4. Cliquez sur "Catégories"
5. Vérifiez les logs dans la console
6. Les catégories de la BD doivent s'afficher

---

## 🐛 Si vous voyez encore les anciennes catégories

Cela signifie que le fichier n'a pas été mis à jour. Vérifiez :

1. Que `category_screen.dart` a la méthode `_loadCategories()`
2. Que la classe hérite de `StatefulWidget` et non `StatelessWidget`
3. Que le fichier a bien été sauvegardé
4. Relancez avec `flutter clean && flutter pub get && flutter run`

---

**Besoin d'aide ?** Vérifiez les logs de la console pour voir où le problème se situe.

