# 🚀 Solution Rapide - Problème de Connexion

## ⚠️ Le problème actuel

L'app ne peut pas se connecter au backend malgré que le backend soit lancé.

## 🔍 Diagnostic en 3 étapes

### Étape 1 : Vérifier que l'endpoint fonctionne

Ouvre ton navigateur et va sur :
```
http://localhost:8080/categories
```

**Résultat attendu** : Un JSON avec tes 7 catégories

**Si tu vois 404** : L'endpoint n'existe pas dans ton backend
**Si tu vois des erreurs** : Il y a un problème côté backend

---

### Étape 2 : Vérifier les logs dans la console Flutter

Dans la console où tu as lancé `flutter run`, regarde les messages après avoir cliqué sur "Catégories".

**Copie TOUS les messages de la console ici.**

---

### Étape 3 : Tester avec l'URL locale

Modifie temporairement l'URL pour tester avec `localhost` :

**Fichier** : `lib/core/config/api_config.dart`

**Change** :
```dart
static const String baseUrl = 'http://localhost:8080';
```

**Au lieu de** :
```dart
static const String baseUrl = 'http://10.0.2.2:8080';
```

Puis relance l'app :
```bash
flutter run
```

---

## 🎯 Solutions probables

### Solution 1 : Problème CORS (le plus probable)

Si tu vois des erreurs CORS dans les logs, ajoute cette config dans ton backend :

**Fichier** : `src/main/java/ml/fasodocs/backend/config/CorsConfig.java`

```java
package ml.fasodocs.backend.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

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
                        .allowedHeaders("*")
                        .maxAge(3600);
            }
        };
    }
}
```

**Ensuite** : Redémarre le backend et relance l'app Flutter.

---

### Solution 2 : L'endpoint n'existe pas

Vérifie dans ton backend que le contrôleur expose bien :

```java
@RestController
public class CategorieController {
    
    @GetMapping("/categories")
    public List<CategorieResponse> getAllCategories() {
        // ...
    }
}
```

---

### Solution 3 : Changement de baseUrl

Teste avec différentes URLs :

```dart
// Option 1 : Pour Android Emulator
static const String baseUrl = 'http://10.0.2.2:8080';

// Option 2 : Pour test local
static const String baseUrl = 'http://localhost:8080';

// Option 3 : Avec ton IP locale (Windows : ipconfig dans CMD)
static const String baseUrl = 'http://192.168.1.XXX:8080';
```

---

## 📋 Checklist

- [ ] Backend démarré sur port 8080
- [ ] `http://localhost:8080/categories` retourne du JSON
- [ ] Configuration CORS ajoutée dans le backend
- [ ] Backend redémarré après ajout de CORS
- [ ] Logs de la console Flutter regardés
- [ ] URL testée avec différentes valeurs (10.0.2.2, localhost, IP locale)

---

## 🆘 Copie ici :

1. Les logs exacts de la console Flutter
2. Le résultat de `http://localhost:8080/categories` dans le navigateur
3. Si tu as ajouté la configuration CORS ou non

Avec ces infos, je peux t'aider plus précisément ! 🔍

