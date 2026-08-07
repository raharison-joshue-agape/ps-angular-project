#!/usr/bin/env bash
# index.sh — Point d'entrée Linux (bash) : charge les modules Angular scaffolding.
# Usage : . "$HOME/.config/alias/angular-aliases-project/linux/index.sh"

_angular_aliases_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$_angular_aliases_root/angularMaterial.sh"
. "$_angular_aliases_root/primeng.sh"
. "$_angular_aliases_root/ngZorro.sh"
. "$_angular_aliases_root/ngxBootstrap.sh"

new_angular_base() {
    local PROJECT_NAME="${1:-}"

    if [ -z "$PROJECT_NAME" ]; then
        read -r -p "Project name: " PROJECT_NAME
    fi

    echo "Creating project: $PROJECT_NAME (Angular + SCSS + Routing)"
    npx -y @angular/cli@latest new "$PROJECT_NAME" --defaults --style=scss --routing --skip-git --skip-tests --no-ssr
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la création du projet Angular." >&2
        return 1
    fi

    cd "$PROJECT_NAME" || return 1

    local GIT
    read -r -p "Would you like to initialize Git? (Y/N): " GIT
    if [[ "$GIT" =~ ^[Yy] ]]; then
        git init
        git add -A
        git commit -m "Initial commit"
    fi

    echo "Project setup completed successfully."
    echo "Run 'npm start' or open http://localhost:4200"
    npm start
}

new_angular() {
    local PROJECT_NAME="${1:-}"

    echo ""
    echo "  🚀 Angular Project Scaffolder"
    echo "  =============================="
    echo ""
    echo "  1. Angular CLI (base)"
    echo "     Plain Angular + TypeScript template"
    echo "  2. Angular CLI + Angular Material"
    echo "     Official Material Design components"
    echo "  3. Angular CLI + PrimeNG"
    echo "     Enterprise-ready UI component library"
    echo "  4. Angular CLI + ng-zorro-antd"
    echo "     Ant Design components (ng-zorro)"
    echo "  5. Angular CLI + ngx-bootstrap"
    echo "     Bootstrap 5 components with ngx-bootstrap"
    echo ""

    local PROJECT_CHOICE
    read -r -p "Enter choice (1-5): " PROJECT_CHOICE

    if [ -z "$PROJECT_NAME" ]; then
        read -r -p "Project name: " PROJECT_NAME
    fi

    case "$PROJECT_CHOICE" in
        2) new_angular_material "$PROJECT_NAME" ;;
        3) new_angular_primeng "$PROJECT_NAME" ;;
        4) new_angular_ngzorro "$PROJECT_NAME" ;;
        5) new_angular_ngxbootstrap "$PROJECT_NAME" ;;
        *)
            echo "Choix invalide. Création d'un projet Angular de base."
            new_angular_base "$PROJECT_NAME"
            ;;
    esac
}
