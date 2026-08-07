#!/usr/bin/env zsh
# index.zsh — Point d'entrée macOS (zsh) : charge les modules Angular scaffolding.
# Usage : . "$HOME/.config/alias/angular-aliases-project/macos/index.zsh"

_angular_aliases_root="${0:A:h}"

. "$_angular_aliases_root/angularMaterial.zsh"
. "$_angular_aliases_root/primeng.zsh"
. "$_angular_aliases_root/ngZorro.zsh"

new_angular_base() {
    local PROJECT_NAME="${1:-}"

    if [ -z "$PROJECT_NAME" ]; then
        read -r "PROJECT_NAME?Project name: "
    fi

    echo "Creating project: $PROJECT_NAME (Angular + SCSS + Routing)"
    npx -y @angular/cli@latest new "$PROJECT_NAME" --defaults --style=scss --routing --skip-git --skip-tests --no-ssr
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la création du projet Angular." >&2
        return 1
    fi

    cd "$PROJECT_NAME" || return 1

    local GIT
    read -r "GIT?Would you like to initialize Git? (Y/N): "
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
    echo ""

    local PROJECT_CHOICE
    read -r "PROJECT_CHOICE?Enter choice (1-4): "

    if [ -z "$PROJECT_NAME" ]; then
        read -r "PROJECT_NAME?Project name: "
    fi

    case "$PROJECT_CHOICE" in
        2) new_angular_material "$PROJECT_NAME" ;;
        3) new_angular_primeng "$PROJECT_NAME" ;;
        4) new_angular_ngzorro "$PROJECT_NAME" ;;
        *)
            echo "Choix invalide. Création d'un projet Angular de base."
            new_angular_base "$PROJECT_NAME"
            ;;
    esac
}
