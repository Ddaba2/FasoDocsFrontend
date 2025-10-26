# Problème d'Authentification pour l'Endpoint Profil

## 🔍 Diagnostic

### Erreur Backend
```
statusCode: 400
message: "Erreur lors de la récupération du profil: 
class java.lang.String cannot be cast to class ml.fasodocs.backend.security.UserDetailsImpl"
```

### Cause
Le problème vient du **backend Spring Boot**. Quand l'endpoint `/api/auth/profil` est appelé, le backend essaie de récupérer l'utilisateur authentifié depuis le contexte Spring Security avec un cast incorrect.

## 📊 Analyse des Logs

### Frontend (Flutter) ✅
- L'appel API est **correctement effectué** : `GET http://10.0.2.2:8080/api/auth/profil`
- Les headers sont corrects
- Le format de la requête est valide

### Backend (Spring Boot) ❌
- Erreur de casting dans la récupération de l'authentification
- Le backend reçoit probablement un String au lieu d'un objet `UserDetailsImpl`

## 🔧 Solutions

### Solution 1 : Corriger l'Endpoint Backend

**Fichier**: `AuthController.java` ou le contrôleur gérant `/api/auth/profil`

**Problème probable**:
```java
// ❌ Incorrect
Authentication auth = SecurityContextHolder.getContext().getAuthentication();
String username = auth.getName(); // Récupère correctement

// Mais ensuite :
UserDetailsImpl userDetails = (UserDetailsImpl) auth.getPrincipal();
// ^ Erreur de cast ici
```

**Solution**:
```java
@GetMapping("/profil")
public ResponseEntity<?> getProfil(Authentication authentication) {
    try {
        // Option 1 : Utiliser le paramètre Authentication directement
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new ApiResponse(false, "Non authentifié", null));
        }

        // Option 2 : Récupérer depuis le SecurityContext
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getPrincipal() == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new ApiResponse(false, "Non authentifié", null));
        }

        // Option 3 : Si vous utilisez JWT avec username
        String username = auth.getName();
        Citoyen citoyen = citoyenService.findByTelephone(username);
        
        if (citoyen == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(new ApiResponse(false, "Utilisateur non trouvé", null));
        }

        // Retourner les données du profil
        return ResponseEntity.ok(new ApiResponse(true, "Profil récupéré", citoyen));
        
    } catch (Exception e) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
            .body(new ApiResponse(false, "Erreur: " + e.getMessage(), null));
    }
}
```

### Solution 2 : Vérifier la Configuration JWT/Security

Si vous utilisez JWT, vérifiez que le token est correctement décodé dans votre filtre JWT :

```java
// Dans votre JwtAuthenticationFilter ou JwtTokenProvider
@Override
public Authentication getAuthentication(String token) {
    String username = getUsernameFromToken(token); // ✅ Correct
    
    UserDetails userDetails = userDetailsService.loadUserByUsername(username);
    
    return new UsernamePasswordAuthenticationToken(
        userDetails, 
        null, 
        userDetails.getAuthorities()
    );
}
```

## 🧪 Tests à Effectuer

### 1. Vérifier l'Authentification
```bash
# Test avec curl ou Postman
curl -X GET http://localhost:8080/api/auth/profil \
  -H "Authorization: Bearer VOTRE_TOKEN_JWT"
```

### 2. Vérifier les Logs Backend
Activez les logs pour voir ce qui est reçu :

```java
@GetMapping("/profil")
public ResponseEntity<?> getProfil(Authentication authentication) {
    System.out.println("🔍 Authentication: " + authentication);
    System.out.println("🔍 Principal type: " + (authentication != null ? authentication.getPrincipal().getClass() : "null"));
    System.out.println("🔍 Principal: " + (authentication != null ? authentication.getPrincipal() : "null"));
    
    // ... reste du code
}
```

### 3. Tester avec un Utilisateur Connecté
Assurez-vous qu'un utilisateur est bien connecté avant d'appeler l'endpoint profil.

## 📝 Frontend : Gestion de l'Erreur

Le frontend a été mis à jour pour afficher un message plus clair quand l'utilisateur n'est pas authentifié :

```dart
// Dans profile_screen.dart
if (_errorMessage != null) {
  // Affiche "Authentification requise" au lieu de l'erreur technique
  Text(_errorMessage!),
  ElevatedButton(
    onPressed: () => Navigator.pushNamed(context, '/login'),
    child: Text('Se connecter'),
  ),
}
```

## ✅ Checklist Backend

- [ ] L'endpoint `/api/auth/profil` est protégé par Spring Security
- [ ] Le token JWT est correctement décodé
- [ ] L'objet `Authentication` contient bien le bon type de `Principal`
- [ ] Les logs backend montrent la valeur correcte de `principal.getClass()`
- [ ] L'utilisateur existe dans la base de données avec ce numéro de téléphone

## 🎯 Prochaines Étapes

1. **Vérifier les logs du backend** pour voir exactement où se produit l'erreur
2. **Corriger le cast** dans le contrôleur d'authentification
3. **Tester** avec un utilisateur authentifié
4. **Vérifier** que le JWT est bien décodé si vous utilisez JWT

---

**Note**: Le frontend appelle correctement l'API. Le problème est exclusivement côté backend dans la gestion de l'authentification Spring Security.
