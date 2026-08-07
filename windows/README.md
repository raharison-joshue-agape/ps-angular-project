<div align="center">

# 🅰️ Angular Project Aliases — Windows

### Scaffold des projets **Angular + Angular Material + TypeScript** pré-configurés directement depuis **PowerShell**

Des fonctions courtes et mémorisables qui remplacent les longues séquences de configuration par une seule commande.

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=for-the-badge&logo=powershell&logoColor=white)](https://learn.microsoft.com/powershell/)
[![Windows](https://img.shields.io/badge/Windows-ready-0078D6?style=for-the-badge&logo=windows&logoColor=white)](https://www.microsoft.com/windows)
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
- [📖 Aide intégrée](#-aide-intégrée)
- [🧹 Désinstallation](#-désinstallation)
- [🛟 Dépannage](#-dépannage)

---

## ✨ Aperçu

Au lieu de taper de longues commandes de configuration répétitives, vous utilisez des fonctions courtes qui scaffoldent un projet **Angular + TypeScript** complet et pré-configuré en quelques secondes :

```powershell
New-Angular myapp              # menu interactif (base, Material ou PrimeNG)
New-AngularBase myapp          # template Angular + SCSS + Routing de base
New-AngularMaterial myapp      # scaffold direct avec Angular Material
New-AngularPrimeNg myapp       # scaffold direct avec PrimeNG
```

Deux **bibliothèques UI/UX** sont disponibles : **Angular Material** (la bibliothèque officielle d'Angular, avec Material 3 et le thème azure/blue) et **PrimeNG** (80+ composants enterprise, thème Aura). Les raccourcis sont organisés dans un **point d'entrée unique** : une seule ligne suffit dans votre profil PowerShell.

---

## 🧰 Prérequis

| Exigence | Détail |
|---|---|
| **Système** | Windows 10 ou 11 |
| **Shell** | Windows PowerShell 5.1+ ou PowerShell 7 |
| **Git** | [Git for Windows](https://git-scm.com/download/win) installé et disponible dans le `PATH` (initialisation Git optionnelle) |
| **Node.js** | Node.js 20+ avec `npm` disponible dans le `PATH` (utilisé pour scaffolder et installer les dépendances) |

---

## 📦 Installation

### 1. Copier le module dans votre répertoire de configuration

```powershell
New-Item -ItemType Directory -Path "$HOME\.config\alias" -Force
Copy-Item -Path "windows" -Destination "$HOME\.config\alias\angular-aliases-project\" -Recurse
```

### 2. Vérifier que votre profil PowerShell existe

```powershell
Test-Path $PROFILE
```

- `True` → votre profil existe, passez à l'étape 4.
- `False` → créez-le :

```powershell
New-Item -Path $PROFILE -ItemType File -Force
```

### 3. Ouvrir votre profil

```powershell
notepad $PROFILE
```

ou avec Visual Studio Code :

```powershell
code $PROFILE
```

### 4. Importer les raccourcis

Ajoutez la ligne suivante à votre profil :

```powershell
. "$HOME\.config\alias\angular-aliases-project\windows\index.ps1"
```

`index.ps1` est le point d'entrée. Il source (`dot-source`) le module Angular Material situé dans son propre répertoire, si bien que les raccourcis fonctionnent quel que soit l'endroit où le projet a été copié.

### 5. Recharger votre profil

```powershell
. $PROFILE
```

---

## 🚀 Utilisation

Les raccourcis se comportent comme des commandes PowerShell natives :

```powershell
New-Angular myapp              # scaffolde un projet (menu interactif 1-3)
New-AngularBase myapp          # template Angular + SCSS + Routing de base
New-AngularMaterial myapp      # Angular + Angular Material (Material 3)
New-AngularPrimeNg myapp       # Angular + PrimeNG (thème Aura)
Get-Help New-Angular           # affiche la documentation commentée
```

### 📦 Créer un projet

```powershell
New-Angular myapp
```

Affiche un menu interactif, crée le projet avec `ng new` (sans SSR), installe la bibliothèque choisie, puis génère le layout, les pages `/home` et **404**, le sélecteur de thème et le thème correspondant.

> 💡 Le nom du projet est optionnel : laissez vide pour le saisir interactivement.

| #  | Template                | Description                                   |
|----|-------------------------|-----------------------------------------------|
| 1  | Angular CLI (base)      | Plain Angular + TypeScript template           |
| 2  | Angular CLI + Material  | Official Material Design components (M3)      |
| 3  | Angular CLI + PrimeNG   | Enterprise-ready UI component library (Aura)  |

À la fin de la configuration, le script demande si vous voulez initialiser **Git**, puis lance `npm start` (serveur sur **http://localhost:4200**).

### 🎨 Créer un projet avec une bibliothèque précise

```powershell
New-AngularMaterial myapp    # Angular Material (Material 3)
New-AngularPrimeNg myapp     # PrimeNG (thème Aura)
```

### 🖥️ Créer un projet Angular de base

```powershell
New-AngularBase myapp
```

Crée un projet **Angular + SCSS + Routing** (`ng new`) sans bibliothèque supplémentaire.

### 🧱 Ce que chaque template inclut

| Élément | Material | PrimeNG |
|---|---|---|
| **Angular + TypeScript** | `ng new` (SCSS, Routing, sans SSR) | `ng new` (SCSS, Routing, sans SSR) |
| **Bibliothèque** | `@angular/material`, `@angular/cdk`, `@angular/animations` | `primeng`, `@primeuix/themes`, `primeicons`, `@angular/animations` |
| **Thème** | Material 3 (azure/blue, Roboto) | Aura (`@primeuix/themes`) |
| **ToggleMode** | Sélecteur Clair / Sombre / Système (`mat-button-toggle`) | Sélecteur Clair / Sombre / Système (`p-selectbutton`) |
| **Routing** | Layout par défaut, `/home` + **404** | Layout par défaut, `/home` + **404** |
| **Icônes** | Material Symbols Outlined | PrimeIcons (`pi pi-*`) |
| **Git** *(optionnel)* | `git init` + premier commit | `git init` + premier commit |
| **Serveur de dev** | Port `4200` via `ng serve` | Port `4200` via `ng serve` |

Le composant **ToggleMode** applique une classe `.dark` sur `<html>` ; le thème bascule alors automatiquement entre mode clair et sombre (variables `--mat-sys-*` pour Material, `--p-*` pour PrimeNG).

---

## 📖 Aide intégrée

| Commande | Description |
|---|---|
| `Get-Help <fonction>` | Documentation commentée de n'importe quel raccourci (paramètres, exemples) |

```powershell
Get-Help New-Angular
Get-Help New-AngularMaterial -Detailed
```

---

## 🧹 Désinstallation

1. Supprimez la ligne d'import de `$PROFILE`.
2. Supprimez le répertoire :

```powershell
Remove-Item -Path "$HOME\.config\alias\angular-aliases-project" -Recurse -Force
```

---

## 🛟 Dépannage

| Symptôme | Solution |
|---|---|
| Les raccourcis sont indisponibles | Vérifiez le chemin d'import dans `$PROFILE`, puis rechargez avec `. $PROFILE`. |
| `❌ node is not recognized` | Installez Node.js 20+ et assurez-vous qu'il est disponible dans le `PATH`. |
| Le serveur de dev ne démarre pas | Vérifiez que `npm install` a été exécuté par `ng new`. |
| Les icônes ne s'affichent pas | Material Symbols Outlined est chargée depuis Google Fonts (connexion requise) ; les icônes PrimeIcons sont embarquées avec `primeicons`. |
| Le thème ne change pas | Vérifiez que la classe `.dark` est bien appliquée sur `<html>` par `ToggleMode`. |
| Profil introuvable | Vérifiez que `$PROFILE` existe avec `Test-Path $PROFILE`, en le créant si nécessaire. |
