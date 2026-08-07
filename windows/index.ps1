. "$PSScriptRoot\angularMaterial.ps1"
. "$PSScriptRoot\primeng.ps1"
. "$PSScriptRoot\ngZorro.ps1"

<#
.SYNOPSIS
    Crée un projet Angular + SCSS + Routing (template de base).

.PARAMETER PROJECT_NAME
    Nom du répertoire du projet à créer.

.EXAMPLE
    New-AngularBase myapp
#>
function New-AngularBase {
    param([string]$PROJECT_NAME)

    if (-not $PROJECT_NAME) { $PROJECT_NAME = Read-Host "Project name" }

    Write-Host "Creating project: $PROJECT_NAME (Angular + SCSS + Routing)"
    npx -y @angular/cli@latest new "$PROJECT_NAME" --defaults --style=scss --routing --skip-git --skip-tests --no-ssr
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erreur lors de la création du projet Angular." -ForegroundColor Red
        return
    }

    Set-Location "$PROJECT_NAME"

    $GIT = Read-Host "Would you like to initialize Git? (Y/N)"
    if ($GIT.Trim() -match '^[Yy]') {
        git init
        git add -A
        git commit -m "Initial commit"
    }

    Write-Host "Project setup completed successfully." -ForegroundColor Green
    Write-Host "Run `npm start` or open http://localhost:4200"
    npm start
}

<#
.SYNOPSIS
    Scaffold un projet Angular + Angular Material au choix.

.DESCRIPTION
    Affiche un menu interactif (template de base ou Angular Material), crée le projet
    via Angular CLI, installe les dépendances et lance le serveur de développement.

.PARAMETER PROJECT_NAME
    Nom du projet. Optionnel : s'il est vide, il est demandé interactivement.

.EXAMPLE
    New-Angular myapp
#>
function New-Angular {
    param([string]$PROJECT_NAME)

    Write-Host ""
    Write-Host "  🚀 Angular Project Scaffolder" -ForegroundColor Cyan
    Write-Host "  ==============================" -ForegroundColor DarkGray
    Write-Host ""

    $CHOICES = @(
        @{ Id = 1; Name = "Angular CLI (base)"; Desc = "Plain Angular + TypeScript template" }
        @{ Id = 2; Name = "Angular CLI + Angular Material"; Desc = "Official Material Design components" }
        @{ Id = 3; Name = "Angular CLI + PrimeNG"; Desc = "Enterprise-ready UI component library" }
        @{ Id = 4; Name = "Angular CLI + ng-zorro-antd"; Desc = "Ant Design components (ng-zorro)" }
    )

    foreach ($c in $CHOICES) {
        Write-Host ("  {0}. {1}" -f $c.Id, $c.Name) -ForegroundColor Green
        Write-Host ("     {0}" -f $c.Desc) -ForegroundColor DarkGray
    }

    Write-Host ""
    $PROJECT_CHOICE = Read-Host "Enter choice (1-$($CHOICES.Count))"

    if (-not $PROJECT_NAME) { $PROJECT_NAME = Read-Host "Project name" }

    switch ($PROJECT_CHOICE) {
        "2" { New-AngularMaterial $PROJECT_NAME }
        "3" { New-AngularPrimeNg $PROJECT_NAME }
        "4" { New-AngularNgZorro $PROJECT_NAME }
        default {
            Write-Host "Choix invalide. Création d'un projet Angular de base." -ForegroundColor Yellow
            New-AngularBase $PROJECT_NAME
        }
    }
}
