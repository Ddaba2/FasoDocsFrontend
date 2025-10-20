// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fasodocs/main.dart';
// Importation de l'écran d'accueil pour référence, si nécessaire pour des tests plus complexes.
import 'package:fasodocs/views/home/home_screen.dart';

void main() {
  testWidgets('FasoDocs application starts and shows the Home Screen elements', (WidgetTester tester) async {
    // 1. Construit l'application (MyApp) et déclenche un rafraîchissement d'écran.
    await tester.pumpWidget(const MyApp());

    // 2. Vérifie la présence d'éléments clés de l'écran d'accueil pour confirmer que l'app a démarré correctement.

    // Vérifie le titre/nom de l'application dans le header (basé sur le code HomeScreen, le texte est 'FacoDocs').
    expect(find.text('FacoDocs'), findsOneWidget, reason: 'Should find the application name "FacoDocs"');

    // Vérifie la présence de la barre de recherche (élément TextField ou son texte indicatif).
    expect(find.byType(TextField), findsOneWidget, reason: 'Should find the main search bar TextField');
    expect(find.text('Rechercher une procedure'), findsOneWidget, reason: 'Should find the search bar hint text');

    // Vérifie la présence de la section "Démarches Populaires"
    expect(find.text('Démarches Populaires'), findsOneWidget, reason: 'Should find the "Démarches Populaires" section title');

    // Vérifie la présence de l'icône de profil (personne) dans le header.
    expect(find.byIcon(Icons.person), findsOneWidget, reason: 'Should find the profile icon');

    // Vérifie la présence du bouton de navigation "Catégorie" dans la BottomNavigationBar
    expect(find.text('Catégorie'), findsOneWidget, reason: 'Should find the "Catégorie" navigation item');
  });
}