# 🐛 Debug - Problème de connexion

## Le problème

L'app affiche : "Impossible de charger les catégories depuis le serveur"

Le backend est bien lancé sur `http://localhost:8080` ✅

## 🔍 Investigation

### 1. Vérifier les logs dans la console Flutter

Relance l'app et regarde les logs dans la console. Tu devrais voir :

```
🔍 Chargement des catégories depuis l'API...
🌐 Appel API: GET http://10.0.2.2:8080/categories
```

**SI tu vois une erreur**, copie le message ici.

### 2. Problèmes possibles

#### A. CORS dans le backend Spring Boot

Le backend doit autoriser les requêtes depuis Flutter.

**Ajoute cette classe dans ton backend Spring Boot :**

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

#### B. L'endpoint `/categories` existe-t-il ?

Dans IntelliJ, vérifie que ton contrôleur expose bien :

```java
@RestController
@RequestMapping("/categories")
public class CategorieController {
    
    @GetMapping
    public ResponseEntity<List<CategorieResponse>> getAllCategories() {
        // ...
    }
}
```

#### C. Test rapide dans le navigateur

Ouvre ton navigateur et va sur :
```
http://localhost:8080/categories
```

**Tu devrais voir un JSON avec tes catégories.**

Si tu vois une erreur 404, c'est que l'endpoint n'existe pas.

### 3. Test avec l'adresse IP localhost

Essayons avec `localhost` au lieu de `10.0.2.2` :

Modifie `lib/core/config/api_config.dart` :

```dart
// Test avec localhost
static const String baseUrl = 'http://localhost:8080';
```

Et relance l'app.

---

## 🎯 Solution la plus probable : CORS

**99% du temps, c'est un problème CORS.**

Ajoute la classe `CorsConfig` dans ton backend comme indiqué ci-dessus, redémarre le backend, et réessaye.

---

## 📝 Prochaine étape

1. Regarde les logs dans la console Flutter (copie ici l'erreur exacte)
2. Teste dans le navigateur : `http://localhost:8080/categories`
3. Vérifie que le backend a bien la configuration CORS

Dis-moi ce que tu vois ! 🔍

