// ========================================================================================
// API CONFIGURATION - Configuration de l'URL du backend Spring Boot
// ========================================================================================

class ApiConfig {
  // URL de base de votre backend Spring Boot
  // Remplacez cette URL par l'adresse de votre backend
  // Exemple pour développement local: 'http://localhost:8080'
  // Exemple pour serveur distant: 'http://votre-serveur.com:8080'
  
  // Pour Android emulator, utilisez 10.0.2.2 au lieu de localhost
  // Avec le préfixe /api comme configuré dans Spring Boot
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  
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
  // CHATBOT DJELIA
  // ============================================================================
  static const String chatbotChat = '/chatbot/chat';
  static const String chatbotChatAudio = '/chatbot/chat-audio';
  static const String chatbotTranslate = '/chatbot/translate';
  static const String chatbotSpeak = '/chatbot/speak';
  static const String chatbotTranslateFrToBm = '/chatbot/translate/fr-to-bm';
  static const String chatbotTranslateBmToFr = '/chatbot/translate/bm-to-fr';
  static const String chatbotHealth = '/chatbot/health';
  static const String chatbotReadAudio = '/chatbot/read-audio';
  static const String chatbotReadQuick = '/chatbot/read-quick';
  static const String chatbotTestTranslate = '/chatbot/test-translate';
  
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
  
  // Méthode helper pour construire une URL complète
  static String buildUrl(String endpoint) {
    return baseUrl + endpoint;
  }
}

