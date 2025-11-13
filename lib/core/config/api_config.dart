// ========================================================================================
// API CONFIGURATION - Configuration de l'URL du backend Spring Boot
// ========================================================================================

class ApiConfig {
  // Détermine dynamiquement l'URL de base selon la plateforme et un override optionnel
  static String get baseUrl {
    // 1) Permettre un override via --dart-define=API_BASE_URL=https://mon-api.exemple/api
    const String override = String.fromEnvironment('API_BASE_URL');
    if (override.isNotEmpty) {
      return override;
    }

    // 2) Web: utiliser l'hôte courant (localhost ou IP LAN) sur le port 8080
    // Cela permet à l'app Web servie depuis http://192.168.x.x de cibler le même hôte
    // Exemple: http://localhost:8080/api ou http://192.168.1.23:8080/api
    // Uri.base fonctionne sur toutes plateformes, mais host est pertinent sur Web
    final String webHost = Uri.base.host;
    if (webHost.isNotEmpty) {
      final String scheme = 'http';
      const int port = 8080;
      return '$scheme://$webHost:$port/api';
    }

    // 3) Par défaut (émulateur Android): 10.0.2.2
     return 'http://10.0.2.2:8080/api';

  // 4) Téléphone Android réel 
 //return 'http://192.168.11.109:8080/api'; 
  }
  
  // Pour iOS simulator, vous pouvez utiliser localhost directement
  // static const String baseUrl = 'http://localhost:8080';
  
  // ============================================================================
  // AUTHENTIFICATION
  // ============================================================================
  static const String authInscription = '/auth/inscription';
  static const String authConnexionTelephone = '/auth/connexion-telephone';
  static const String authConnexion = '/auth/connexion';
  static const String authVerifierSms = '/auth/verifier-sms';
  static const String authVerify = '/auth/verify';
  static const String authProfil = '/auth/profil';
  static const String authDeconnexion = '/auth/deconnexion';
  
  // ============================================================================
  // CATÉGORIES
  // ============================================================================
  // Essayons d'abord sans préfixe /api
  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/$id';
  
  // ============================================================================
  // SOUS-CATÉGORIES
  // ============================================================================
  static const String sousCategories = '/sous-categories';
  static String sousCategorieById(String id) => '/sous-categories/$id';
  static String sousCategorieByCategorie(String categorieId) => '/sous-categories/categorie/$categorieId';
  
  // ============================================================================
  // PROCÉDURES
  // ============================================================================
  static const String procedures = '/procedures';
  static String procedureById(String id) => '/procedures/$id';
  static String procedureByCategorie(String categorieId) => '/procedures/categorie/$categorieId';
  static String procedureBySousCategorie(String sousCategorieId) => '/procedures/sous-categorie/$sousCategorieId';
  static const String procedureRechercher = '/procedures/rechercher';
  
  // ============================================================================
  // NOTIFICATIONS
  // ============================================================================
  static const String notifications = '/notifications';
  static const String notificationsNonLues = '/notifications/non-lues';
  static const String notificationsCountNonLues = '/notifications/count-non-lues';
  static String notificationLire(String id) => '/notifications/$id/lire';
  static const String notificationsLireTout = '/notifications/lire-tout';
  
  // ============================================================================
  // SIGNALEMENTS
  // ============================================================================
  static const String signalements = '/signalements';
  static String signalementById(String id) => '/signalements/$id';
  static const String signalementTypes = '/signalements/types'; // Correct endpoint for signalement types
  
  // Méthode helper pour construire une URL complète
  static String buildUrl(String endpoint) {
    return baseUrl + endpoint;
  }
}