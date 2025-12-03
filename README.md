# DocuCrafts - Application de création de documents professionnels

## Fonctionnalités

Cette application Flutter permet de créer différents types de documents professionnels avec une interface moderne et intuitive.

### 1. Splash Page
- Page d'accueil animée avec logo et nom de l'application
- Animation de transition avant d'accéder à la page principale

### 2. Menu principal sous forme de cartes
- Accès aux différents types de documents via des cartes interactives
- Types de documents disponibles :
  - Factures
  - Devis
  - Bons de livraison
  - Cartes de visite
  - CV

### 3. Gestion des paramètres
- Carte "Gestion Produits" pour ajouter, modifier ou supprimer des produits
- Carte "Configuration Documents" pour personnaliser les champs et modèles

### 4. Gestion des documents enregistrés
- Affichage des documents sauvegardés dans une grille de cartes
- Visualisation des documents existants

## Architecture

L'application utilise l'architecture MVVM avec le framework GetX pour la gestion d'état et la navigation.

### Structure des dossiers
- `/lib/app/controllers` - Gestion des états avec GetX
- `/lib/app/pages` - Pages de l'application
- `/lib/app/models` - Modèles de données
- `/lib/app/bindings` - Bindings GetX
- `/lib/routes` - Configuration des routes de l'application

## Fonctionnalités techniques

- Navigation entre les pages avec GetX
- Persistance des données
- Interface utilisateur responsive
- Animations et effets visuels modernes
- Gestion des produits avec nom, prix, description, etc.
- Génération de documents PDF personnalisés

## Installation

1. Clonez le dépôt
2. Exécutez `flutter pub get`
3. Lancez l'application avec `flutter run`

## Technologies utilisées

- Flutter
- Dart
- GetX (gestion d'état et navigation)
- PDF generation
