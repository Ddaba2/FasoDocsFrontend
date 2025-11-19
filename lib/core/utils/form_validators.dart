// ========================================================================================
// VALIDATEURS DE FORMULAIRE - Messages d'erreur clairs et précis
// ========================================================================================

class FormValidators {
  // ============================================================================
  // VALIDATION TÉLÉPHONE
  // ============================================================================
  
  /// Valide un numéro de téléphone
  /// Le numéro doit commencer par 5, 6, 7, 8 ou 9
  static String? validatePhone(String? value, {String? completeNumber}) {
    if (value == null || value.isEmpty) {
      return '📱 Le numéro de téléphone est obligatoire';
    }
    
    // Compter uniquement les chiffres
    final phoneDigits = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (phoneDigits.isEmpty) {
      return '❌ Veuillez saisir un numéro valide';
    }
    
    // ✅ VÉRIFICATION IMPORTANTE : Le numéro doit commencer par 5, 6, 7, 8 ou 9
    if (phoneDigits.isNotEmpty) {
      final firstDigit = phoneDigits[0];
      if (!['5', '6', '7', '8', '9'].contains(firstDigit)) {
        return '❌ Le numéro doit commencer par 5, 6, 7, 8 ou 9';
      }
    }
    
    if (phoneDigits.length < 8) {
      return '📞 Numéro de téléphone incomplet (${phoneDigits.length}/8 chiffres minimum)';
    }
    
    if (phoneDigits.length > 15) {
      return '❌ Numéro trop long (${phoneDigits.length} chiffres, maximum 15)';
    }
    
    // Validation spécifique Mali si indicatif +223
    if (completeNumber != null && completeNumber.startsWith('+223')) {
      if (phoneDigits.length != 8) {
        return '🇲🇱 Un numéro malien doit avoir exactement 8 chiffres';
      }
      
      // Vérifier que le premier chiffre est valide (5, 6, 7, 8 ou 9)
      final firstDigit = phoneDigits[0];
      if (!['5', '6', '7', '8', '9'].contains(firstDigit)) {
        return '❌ Le numéro malien doit commencer par 5, 6, 7, 8 ou 9';
      }
    }
    
    return null; // Pas d'erreur
  }
  
  // ============================================================================
  // VALIDATION EMAIL
  // ============================================================================
  
  /// Valide une adresse email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '📧 L\'adresse email est obligatoire';
    }
    
    // Enlever les espaces
    value = value.trim();
    
    if (value.isEmpty) {
      return '📧 L\'adresse email ne peut pas être vide';
    }
    
    // Vérifier le format général
    if (!value.contains('@')) {
      return '❌ L\'email doit contenir le symbole @';
    }
    
    if (!value.contains('.')) {
      return '❌ L\'email doit contenir un point (.) après le @';
    }
    
    // Expression régulière pour email valide
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return '❌ Format d\'email invalide (ex: exemple@mail.com)';
    }
    
    // Vérifier qu'il n'y a pas d'espaces
    if (value.contains(' ')) {
      return '❌ L\'email ne doit pas contenir d\'espaces';
    }
    
    // Vérifier que @ n'est pas au début ou à la fin
    if (value.startsWith('@') || value.endsWith('@')) {
      return '❌ Le symbole @ ne peut pas être au début ou à la fin';
    }
    
    // Vérifier qu'il y a du texte avant et après @
    final parts = value.split('@');
    if (parts[0].isEmpty) {
      return '❌ L\'email doit avoir du texte avant le @';
    }
    
    if (parts[1].isEmpty || !parts[1].contains('.')) {
      return '❌ L\'email doit avoir un domaine valide après le @';
    }
    
    return null; // Pas d'erreur
  }
  
  // ============================================================================
  // VALIDATION MOT DE PASSE
  // ============================================================================
  
  /// Valide un mot de passe
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return '🔒 Le mot de passe est obligatoire';
    }
    
    if (value.length < minLength) {
      return '❌ Mot de passe trop court (${value.length}/$minLength caractères minimum)';
    }
    
    if (value.length < 8) {
      return '⚠️ Mot de passe faible. Recommandé : 8 caractères minimum';
    }
    
    // Vérifier la complexité (optionnel - peut être activé selon besoin)
    // if (!value.contains(RegExp(r'[A-Z]'))) {
    //   return '⚠️ Le mot de passe devrait contenir au moins une majuscule';
    // }
    
    // if (!value.contains(RegExp(r'[0-9]'))) {
    //   return '⚠️ Le mot de passe devrait contenir au moins un chiffre';
    // }
    
    return null; // Pas d'erreur
  }
  
  /// Valide la confirmation du mot de passe
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return '🔒 Veuillez confirmer votre mot de passe';
    }
    
    if (value != password) {
      return '❌ Les mots de passe ne correspondent pas';
    }
    
    return null; // Pas d'erreur
  }
  
  // ============================================================================
  // VALIDATION NOM/PRÉNOM
  // ============================================================================
  
  /// Valide un nom
  static String? validateName(String? value, {String fieldName = 'Ce champ'}) {
    if (value == null || value.isEmpty) {
      return '📝 $fieldName est obligatoire';
    }
    
    value = value.trim();
    
    if (value.isEmpty) {
      return '📝 $fieldName ne peut pas être vide';
    }
    
    if (value.length < 2) {
      return '❌ $fieldName est trop court (minimum 2 caractères)';
    }
    
    if (value.length > 50) {
      return '❌ $fieldName est trop long (maximum 50 caractères)';
    }
    
    // Vérifier qu'il n'y a que des lettres et espaces
    if (!RegExp(r"^[a-zA-ZÀ-ÿ\s\-']+$").hasMatch(value)) {
      return '❌ $fieldName ne doit contenir que des lettres';
    }
    
    // Vérifier qu'il n'y a pas de chiffres
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return '❌ $fieldName ne doit pas contenir de chiffres';
    }
    
    return null; // Pas d'erreur
  }
  
  /// Valide un nom complet (prénom + nom)
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return '📝 Le nom complet est obligatoire';
    }
    
    value = value.trim();
    
    if (value.isEmpty) {
      return '📝 Le nom complet ne peut pas être vide';
    }
    
    // Vérifier qu'il y a au moins 2 mots
    final names = value.split(RegExp(r'\s+'));
    if (names.length < 2) {
      return '❌ Veuillez saisir votre prénom ET votre nom';
    }
    
    // Vérifier que chaque partie a au moins 2 caractères
    for (var name in names) {
      if (name.length < 2) {
        return '❌ Chaque nom doit avoir au moins 2 caractères';
      }
    }
    
    return null; // Pas d'erreur
  }
  
  // ============================================================================
  // VALIDATION CODE SMS
  // ============================================================================
  
  /// Valide un code SMS/OTP
  static String? validateSmsCode(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return '📱 Le code de vérification est obligatoire';
    }
    
    // Enlever les espaces
    value = value.replaceAll(' ', '');
    
    if (value.isEmpty) {
      return '📱 Veuillez saisir le code reçu par SMS';
    }
    
    if (value.length < length) {
      return '❌ Code incomplet (${value.length}/$length chiffres)';
    }
    
    if (value.length > length) {
      return '❌ Code trop long (${value.length} chiffres, attendu $length)';
    }
    
    // Vérifier que ce sont uniquement des chiffres
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return '❌ Le code doit contenir uniquement des chiffres';
    }
    
    return null; // Pas d'erreur
  }
  
  // ============================================================================
  // VALIDATION CHAMPS REQUIS
  // ============================================================================
  
  /// Valide qu'un champ n'est pas vide
  static String? validateRequired(String? value, {String fieldName = 'Ce champ'}) {
    if (value == null || value.trim().isEmpty) {
      return '❌ $fieldName est obligatoire';
    }
    
    return null; // Pas d'erreur
  }
  
  // ============================================================================
  // VALIDATION MONTANT
  // ============================================================================
  
  /// Valide un montant
  static String? validateAmount(String? value, {String currency = 'FCFA'}) {
    if (value == null || value.isEmpty) {
      return '💰 Le montant est obligatoire';
    }
    
    // Enlever les espaces
    value = value.trim();
    
    if (value.isEmpty) {
      return '💰 Veuillez saisir un montant';
    }
    
    // Vérifier que c'est un nombre
    final amount = double.tryParse(value);
    
    if (amount == null) {
      return '❌ Montant invalide (utilisez uniquement des chiffres)';
    }
    
    if (amount <= 0) {
      return '❌ Le montant doit être supérieur à 0 $currency';
    }
    
    if (amount > 1000000000) {
      return '❌ Montant trop élevé (maximum 1 milliard $currency)';
    }
    
    return null; // Pas d'erreur
  }
  
  // ============================================================================
  // VALIDATION LONGUEUR
  // ============================================================================
  
  /// Valide la longueur d'un texte
  static String? validateLength(
    String? value, {
    int? minLength,
    int? maxLength,
    String fieldName = 'Ce champ',
  }) {
    if (value == null || value.isEmpty) {
      return '❌ $fieldName est obligatoire';
    }
    
    if (minLength != null && value.length < minLength) {
      return '❌ $fieldName trop court (${value.length}/$minLength caractères minimum)';
    }
    
    if (maxLength != null && value.length > maxLength) {
      return '❌ $fieldName trop long (${value.length}/$maxLength caractères maximum)';
    }
    
    return null; // Pas d'erreur
  }
  
  // ============================================================================
  // VALIDATION NUMÉRO CNI
  // ============================================================================
  
  /// Valide un numéro de Carte Nationale d'Identité malienne
  static String? validateCNI(String? value) {
    if (value == null || value.isEmpty) {
      return '🆔 Le numéro de CNI est obligatoire';
    }
    
    // Enlever les espaces et tirets
    value = value.replaceAll(RegExp(r'[\s\-]'), '');
    
    if (value.isEmpty) {
      return '🆔 Le numéro de CNI ne peut pas être vide';
    }
    
    // Format CNI Mali : généralement 10-12 caractères alphanumériques
    if (value.length < 8) {
      return '❌ Numéro de CNI trop court (minimum 8 caractères)';
    }
    
    if (value.length > 15) {
      return '❌ Numéro de CNI trop long (maximum 15 caractères)';
    }
    
    return null; // Pas d'erreur
  }
  
  // ============================================================================
  // UTILITAIRES
  // ============================================================================
  
  /// Vérifie si un champ est vide
  static bool isEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }
  
  /// Nettoie une valeur (enlève les espaces en début et fin)
  static String clean(String? value) {
    return value?.trim() ?? '';
  }
}

