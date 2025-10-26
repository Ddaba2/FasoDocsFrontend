// ÉCRAN: PARAMÈTRES (Settings) - CONFIGURATION DE L'APPLICATION
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <<< NOUVEL IMPORT

// Imports de type PACKAGE pour les vues
import 'package:fasodocs/views/report/report_problem_screen.dart';
import 'package:fasodocs/views/help/help_support_screen.dart';
import 'package:fasodocs/views/auth/login_screen.dart';

// >>> CORRECTION DE L'IMPORTATION DU PROVIDER DE THÈME <<<
// Maintenant, on importe directement le fichier main.dart
import '../../main.dart';
import '../../locale/locale_provider.dart';
import '../../locale/locale_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // --- ÉTATS LOCAUX POUR LES PARAMÈTRES ---
  bool _notificationsEnabled = true;
  // bool _darkModeEnabled n'est plus nécessaire car on utilise le provider
  String _selectedLanguage = 'Français';

  static const Color primaryGreen = Color(0xFF14B53A); // Couleur verte de l'icône de retour
  
  @override
  void initState() {
    super.initState();
    // Initialiser la langue actuelle
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    _selectedLanguage = localeProvider.locale.languageCode == 'en' ? 'English' : 'Français';
  }

  // --- LOGIQUE DE GESTION DES NOTIFICATIONS ---
  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });

    if (value) {
      print('Notifications activées.');
    } else {
      print('Notifications désactivées.');
    }
  }

  // --- LOGIQUE DE GESTION DU MODE SOMBRE (THÈME) ---
  void _toggleDarkMode(bool value) {
    // 1. Accéder au provider pour notifier le changement.
    final provider = Provider.of<ThemeModeProvider>(context, listen: false);

    // 2. Déterminer le nouveau mode.
    final newMode = value ? ThemeMode.dark : ThemeMode.light;

    // 3. Notifier le widget parent (FasoDocsApp) pour changer le thème global
    provider.toggleTheme(newMode);

    // Note: on n'a plus besoin de setState pour _darkModeEnabled car le Provider
    // force la reconstruction de tout l'écran, ce qui va synchroniser le Switch.
  }

  @override
  Widget build(BuildContext context) {
    // 1. Accéder au provider de thème pour obtenir l'état actuel et forcer la reconstruction.
    final themeProvider = Provider.of<ThemeModeProvider>(context);

    // 2. Déterminer les couleurs en fonction du thème
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Couleurs du thème global
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
    final itemBackgroundColor = Theme.of(context).cardColor;
    final iconColor = Theme.of(context).iconTheme.color!;

    // Synchroniser l'état local du switch avec l'état global du thème
    bool _darkModeEnabled = isDarkMode;


    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
          title:  Text(

          LocaleHelper.getText(context, 'paramettre'),

          style: TextStyle(

            fontSize: 20,

            fontWeight: FontWeight.bold,

            color: textColor,

          ),

        ),
      ),
      body: SafeArea(
        child: Column(
          children: [



            const SizedBox(height:20),

            // Contenu principal
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Préférences
                    Text(
                      LocaleHelper.getText(context, 'preferences'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor, // Utilisation de la couleur du thème
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Langue
                    _buildSettingsItem(
                      icon: Icons.language,
                      title: LocaleHelper.getText(context, 'language'),
                      itemBackgroundColor: itemBackgroundColor, // Utilisation de la couleur du thème
                      titleColor: textColor, // Utilisation de la couleur du thème
                      iconColor: iconColor, // Utilisation de la couleur du thème
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _selectedLanguage,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ),
                      onTap: _showLanguageDialog,
                    ),

                    const SizedBox(height: 12),

                    // Notifications
                    _buildSettingsItem(
                      icon: Icons.notifications_outlined,
                      title: LocaleHelper.getText(context, 'notification'),
                      itemBackgroundColor: itemBackgroundColor, // Utilisation de la couleur du thème
                      titleColor: textColor, // Utilisation de la couleur du thème
                      iconColor: iconColor, // Utilisation de la couleur du thème
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: _toggleNotifications,
                        // Les couleurs activeColor/inactiveColor sont gérées dans le darkTheme du main.dart
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Mode sombre
                    _buildSettingsItem(
                      icon: Icons.dark_mode_outlined,
                      title: LocaleHelper.getText(context, 'darkMode'),
                      itemBackgroundColor: itemBackgroundColor, // Utilisation de la couleur du thème
                      titleColor: textColor, // Utilisation de la couleur du thème
                      iconColor: iconColor, // Utilisation de la couleur du thème
                      trailing: Switch(
                        value: _darkModeEnabled, // Synchronisé avec le provider
                        onChanged: _toggleDarkMode,
                        // Les couleurs activeColor/inactiveColor sont gérées dans le darkTheme du main.dart
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Section Support
                    Text(
                      LocaleHelper.getText(context, 'support'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor, // Utilisation de la couleur du thème
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Aide et support
                    _buildSettingsItem(
                      icon: Icons.help_outline,
                      title: LocaleHelper.getText(context, 'help'),
                      itemBackgroundColor: itemBackgroundColor, // Utilisation de la couleur du thème
                      titleColor: textColor, // Utilisation de la couleur du thème
                      iconColor: iconColor, // Utilisation de la couleur du thème
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: iconColor.withOpacity(0.5), // Utilisation de la couleur du thème
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Se déconnecter
                    _buildSettingsItem(
                      icon: Icons.logout,
                      title: LocaleHelper.getText(context, 'logOut'),
                      itemBackgroundColor: itemBackgroundColor, // Utilisation de la couleur du thème
                      iconColor: Colors.red,
                      titleColor: Colors.red,
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: iconColor.withOpacity(0.5), // Utilisation de la couleur du thème
                        size: 16,
                      ),
                      onTap: _showLogoutDialog,
                    ),

                    const Spacer(),

                    // Version et copyright
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'FasoDocs v1.0.0',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.grey[500] : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            LocaleHelper.getText(context, 'copyright'),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.grey[600] : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour construire les lignes d'options des paramètres
  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required Widget trailing,
    required Color itemBackgroundColor,
    VoidCallback? onTap,
    Color iconColor = Colors.black, // sera écrasé par la couleur du thème dans build()
    Color titleColor = Colors.black, // sera écrasé par la couleur du thème dans build()
  }) {
    // Les couleurs sont passées directement dans l'appel de _buildSettingsItem dans build()
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: itemBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  // Dialogue pour le choix de la langue
  void _showLanguageDialog() {
    // Les AlertDialogs utilisent maintenant les couleurs du thème global !
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final textColor = Theme.of(context).textTheme.bodyLarge!.color!;
        return AlertDialog(
          // Utilise les couleurs de texte et de fond définies dans main.dart
          title: Text(
            LocaleHelper.getText(context, 'chooseLanguage'),
            style: TextStyle(color: textColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Français', style: TextStyle(color: textColor)),
                leading: Radio<String>(
                  value: 'Français',
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
                    localeProvider.setLocale(const Locale('fr'));
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: Text('English', style: TextStyle(color: textColor)),
                leading: Radio<String>(
                  value: 'English',
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
                    localeProvider.setLocale(const Locale('en'));
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Dialogue de déconnexion
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Utilise les couleurs de texte et de fond définies dans main.dart
          title: Text(LocaleHelper.getText(context, 'logOut')),
          content: Text(LocaleHelper.getText(context, 'logOutConfirmation')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme la boîte de dialogue
              },
              child: Text(LocaleHelper.getText(context, 'cancel'), style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
            ElevatedButton(
              onPressed: () {
                // Étape 1: Fermer la boîte de dialogue
                Navigator.of(context).pop();

                // TODO: Étape 2: Implémenter la logique de déconnexion réelle (ex: suppression du jeton)

                // Étape 3: Naviguer vers l'écran de connexion et supprimer toutes les routes précédentes
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (Route<dynamic> route) => false, // Supprime toutes les routes
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(LocaleHelper.getText(context, 'logOut')),
            ),
          ],
        );
      },
    );
  }
}