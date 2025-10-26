# 📋 Format d'exemple pour les procédures

## Format attendu

Donne-moi quelques exemples de procédures avec leurs relations sous ce format :

```sql
-- Procédure 1
INSERT INTO procedures (nom, titre, description, delai, sous_categorie_id, ...) VALUES (...);

-- Avec centre(s)
INSERT INTO centres (nom, adresse, horaires, telephone, email, ...) VALUES (...);

-- Avec coût(s)
INSERT INTO couts (nom, prix, procedure_id, ...) VALUES (...);

-- Avec documents requis
INSERT INTO documents_requis (nom, description, obligatoire, procedure_id, ...) VALUES (...);

-- Avec étapes
INSERT INTO etapes (titre, description, ordre, procedure_id, ...) VALUES (...);

-- Avec références légales
INSERT INTO references_legales (article, description, procedure_id, ...) VALUES (...);
```

Ou si tu as déjà des données, dis-moi simplement :
- Le nom de la procédure
- Les champs de chaque table liée

---

## 🎯 Ce dont j'ai besoin

Pour créer le bon mapping, j'ai besoin de connaître la **structure exacte** des tables suivantes :

1. **procedures** - Les champs principaux
2. **centres** - Les informations du centre de traitement
3. **couts** - Les coûts associés
4. **documents_requis** - Les documents à fournir
5. **etapes** - Les étapes de la procédure
6. **references_legales** - Les lois/articles appliqués

Donne-moi quelques exemples et je pourrai créer l'écran parfait ! 📝

