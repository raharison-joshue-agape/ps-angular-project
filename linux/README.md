<div align="center">

# 🅰️ Angular Project Aliases — Linux

### Scaffold des projets **Angular + Angular Material / PrimeNG / ng-zorro-antd + TypeScript** pré-configurés directement depuis **Bash**

Des fonctions courtes et mémorisables qui remplacent les longues séquences de configuration par une seule commande.

[![Bash](https://img.shields.io/badge/Bash-4.0%2B-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Linux](https://img.shields.io/badge/Linux-ready-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://www.linux.org/)
[![Node.js](https://img.shields.io/badge/Node.js-20%2B-339933?style=for-the-badge&logo=nodedotjs&logoColor=white)](https://nodejs.org/)
[![Angular](https://img.shields.io/badge/Angular-latest-DD0031?style=for-the-badge&logo=angular&logoColor=white)](https://angular.dev/)
[![Angular Material](https://img.shields.io/badge/Angular%20Material-3-757575?style=for-the-badge&logo=angular&logoColor=white)](https://material.angular.io/)
[![PrimeNG](https://img.shields.io/badge/PrimeNG-latest-16A34A?style=for-the-badge&logo=primeng&logoColor=white)](https://primeng.org/)
[![ng-zorro](https://img.shields.io/badge/ng--zorro%20antd-latest-1677FF?style=for-the-badge&logo=antdesign&logoColor=white)](https://ng.ant.design/)

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

```bash
new_angular myapp              # menu interactif (base, Material, PrimeNG ou ng-zorro)
new_angular_base myapp         # template Angular + SCSS + Routing de base
new_angular_material myapp     # scaffold direct avec Angular Material
new_angular_primeng myapp      # scaffold direct avec PrimeNG
new_angular_ngzorro myapp      # scaffold direct avec ng-zorro-antd (Ant Design)
```

Trois **bibliothèques UI/UX** sont disponibles : **Angular Material** (la bibliothèque officielle d'Angular, avec Material 3 et le thème azure/blue), **PrimeNG** (80+ composants enterprise, thème Aura) et **ng-zorro-antd** (Ant Design, 70+ composants, i18n). Les raccourcis sont organisés dans un **point d'entrée unique** : une seule ligne suffit dans votre `~/.bashrc`. La syntaxe est identique à celle de la [version Windows](../windows/README.md) (`new_angular` ⇄ `New-Angular`, `new_angular_ngzorro` ⇄ `New-AngularNgZorro`).

---

## 🧰 Prérequis

| Exigence | Détail |
|---|---|
| **Système** | Toute distribution Linux récente |
| **Shell** | Bash 4.0+ (shell par défaut) |
| **Git** | Installé et accessible dans le `PATH` (initialisation Git optionnelle) |
| **Node.js** | Node.js 20+ avec `npm` disponible dans le `PATH` (utilisé pour scaffolder et installer les dépendances) |

---

## 📦 Installation

### 1. Copier le module dans votre répertoire de configuration

```bash
mkdir -p "$HOME/.config/alias"
cp -r "linux" "$HOME/.config/alias/angular-aliases-project/"
```

### 2. Ajouter l'import à votre shell

Ajoutez la ligne suivante à votre `~/.bashrc` :

```bash
. "$HOME/.config/alias/angular-aliases-project/linux/index.sh"
```

`index.sh` est le point d'entrée. Il source (`source`) les modules Angular Material, PrimeNG et ng-zorro-antd situés dans son propre répertoire, si bien que les raccourcis fonctionnent quel que soit l'endroit où le projet a été copié.

### 3. Recharger votre shell

```bash
source ~/.bashrc
```

---

## 🚀 Utilisation

Les raccourcis se comportent comme des commandes bash natives :

```bash
new_angular myapp              # scaffolde un projet (menu interactif 1-4)
new_angular_base myapp         # template Angular + SCSS + Routing de base
new_angular_material myapp     # Angular + Angular Material (Material 3)
new_angular_primeng myapp      # Angular + PrimeNG (thème Aura)
new_angular_ngzorro myapp      # Angular + ng-zorro-antd (Ant Design)
```

### 📦 Créer un projet

```bash
new_angular myapp
```

Affiche un menu interactif, crée le projet avec `ng new` (sans SSR), installe la bibliothèque choisie, puis génère le layout, les pages `/home` et **404**, le sélecteur de thème et le thème correspondant.

> 💡 Le nom du projet est optionnel : laissez vide pour le saisir interactivement.

| #  | Template                | Description                                   |
|----|-------------------------|-----------------------------------------------|
| 1  | Angular CLI (base)      | Plain Angular + TypeScript template           |
| 2  | Angular CLI + Material  | Official Material Design components (M3)      |
| 3  | Angular CLI + PrimeNG   | Enterprise-ready UI component library (Aura)  |
| 4  | Angular CLI + ng-zorro  | Ant Design components (ng-zorro-antd)         |

À la fin de la configuration, le script demande si vous voulez initialiser **Git**, puis lance `npm start` (serveur sur **http://localhost:4200**).

### 🎨 Créer un projet avec une bibliothèque précise

```bash
new_angular_material myapp    # Angular Material (Material 3)
new_angular_primeng myapp     # PrimeNG (thème Aura)
new_angular_ngzorro myapp     # ng-zorro-antd (Ant Design)
```

### 🖥️ Créer un projet Angular de base

```bash
new_angular_base myapp
```

Crée un projet **Angular + SCSS + Routing** (`ng new`) sans bibliothèque supplémentaire.

### 🧱 Ce que chaque template inclut

| Élément | Material | PrimeNG | ng-zorro-antd |
|---|---|---|---|
| **Angular + TypeScript** | `ng new` (SCSS, Routing, sans SSR) | `ng new` (SCSS, Routing, sans SSR) | `ng new` (SCSS, Routing, sans SSR) |
| **Bibliothèque** | `@angular/material`, `@angular/cdk`, `@angular/animations` | `primeng`, `@primeuix/themes`, `primeicons`, `@angular/animations` | `ng-zorro-antd`, `@ant-design/icons-angular`, `@angular/cdk`, `@angular/animations` |
| **Thème** | Material 3 (azure/blue, Roboto) | Aura (`@primeuix/themes`) | Ant Design (clair/sombre via `ng-zorro-antd.css` + `.dark`) |
| **ToggleMode** | Sélecteur Clair / Sombre / Système (`mat-button-toggle`) | Sélecteur Clair / Sombre / Système (`p-selectbutton`) | Sélecteur Clair / Sombre / Système (`nz-segmented`) |
| **Routing** | Layout par défaut, `/home` + **404** | Layout par défaut, `/home` + **404** | Layout par défaut, `/home` + **404** |
| **Icônes** | Material Symbols Outlined | PrimeIcons (`pi pi-*`) | Ant Design Icons (`nz-icon`) |
| **Git** *(optionnel)* | `git init` + premier commit | `git init` + premier commit | `git init` + premier commit |
| **Serveur de dev** | Port `4200` via `ng serve` | Port `4200` via `ng serve` | Port `4200` via `ng serve` |

Le composant **ToggleMode** applique une classe `.dark` sur `<html>` ; le thème bascule alors automatiquement entre mode clair et sombre (variables `--mat-sys-*` pour Material, `--p-*` pour PrimeNG, bundle `ng-zorro-antd.dark.css` pour ng-zorro).

---

## 🧹 Désinstallation

1. Supprimez la ligne d'import de `~/.bashrc`.
2. Supprimez le répertoire :

```bash
rm -rf "$HOME/.config/alias/angular-aliases-project"
```

---

## 🛟 Dépannage

| Symptôme | Solution |
|---|---|
| Les raccourcis sont indisponibles | Vérifiez le chemin d'import dans `~/.bashrc`, puis rechargez avec `source ~/.bashrc`. |
| `❌ node is not recognized` | Installez Node.js 20+ et assurez-vous qu'il est disponible dans le `PATH`. |
| Le serveur de dev ne démarre pas | Vérifiez que `npm install` a été exécuté par `ng new`. |
| Les icônes ne s'affichent pas | Material Symbols Outlined est chargée depuis Google Fonts (connexion requise) ; PrimeIcons et les icônes Ant Design sont embarquées dans `primeicons` / `@ant-design/icons-angular`. |
| Le thème ne change pas | Vérifiez que la classe `.dark` est bien appliquée sur `<html>` par `ToggleMode`. |
| `npm start` bloque le terminal | Normal : `ng serve` reste actif. Sortez avec `Ctrl+C`. |
