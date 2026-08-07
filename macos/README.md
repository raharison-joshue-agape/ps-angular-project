<div align="center">

# 🅰️ Angular Project Aliases — macOS

### Scaffold des projets **Angular + Angular Material + TypeScript** pré-configurés directement depuis **Zsh**

Des fonctions courtes et mémorisables qui remplacent les longues séquences de configuration par une seule commande.

[![Zsh](https://img.shields.io/badge/Zsh-5.0%2B-C93A32?style=for-the-badge&logo=zsh&logoColor=white)](https://www.zsh.org/)
[![macOS](https://img.shields.io/badge/macOS-ready-000000?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Node.js](https://img.shields.io/badge/Node.js-20%2B-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![Angular](https://img.shields.io/badge/Angular-latest-DD0031?style=for-the-badge&logo=angular&logoColor=white)](https://angular.dev/)
[![Angular Material](https://img.shields.io/badge/Angular%20Material-3-757575?style=for-the-badge&logo=angular&logoColor=white)](https://material.angular.io/)

</div>

---

## 📑 Table des matières

- [✨ Aperçu](#-aperçu)
- [🧰 Prérequis](#-prérequis)
- [📦 Installation](#-installation)
- [🚀 Utilisation](#-utilisation)
- [🧹 Désinstallation](#-désinstallation)
- [🛟 Dépannage](#-dépannage)

---

## ✨ Aperçu

Au lieu de taper de longues commandes de configuration répétitives, vous utilisez des fonctions courtes qui scaffoldent un projet **Angular + TypeScript** complet et pré-configuré en quelques secondes :

```zsh
new_angular myapp              # menu interactif (base ou Angular Material)
new_angular_base myapp         # template Angular + SCSS + Routing de base
new_angular_material myapp     # scaffold direct avec Angular Material
```

Une seule **bibliothèque UI/UX** est incluse : **Angular Material** (la bibliothèque officielle d'Angular, avec Material 3 et le thème azure/blue). Les raccourcis sont organisés dans un **point d'entrée unique** : une seule ligne suffit dans votre `~/.zshrc`. La syntaxe est identique à celle des versions [Windows](../windows/README.md) et [Linux](../linux/README.md) (`new_angular` ⇄ `New-Angular`).

---

## 🧰 Prérequis

| Exigence | Détail |
|---|---|
| **Système** | macOS avec Zsh (shell par défaut depuis Catalina) |
| **Shell** | Zsh 5.0+ |
| **Git** | Installé (Command Line Tools) et accessible dans le `PATH` (initialisation Git optionnelle) |
| **Node.js** | Node.js 20+ avec `npm` disponible dans le `PATH` (utilisé pour scaffolder et installer les dépendances) |

---

## 📦 Installation

### 1. Copier le module dans votre répertoire de configuration

```zsh
mkdir -p "$HOME/.config/alias"
cp -r "macos" "$HOME/.config/alias/angular-aliases-project/"
```

### 2. Ajouter l'import à votre shell

Ajoutez la ligne suivante à votre `~/.zshrc` :

```zsh
. "$HOME/.config/alias/angular-aliases-project/macos/index.zsh"
```

`index.zsh` est le point d'entrée. Il source (`source`) le module Angular Material situé dans son propre répertoire (résolu via `${0:A:h}`), si bien que les raccourcis fonctionnent quel que soit l'endroit où le projet a été copié.

### 3. Recharger votre shell

```zsh
source ~/.zshrc
```

---

## 🚀 Utilisation

Les raccourcis se comportent comme des commandes zsh natives :

```zsh
new_angular myapp              # scaffolde un projet (menu interactif 1-2)
new_angular_base myapp         # template Angular + SCSS + Routing de base
new_angular_material myapp     # Angular + Angular Material (Material 3)
```

### 📦 Créer un projet

```zsh
new_angular myapp
```

Affiche un menu interactif, crée le projet avec `ng new` (sans SSR), installe Angular Material, puis génère le layout, les pages `/home` et **404**, le sélecteur de thème et le thème **Material 3**.

> 💡 Le nom du projet est optionnel : laissez vide pour le saisir interactivement.

| #  | Template                | Description                                   |
|----|-------------------------|-----------------------------------------------|
| 1  | Angular CLI (base)      | Plain Angular + TypeScript template           |
| 2  | Angular CLI + Material  | Official Material Design components (M3)      |

À la fin de la configuration, le script demande si vous voulez initialiser **Git**, puis lance `npm start` (serveur sur **http://localhost:4200**).

### 🎨 Créer un projet avec Angular Material directement

```zsh
new_angular_material myapp
```

### 🖥️ Créer un projet Angular de base

```zsh
new_angular_base myapp
```

Crée un projet **Angular + SCSS + Routing** (`ng new`) sans bibliothèque supplémentaire.

### 🧱 Ce que le template Material inclut

| Élément | Détail |
|---|---|
| **Angular + TypeScript** | Généré avec `ng new` (SCSS, Routing, sans SSR) |
| **Angular Material 3** | `@angular/material`, `@angular/cdk`, `@angular/animations` |
| **Thème Material 3** | Palettes azure/blue, typographie Roboto, densité 0 |
| **ToggleMode** | Sélecteur Clair / Sombre / Système (`mat-button-toggle`) |
| **Routing** | Layout par défaut, page `/home` et page **404** personnalisée |
| **Icônes** | Police Material Symbols Outlined + `mat-icon` |
| **Git** *(optionnel)* | `git init` + premier commit `Initial commit` |
| **Serveur de dev** | Port `4200` via `ng serve` |

Le composant **ToggleMode** applique une classe `.dark` sur `<html>` ; le thème SCSS bascule alors automatiquement les variables `--mat-sys-*` entre mode clair et sombre.

---

## 🧹 Désinstallation

1. Supprimez la ligne d'import de `~/.zshrc`.
2. Supprimez le répertoire :

```zsh
rm -rf "$HOME/.config/alias/angular-aliases-project"
```

---

## 🛟 Dépannage

| Symptôme | Solution |
|---|---|
| Les raccourcis sont indisponibles | Vérifiez le chemin d'import dans `~/.zshrc`, puis rechargez avec `source ~/.zshrc`. |
| `❌ node is not recognized` | Installez Node.js 20+ et assurez-vous qu'il est disponible dans le `PATH`. |
| Le serveur de dev ne démarre pas | Vérifiez que `npm install` a été exécuté par `ng new`. |
| Les icônes ne s'affichent pas | La police Material Symbols Outlined est chargée depuis Google Fonts (connexion requise au premier chargement). |
| Le thème ne change pas | Vérifiez que la classe `.dark` est bien appliquée sur `<html>` par `ToggleMode`. |
| `npm start` bloque le terminal | Normal : `ng serve` reste actif. Sortez avec `Ctrl+C`. |
