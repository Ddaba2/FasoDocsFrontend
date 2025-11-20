// ========================================================================================
// LOCALE HELPER - Accès facile aux traductions
// ========================================================================================

import 'package:flutter/material.dart';
import 'locale_fr.dart';
import 'locale_en.dart';

class LocaleHelper {
  // Obtenir le texte traduit
  static String getText(BuildContext context, String key) {
    final locale = Localizations.localeOf(context);
    
    if (locale.languageCode == 'en') {
      return _getEnglishText(key);
    } else {
      return _getFrenchText(key);
    }
  }
  
  static String _getEnglishText(String key) {
    // Utilisation d'une map pour faciliter l'accès
    final Map<String, String> translations = {
      // Général
      'appName': LocaleEn.appName,
      'paramettre': LocaleEn.paramettre,
      'categories': LocaleEn.categories,
      'preferences': LocaleEn.preferences,
      'support': LocaleEn.support,
      'help': LocaleEn.help,
      'logOut': LocaleEn.logOut,
      'language': 'Language',
      'notification': 'Notification',
      'darkMode': 'Dark mode',
      'chooseLanguage': 'Choose language',
      'copyright': '© 2025 FasoDocs. All rights reserved.',
      'logOutConfirmation': LocaleEn.logOutConfirmation,
      'cancel': LocaleEn.cancel,
      'home': 'Home',
      'category': 'Category',
      'quiz': LocaleEn.quiz,
      'announcements': 'Announcements',
      'options': 'Options',
      'searchProcedure': 'Search a procedure',
      'welcomeMessage': 'Welcome to FasoDocs',
      'subtitleMessage': 'Your administrative procedures simplified',
      'popularProcedures': 'Popular Procedures',
      'reportProblem': 'Report a problem',
      'allArticleLaws': 'All article laws',
      
      // Catégories principales
      'identityAndCitizenship': LocaleEn.identityAndCitizenship,
      'businessCreation': LocaleEn.businessCreation,
      'autoDocuments': LocaleEn.autoDocuments,
      'landServices': LocaleEn.landServices,
      'utilities': LocaleEn.utilities,
      'justice': LocaleEn.justice,
      'taxAndCustoms': LocaleEn.taxAndCustoms,
      
      // Identity
      'identityScreenTitle': LocaleEn.identityScreenTitle,
      'birthCertificate': LocaleEn.birthCertificate,
      'marriageCertificate': LocaleEn.marriageCertificate,
      'divorceRequest': LocaleEn.divorceRequest,
      'deathCertificate': LocaleEn.deathCertificate,
      'nationalityCertificate': LocaleEn.nationalityCertificate,
      'criminalRecord': LocaleEn.criminalRecord,
      'nationalIdCard': LocaleEn.nationalIdCard,
      'passport': LocaleEn.passport,
      'nationality': LocaleEn.nationality,
      'voterCard': LocaleEn.voterCard,
      'residenceCard': LocaleEn.residenceCard,
      'electoralRegistration': LocaleEn.electoralRegistration,
      
      // Auto
      'autoScreenTitle': LocaleEn.autoScreenTitle,
      'drivingLicense': LocaleEn.drivingLicense,
      'vehicleCard': LocaleEn.vehicleCard,
      'technicalInspection': LocaleEn.technicalInspection,
      'vignette': LocaleEn.vignette,
      'plateColorChange': LocaleEn.plateColorChange,
      
      // Business
      'businessScreenTitle': LocaleEn.businessScreenTitle,
      'soleProprietorship': LocaleEn.soleProprietorship,
      'ltdCompany': LocaleEn.ltdCompany,
      'singlePersonLtd': LocaleEn.singlePersonLtd,
      'publicCompany': LocaleEn.publicCompany,
      'generalPartnership': LocaleEn.generalPartnership,
      'limitedPartnership': LocaleEn.limitedPartnership,
      'sasCompany': LocaleEn.sasCompany,
      'sasuCompany': LocaleEn.sasuCompany,
      
      // Justice
      'justiceScreenTitle': LocaleEn.justiceScreenTitle,
      'theftReport': LocaleEn.theftReport,
      'lossReport': LocaleEn.lossReport,
      'disputeResolution': LocaleEn.disputeResolution,
      'prisonVisit': LocaleEn.prisonVisit,
      'appeal': LocaleEn.appeal,
      'conditionalRelease': LocaleEn.conditionalRelease,
      'provisionalRelease': LocaleEn.provisionalRelease,
      'weaponAuthorization': LocaleEn.weaponAuthorization,
      'minorSaleAuthorization': LocaleEn.minorSaleAuthorization,
      
      // Land
      'landScreenTitle': LocaleEn.landScreenTitle,
      'buildingPermit': LocaleEn.buildingPermit,
      'leaseRequest': LocaleEn.leaseRequest,
      'landTitle': LocaleEn.landTitle,
      'titleVerification': LocaleEn.titleVerification,
      'ruralConcession': LocaleEn.ruralConcession,
      'occupationPermit': LocaleEn.occupationPermit,
      'housingTransfer': LocaleEn.housingTransfer,
      'provisionalToFinal': LocaleEn.provisionalToFinal,
      'urbanConcession': LocaleEn.urbanConcession,
      
      // Utilities
      'utilitiesScreenTitle': LocaleEn.utilitiesScreenTitle,
      'waterMeterRequest': LocaleEn.waterMeterRequest,
      'electricityMeterRequest': LocaleEn.electricityMeterRequest,
      'waterMeterRecovery': LocaleEn.waterMeterRecovery,
      'electricityMeterRecovery': LocaleEn.electricityMeterRecovery,
      'waterMeterTransfer': LocaleEn.waterMeterTransfer,
      'electricityMeterTransfer': LocaleEn.electricityMeterTransfer,
      
      // Tax
      'taxScreenTitle': LocaleEn.taxScreenTitle,
      'propertyIncomeDeclaration': LocaleEn.propertyIncomeDeclaration,
      'vatDeclaration': LocaleEn.vatDeclaration,
      'contractRegistration': LocaleEn.contractRegistration,
      'salaryTax': LocaleEn.salaryTax,
      'employerContribution': LocaleEn.employerContribution,
      'housingTax': LocaleEn.housingTax,
      'solidarityContribution': LocaleEn.solidarityContribution,
      'tobaccoTax': LocaleEn.tobaccoTax,
      'businessIncomeTax': LocaleEn.businessIncomeTax,
      'syntheticTax': LocaleEn.syntheticTax,
      'agriculturalIncomeTax': LocaleEn.agriculturalIncomeTax,
      'securitiesIncomeTax': LocaleEn.securitiesIncomeTax,
      'propertyIncomeTax': LocaleEn.propertyIncomeTax,
      'propertyTax': LocaleEn.propertyTax,
      'professionalPatent': LocaleEn.professionalPatent,
      'marketPatent': LocaleEn.marketPatent,
      'tourismTax': LocaleEn.tourismTax,
      'vehicleTax': LocaleEn.vehicleTax,
      'roadTransportTax': LocaleEn.roadTransportTax,
      'deductions': LocaleEn.deductions,
      'publicProcurementFee': LocaleEn.publicProcurementFee,
      'specialProductTax': LocaleEn.specialProductTax,
      'financialActivitiesTax': LocaleEn.financialActivitiesTax,
      'petroleumTax': LocaleEn.petroleumTax,
      'airlineTicketFee': LocaleEn.airlineTicketFee,
      'telecommunicationsTax': LocaleEn.telecommunicationsTax,
      'insuranceTax': LocaleEn.insuranceTax,
      'goldExportTax': LocaleEn.goldExportTax,
      'firearmTax': LocaleEn.firearmTax,
      
      // Procedure tab titles
      'etapes': LocaleEn.etapes,
      'montant': LocaleEn.montant,
      'gratuit': LocaleEn.gratuit,
      'documents': LocaleEn.documents,
      'lois': LocaleEn.lois,
      'centres': LocaleEn.centres,
    };
    
    return translations[key] ?? key;
  }
  
  static String _getFrenchText(String key) {
    final Map<String, String> translations = {
      // Général
      'appName': LocaleFr.appName,
      'paramettre': LocaleFr.paramettre,
      'categories': LocaleFr.categories,
      'preferences': LocaleFr.preferences,
      'support': LocaleFr.support,
      'help': LocaleFr.help,
      'logOut': LocaleFr.logOut,
      'language': 'Langue',
      'notification': 'Notification',
      'darkMode': 'Mode sombre',
      'chooseLanguage': 'Choisir la langue',
      'copyright': '© 2025 FasoDocs. Tous droits réservés.',
      'logOutConfirmation': LocaleFr.logOutConfirmation,
      'cancel': LocaleFr.cancel,
      'home': 'Accueil',
      'category': 'Catégorie',
      'quiz': LocaleFr.quiz,
      'announcements': 'Communiqués',
      'options': 'Paramètre',
      'searchProcedure': 'Rechercher une procedure',
      'welcomeMessage': 'Bienvenue sur FasoDocs',
      'subtitleMessage': 'Vos démarches administratives simplifiées',
      'popularProcedures': 'Démarches Populaires',
      'reportProblem': 'Signaler un problème',
      'allArticleLaws': 'Toutes les lois d\'article',
      
      // Catégories principales
      'identityAndCitizenship': LocaleFr.identityAndCitizenship,
      'businessCreation': LocaleFr.businessCreation,
      'autoDocuments': LocaleFr.autoDocuments,
      'landServices': LocaleFr.landServices,
      'utilities': LocaleFr.utilities,
      'justice': LocaleFr.justice,
      'taxAndCustoms': LocaleFr.taxAndCustoms,
      
      // Identity
      'identityScreenTitle': LocaleFr.identityScreenTitle,
      'birthCertificate': LocaleFr.birthCertificate,
      'marriageCertificate': LocaleFr.marriageCertificate,
      'divorceRequest': LocaleFr.divorceRequest,
      'deathCertificate': LocaleFr.deathCertificate,
      'nationalityCertificate': LocaleFr.nationalityCertificate,
      'criminalRecord': LocaleFr.criminalRecord,
      'nationalIdCard': LocaleFr.nationalIdCard,
      'passport': LocaleFr.passport,
      'nationality': LocaleFr.nationality,
      'voterCard': LocaleFr.voterCard,
      'residenceCard': LocaleFr.residenceCard,
      'electoralRegistration': LocaleFr.electoralRegistration,
      
      // Auto
      'autoScreenTitle': LocaleFr.autoScreenTitle,
      'drivingLicense': LocaleFr.drivingLicense,
      'vehicleCard': LocaleFr.vehicleCard,
      'technicalInspection': LocaleFr.technicalInspection,
      'vignette': LocaleFr.vignette,
      'plateColorChange': LocaleFr.plateColorChange,
      
      // Business
      'businessScreenTitle': LocaleFr.businessScreenTitle,
      'soleProprietorship': LocaleFr.soleProprietorship,
      'ltdCompany': LocaleFr.ltdCompany,
      'singlePersonLtd': LocaleFr.singlePersonLtd,
      'publicCompany': LocaleFr.publicCompany,
      'generalPartnership': LocaleFr.generalPartnership,
      'limitedPartnership': LocaleFr.limitedPartnership,
      'sasCompany': LocaleFr.sasCompany,
      'sasuCompany': LocaleFr.sasuCompany,
      
      // Justice
      'justiceScreenTitle': LocaleFr.justiceScreenTitle,
      'theftReport': LocaleFr.theftReport,
      'lossReport': LocaleFr.lossReport,
      'disputeResolution': LocaleFr.disputeResolution,
      'prisonVisit': LocaleFr.prisonVisit,
      'appeal': LocaleFr.appeal,
      'conditionalRelease': LocaleFr.conditionalRelease,
      'provisionalRelease': LocaleFr.provisionalRelease,
      'weaponAuthorization': LocaleFr.weaponAuthorization,
      'minorSaleAuthorization': LocaleFr.minorSaleAuthorization,
      
      // Land
      'landScreenTitle': LocaleFr.landScreenTitle,
      'buildingPermit': LocaleFr.buildingPermit,
      'leaseRequest': LocaleFr.leaseRequest,
      'landTitle': LocaleFr.landTitle,
      'titleVerification': LocaleFr.titleVerification,
      'ruralConcession': LocaleFr.ruralConcession,
      'occupationPermit': LocaleFr.occupationPermit,
      'housingTransfer': LocaleFr.housingTransfer,
      'provisionalToFinal': LocaleFr.provisionalToFinal,
      'urbanConcession': LocaleFr.urbanConcession,
      
      // Utilities
      'utilitiesScreenTitle': LocaleFr.utilitiesScreenTitle,
      'waterMeterRequest': LocaleFr.waterMeterRequest,
      'electricityMeterRequest': LocaleFr.electricityMeterRequest,
      'waterMeterRecovery': LocaleFr.waterMeterRecovery,
      'electricityMeterRecovery': LocaleFr.electricityMeterRecovery,
      'waterMeterTransfer': LocaleFr.waterMeterTransfer,
      'electricityMeterTransfer': LocaleFr.electricityMeterTransfer,
      
      // Tax
      'taxScreenTitle': LocaleFr.taxScreenTitle,
      'propertyIncomeDeclaration': LocaleFr.propertyIncomeDeclaration,
      'vatDeclaration': LocaleFr.vatDeclaration,
      'contractRegistration': LocaleFr.contractRegistration,
      'salaryTax': LocaleFr.salaryTax,
      'employerContribution': LocaleFr.employerContribution,
      'housingTax': LocaleFr.housingTax,
      'solidarityContribution': LocaleFr.solidarityContribution,
      'tobaccoTax': LocaleFr.tobaccoTax,
      'businessIncomeTax': LocaleFr.businessIncomeTax,
      'syntheticTax': LocaleFr.syntheticTax,
      'agriculturalIncomeTax': LocaleFr.agriculturalIncomeTax,
      'securitiesIncomeTax': LocaleFr.securitiesIncomeTax,
      'propertyIncomeTax': LocaleFr.propertyIncomeTax,
      'propertyTax': LocaleFr.propertyTax,
      'professionalPatent': LocaleFr.professionalPatent,
      'marketPatent': LocaleFr.marketPatent,
      'tourismTax': LocaleFr.tourismTax,
      'vehicleTax': LocaleFr.vehicleTax,
      'roadTransportTax': LocaleFr.roadTransportTax,
      'deductions': LocaleFr.deductions,
      'publicProcurementFee': LocaleFr.publicProcurementFee,
      'specialProductTax': LocaleFr.specialProductTax,
      'financialActivitiesTax': LocaleFr.financialActivitiesTax,
      'petroleumTax': LocaleFr.petroleumTax,
      'airlineTicketFee': LocaleFr.airlineTicketFee,
      'telecommunicationsTax': LocaleFr.telecommunicationsTax,
      'insuranceTax': LocaleFr.insuranceTax,
      'goldExportTax': LocaleFr.goldExportTax,
      'firearmTax': LocaleFr.firearmTax,
      
      // Titres des onglets de procédure
      'etapes': LocaleFr.etapes,
      'montant': LocaleFr.montant,
      'gratuit': LocaleFr.gratuit,
      'documents': LocaleFr.documents,
      'lois': LocaleFr.lois,
      'centres': LocaleFr.centres,
    };
    
    return translations[key] ?? key;
  }
}

