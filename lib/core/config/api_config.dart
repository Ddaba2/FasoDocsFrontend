// ========================================================================================
// API CONFIGURATION - Configuration de l'URL du backend Spring Boot
// ========================================================================================

class ApiConfig {
  // URL de base de votre backend Spring Boot
  // Remplacez cette URL par l'adresse de votre backend
  // Exemple pour développement local: 'http://localhost:8080'
  // Exemple pour serveur distant: 'http://votre-serveur.com:8080'
  
  // Pour Android emulator, utilisez 10.0.2.2 au lieu de localhost
  static const String baseUrl = 'http://10.0.2.2:8080/api';
  
  // Pour iOS simulator, vous pouvez utiliser localhost directement
  // static const String baseUrl = 'http://localhost:8080/api';
  
  // Endpoints de l'API
  static const String auth = '/auth';
  static const String users = '/users';
  static const String documents = '/documents';
  static const String categories = '/categories';
  static const String notifications = '/notifications';
  
  // Méthode helper pour construire une URL complète
  static String buildUrl(String endpoint) {
    return baseUrl + endpoint;
  }
}

