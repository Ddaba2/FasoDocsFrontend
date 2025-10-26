# 🔧 Fix StackOverflowError - Backend Spring Boot

## ❌ Problème identifié

**Erreur :** `java.lang.StackOverflowError`

**Cause :** Boucle infinie dans les relations JPA entre vos entités :

```
Procedure ↔ SousCategorie ↔ Categorie
```

Quand Hibernate essaie de calculer le `hashCode()`, il y a une boucle infinie.

---

## ✅ Solution : Modifier vos entités

### Option 1 : Utiliser `@ToString.Exclude` et `@EqualsAndHashCode.Exclude`

Dans vos entités Java, ajoutez :

**Pour `SousCategorie.java` :**
```java
@Entity
public class SousCategorie {
    // ...
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JsonIgnoreProperties({"sousCategories", "procedures"}) // IMPORTANT
    private Categorie categorie;
    
    @OneToMany(mappedBy = "sousCategorie", cascade = CascadeType.ALL)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private Set<Procedure> procedures;
    
    // ...
}
```

**Pour `Categorie.java` :**
```java
@Entity
public class Categorie {
    // ...
    
    @OneToMany(mappedBy = "categorie", cascade = CascadeType.ALL)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private Set<SousCategorie> sousCategories;
    
    @OneToMany(mappedBy = "categorie", cascade = CascadeType.ALL)
    @ToString.Exclude
    @EqualsAndHashCode.Exclude
    private Set<Procedure> procedures;
    
    // ...
}
```

**Pour `Procedure.java` :**
```java
@Entity
public class Procedure {
    // ...
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JsonIgnoreProperties({"sousCategories", "procedures"})
    private Categorie categorie;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JsonIgnoreProperties({"procedures", "categorie"})
    private SousCategorie sousCategorie;
    
    // ...
}
```

### Option 2 : DTO Projection dans le controller

Au lieu de retourner les entités complètes, utilisez des DTO :

```java
@GetMapping("/categorie/{categorieId}")
public ResponseEntity<List<SousCategorieResponse>> getSousCategoriesByCategorie(
    @PathVariable String categorieId
) {
    List<SousCategorie> sousCategories = sousCategorieService
        .findByCategorieId(Long.parseLong(categorieId));
    
    // Convertir en DTO pour éviter les relations circulaires
    List<SousCategorieResponse> responses = sousCategories.stream()
        .map(sc -> {
            SousCategorieResponse dto = new SousCategorieResponse();
            dto.setId(sc.getId());
            dto.setTitre(sc.getTitre());
            dto.setDescription(sc.getDescription());
            dto.setIconeUrl(sc.getIconeUrl());
            dto.setCategorieId(sc.getCategorie().getId().toString());
            // NE PAS mapper les procédures pour éviter StackOverflow
            return dto;
        })
        .collect(Collectors.toList());
    
    return ResponseEntity.ok(responses);
}
```

### Option 3 : Ajuster le projet côté Flutter (déjà fait)

J'ai déjà ajouté un fallback qui affiche les procédures directement si l'endpoint des sous-catégories échoue.

---

## 🚀 Solution rapide recommandée

**Ajoutez dans vos entités :**

```java
@EqualsAndHashCode.Exclude
private Set<...> relations;
```

Et utilisez des DTO pour les réponses API au lieu des entités Hibernate.

---

## 📝 Après correction

Une fois le backend corrigé :
1. Redémarrez le backend
2. L'app affichera automatiquement les sous-catégories

---

Copie les fichiers de tes entités (`Categorie.java`, `SousCategorie.java`, `Procedure.java`) et je t'aide à les corriger ! 🔧

