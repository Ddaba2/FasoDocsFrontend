# 🌍 Configuration du Backend Spring Boot pour le Multilingue

## 📋 Le Problème

Votre **frontend Flutter** envoie correctement le header `Accept-Language: fr` ou `Accept-Language: en`, mais les **catégories, sous-catégories et procédures** continuent de s'afficher en français car **le backend ne gère pas encore les traductions**.

---

## ✅ Vérification : Le header est-il bien envoyé ?

### Côté Frontend (Flutter)

Le header `Accept-Language` est ajouté automatiquement à **TOUTES les requêtes API** grâce à l'intercepteur dans `lib/core/services/api_service.dart`.

**Logs attendus dans la console Flutter :**
```
🌐 Accept-Language: fr
🔍 Chargement des catégories depuis l'API...
🌐 Appel API: GET /categories
✅ Réponse API: 200 - OK
```

Après changement de langue en English :
```
✅ Langue changée: en
🌐 Accept-Language: en
🔍 Chargement des catégories depuis l'API...
```

---

## 🔧 Solution Backend (Spring Boot)

Vous devez modifier votre backend Spring Boot pour :
1. **Détecter le header `Accept-Language`**
2. **Retourner les données traduites** en fonction de la langue

### 📝 Option 1 : Stockage multilingue dans la base de données

#### Structure de base de données recommandée

```sql
-- Table Catégorie
CREATE TABLE categorie (
    id BIGINT PRIMARY KEY,
    nom_fr VARCHAR(255) NOT NULL,  -- Nom en français
    nom_en VARCHAR(255) NOT NULL,  -- Nom en anglais
    description_fr TEXT,
    description_en TEXT,
    emoji VARCHAR(10),
    ...
);

-- Table SousCategorie
CREATE TABLE sous_categorie (
    id BIGINT PRIMARY KEY,
    nom_fr VARCHAR(255) NOT NULL,
    nom_en VARCHAR(255) NOT NULL,
    description_fr TEXT,
    description_en TEXT,
    categorie_id BIGINT,
    ...
);

-- Table Procedure
CREATE TABLE procedure (
    id BIGINT PRIMARY KEY,
    nom_fr VARCHAR(255) NOT NULL,
    nom_en VARCHAR(255) NOT NULL,
    titre_fr VARCHAR(500) NOT NULL,
    titre_en VARCHAR(500) NOT NULL,
    description_fr TEXT,
    description_en TEXT,
    ...
);
```

#### Entités JPA avec traductions

```java
// Categorie.java
@Entity
@Table(name = "categorie")
public class Categorie {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String nomFr;
    private String nomEn;
    
    private String descriptionFr;
    private String descriptionEn;
    
    private String emoji;
    
    // Getters et Setters
    
    // Méthode pour obtenir le nom dans la langue demandée
    public String getNomByLocale(String locale) {
        return "en".equals(locale) ? nomEn : nomFr;
    }
    
    public String getDescriptionByLocale(String locale) {
        return "en".equals(locale) ? descriptionEn : descriptionFr;
    }
}
```

#### DTO avec traduction automatique

```java
// CategorieDTO.java
public class CategorieDTO {
    private Long id;
    private String nom;          // Traduit automatiquement
    private String description;  // Traduit automatiquement
    private String emoji;
    
    // Constructeur qui prend la locale
    public CategorieDTO(Categorie categorie, String locale) {
        this.id = categorie.getId();
        this.nom = categorie.getNomByLocale(locale);
        this.description = categorie.getDescriptionByLocale(locale);
        this.emoji = categorie.getEmoji();
    }
    
    // Getters et Setters
}
```

#### Controller avec détection de la langue

```java
// CategorieController.java
@RestController
@RequestMapping("/categories")
public class CategorieController {
    
    @Autowired
    private CategorieService categorieService;
    
    /**
     * Récupérer toutes les catégories avec traduction automatique
     * Le header Accept-Language est détecté automatiquement
     */
    @GetMapping
    public ResponseEntity<List<CategorieDTO>> getAllCategories(
            @RequestHeader(value = "Accept-Language", defaultValue = "fr") String locale
    ) {
        // Log pour déboguer
        System.out.println("🌐 Accept-Language reçu: " + locale);
        
        List<Categorie> categories = categorieService.findAll();
        
        // Convertir en DTO avec traduction
        List<CategorieDTO> categoriesDTO = categories.stream()
            .map(cat -> new CategorieDTO(cat, locale))
            .collect(Collectors.toList());
        
        return ResponseEntity.ok(categoriesDTO);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<CategorieDTO> getCategorieById(
            @PathVariable Long id,
            @RequestHeader(value = "Accept-Language", defaultValue = "fr") String locale
    ) {
        Categorie categorie = categorieService.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Catégorie non trouvée"));
        
        return ResponseEntity.ok(new CategorieDTO(categorie, locale));
    }
}
```

#### Service avec traduction

```java
// ProcedureController.java
@RestController
@RequestMapping("/procedures")
public class ProcedureController {
    
    @Autowired
    private ProcedureService procedureService;
    
    @GetMapping("/categorie/{categorieId}")
    public ResponseEntity<List<ProcedureDTO>> getProceduresByCategorie(
            @PathVariable Long categorieId,
            @RequestHeader(value = "Accept-Language", defaultValue = "fr") String locale
    ) {
        System.out.println("🌐 Chargement des procédures en: " + locale);
        
        List<Procedure> procedures = procedureService.findByCategorieId(categorieId);
        
        List<ProcedureDTO> proceduresDTO = procedures.stream()
            .map(proc -> new ProcedureDTO(proc, locale))
            .collect(Collectors.toList());
        
        return ResponseEntity.ok(proceduresDTO);
    }
}
```

---

## 📝 Option 2 : Spring Internationalization (i18n)

Si vous préférez utiliser les fichiers de ressources Spring :

### Structure des fichiers

```
src/main/resources/
├── messages.properties         # Français (défaut)
├── messages_en.properties      # English
└── messages_fr.properties      # Français explicite
```

### Fichiers de traductions

**messages_fr.properties**
```properties
categorie.identite.nom=Identité et citoyenneté
categorie.identite.description=Documents d'identité
categorie.business.nom=Création d'entreprise
procedure.naissance.titre=Extrait d'acte de naissance
```

**messages_en.properties**
```properties
categorie.identite.nom=Identity and citizenship
categorie.identite.description=Identity documents
categorie.business.nom=Business creation
procedure.naissance.titre=Birth certificate extract
```

### Configuration Spring

```java
// I18nConfig.java
@Configuration
public class I18nConfig {
    
    @Bean
    public MessageSource messageSource() {
        ReloadableResourceBundleMessageSource messageSource 
            = new ReloadableResourceBundleMessageSource();
        
        messageSource.setBasename("classpath:messages");
        messageSource.setDefaultEncoding("UTF-8");
        return messageSource;
    }
    
    @Bean
    public LocaleResolver localeResolver() {
        AcceptHeaderLocaleResolver localeResolver = new AcceptHeaderLocaleResolver();
        localeResolver.setDefaultLocale(Locale.FRENCH);
        return localeResolver;
    }
}
```

### Utilisation dans le controller

```java
@RestController
@RequestMapping("/categories")
public class CategorieController {
    
    @Autowired
    private MessageSource messageSource;
    
    @GetMapping
    public ResponseEntity<List<CategorieDTO>> getAllCategories(
            @RequestHeader(value = "Accept-Language", defaultValue = "fr") String localeStr
    ) {
        Locale locale = Locale.forLanguageTag(localeStr);
        
        List<CategorieDTO> categories = new ArrayList<>();
        
        // Exemple : Catégorie Identité
        CategorieDTO identite = new CategorieDTO();
        identite.setNom(messageSource.getMessage("categorie.identite.nom", null, locale));
        identite.setDescription(messageSource.getMessage("categorie.identite.description", null, locale));
        categories.add(identite);
        
        return ResponseEntity.ok(categories);
    }
}
```

---

## 🧪 Tests

### Test manuel avec curl

**Français :**
```bash
curl -X GET "http://localhost:8080/categories" \
  -H "Accept-Language: fr"
```

**English :**
```bash
curl -X GET "http://localhost:8080/categories" \
  -H "Accept-Language: en"
```

### Test avec Postman

1. Créer une requête GET vers `http://localhost:8080/categories`
2. Ajouter un header :
   - **Key:** `Accept-Language`
   - **Value:** `fr` ou `en`
3. Envoyer la requête

### Test depuis Flutter

```dart
// Dans category_screen.dart - après _loadCategories()
print('🌐 Langue actuelle: ${Provider.of<LanguageProvider>(context, listen: false).currentLanguage}');
```

Regardez les logs Spring Boot pour vérifier :
```
🌐 Accept-Language reçu: en
🌐 Chargement des procédures en: en
```

---

## 📊 Exemple de réponse Backend attendue

### Français (`Accept-Language: fr`)

```json
[
  {
    "id": 1,
    "nom": "Identité et citoyenneté",
    "description": "Documents d'identité et citoyenneté",
    "emoji": "🆔"
  },
  {
    "id": 2,
    "nom": "Création d'entreprise",
    "description": "Procédures pour créer une entreprise",
    "emoji": "🏢"
  }
]
```

### English (`Accept-Language: en`)

```json
[
  {
    "id": 1,
    "nom": "Identity and citizenship",
    "description": "Identity and citizenship documents",
    "emoji": "🆔"
  },
  {
    "id": 2,
    "nom": "Business creation",
    "description": "Procedures to create a business",
    "emoji": "🏢"
  }
]
```

---

## 🚀 Déploiement

### Mise à jour de la base de données

1. **Ajouter les colonnes de traduction**
   ```sql
   ALTER TABLE categorie ADD COLUMN nom_en VARCHAR(255);
   ALTER TABLE categorie ADD COLUMN description_en TEXT;
   
   ALTER TABLE sous_categorie ADD COLUMN nom_en VARCHAR(255);
   ALTER TABLE sous_categorie ADD COLUMN description_en TEXT;
   
   ALTER TABLE procedure ADD COLUMN nom_en VARCHAR(255);
   ALTER TABLE procedure ADD COLUMN titre_en VARCHAR(500);
   ALTER TABLE procedure ADD COLUMN description_en TEXT;
   ```

2. **Remplir les traductions**
   ```sql
   UPDATE categorie SET 
     nom_en = 'Identity and citizenship' 
     WHERE id = 1;
   
   UPDATE procedure SET 
     titre_en = 'Birth certificate extract' 
     WHERE nom = 'extrait-acte-naissance';
   ```

---

## ✅ Checklist

- [ ] Ajouter colonnes `nom_en`, `description_en` dans les tables
- [ ] Remplir les traductions en base de données
- [ ] Modifier les entités JPA avec champs multilingues
- [ ] Créer les DTO avec constructeur locale
- [ ] Modifier les controllers pour détecter `Accept-Language`
- [ ] Tester avec curl/Postman
- [ ] Redémarrer le backend Spring Boot
- [ ] Tester depuis l'app Flutter

---

## 🎯 Résultat final

Une fois le backend configuré :

1. **Changer la langue dans Settings** (Français → English)
2. **Le frontend envoie** `Accept-Language: en`
3. **Le backend retourne** les données en anglais
4. **L'interface affiche** tout en anglais ! ✅

---

## 📞 Besoin d'aide ?

Si vous avez besoin d'aide pour implémenter ces modifications backend, n'hésitez pas !

