# 🚀 Démarrer le Backend Spring Boot

## ⚠️ Avant de tester l'app

Ton application Flutter va chercher les catégories sur ton backend Spring Boot. 

**Assure-toi que le backend est démarré !**

---

## 🔧 Démarrer le backend

### Option 1 : Via IntelliJ IDEA / Eclipse
1. Ouvre le projet Spring Boot
2. Clique sur le bouton "Run" ▶️
3. Attends que le message `Started Application in X seconds` apparaisse

### Option 2 : Via Maven en ligne de commande
```bash
cd /chemin/vers/ton/backend
mvn spring-boot:run
```

### Option 3 : Via Gradle en ligne de commande
```bash
cd /chemin/vers/ton/backend
./gradlew bootRun
```

---

## ✅ Vérifier que le backend fonctionne

Ouvre ton navigateur et teste :
```
http://localhost:8080/categories
```

Tu devrais voir un JSON avec tes 7 catégories.

---

## 🔍 Vérifier le port

Assure-toi que le backend écoute sur le **port 8080**.

Si tu utilises un autre port, modifie `lib/core/config/api_config.dart` :

```dart
static const String baseUrl = 'http://10.0.2.2:TON_PORT';
```

---

## 🧪 Test rapide de l'API

### Avec curl (si installé) :
```bash
curl http://10.0.2.2:8080/categories
```

### Avec PowerShell :
```powershell
Invoke-RestMethod -Uri "http://localhost:8080/categories" -Method Get
```

---

## 📱 Pendant que l'app tourne

Regarde la console pour voir les logs :

✅ **Succès** :
```
🔍 Chargement des catégories depuis l'API...
🌐 Appel API: GET http://10.0.2.2:8080/categories
📦 Réponse reçue - Status: 200
✅ 7 catégorie(s) reçue(s) du backend
✅ 7 catégorie(s) chargée(s) depuis la base de données
```

❌ **Erreur** (backend non démarré) :
```
❌ Erreur lors du chargement des catégories: Connection refused
```

Dans ce cas :
1. Démarre le backend Spring Boot
2. Clique sur "Réessayer" dans l'app

---

## 🔐 CORS (si problème de connexion)

Si tu as des erreurs CORS dans le backend, assure-toi que ton Spring Boot accepte les requêtes depuis Flutter :

```java
@Configuration
public class CorsConfig {
    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins("*")
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                        .allowedHeaders("*");
            }
        };
    }
}
```

---

## 🎯 Ordre de démarrage recommandé

1. ✅ Démarre le backend Spring Boot (port 8080)
2. ✅ Vérifie que `GET /categories` fonctionne dans le navigateur
3. ✅ Lance l'app Flutter : `flutter run`
4. ✅ Clique sur l'onglet "Catégories"
5. ✅ Les 7 catégories devraient s'afficher !

