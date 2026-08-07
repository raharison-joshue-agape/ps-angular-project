$angular_ngx_bootstrap_index_content = @'
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>ngx-bootstrap</title>
        <base href="/" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" type="image/x-icon" href="favicon.ico" />
        <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css"
        />
    </head>
    <body>
        <app-root></app-root>
    </body>
</html>
'@

$angular_ngx_bootstrap_styles_content = @'
@use 'sass:meta';

@include meta.load-css('bootstrap/dist/css/bootstrap.min.css');

html,
body {
    height: 100%;
}

body {
    margin: 0;
    font-family: system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    background-color: var(--bs-body-bg);
    color: var(--bs-body-color);
}
'@

$angular_ngx_bootstrap_main_content = @'
import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { App } from './app/app';

bootstrapApplication(App, appConfig).catch((err) => console.error(err));
'@

$angular_ngx_bootstrap_app_config_content = @'
import { ApplicationConfig, provideZonelessChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
    providers: [
        provideZonelessChangeDetection(),
        provideRouter(routes),
        provideAnimationsAsync(),
    ],
};
'@

$angular_ngx_bootstrap_app_component_content = @'
import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { ToggleMode } from './components/toggle-mode/toggle-mode';

@Component({
    selector: 'app-root',
    imports: [RouterOutlet, ToggleMode],
    templateUrl: './app.html',
    styleUrl: './app.scss',
})
export class App {}
'@

$angular_ngx_bootstrap_app_template_content = @'
<router-outlet />
<app-toggle-mode />
'@

$angular_ngx_bootstrap_app_scss_content = @'
:host {
    display: block;
    min-height: 100vh;
}
'@

$angular_ngx_bootstrap_routes_content = @'
import { Routes } from '@angular/router';
import { DefaultLayout } from './layouts/default-layout/default-layout';
import { Home } from './pages/home/home';
import { NotFound } from './pages/not-found/not-found';

export const routes: Routes = [
    {
        path: '',
        component: DefaultLayout,
        children: [
            { path: '', redirectTo: '/home', pathMatch: 'full' },
            { path: 'home', component: Home },
        ],
    },

    { path: '**', component: NotFound },
];
'@

$angular_ngx_bootstrap_theme_service_content = @'
import { Injectable, computed, inject, signal } from '@angular/core';
import { DOCUMENT } from '@angular/common';

export type ThemeMode = 'light' | 'dark' | 'system';

@Injectable({ providedIn: 'root' })
export class ThemeService {
    private readonly document = inject(DOCUMENT);
    private readonly modeSignal = signal<ThemeMode>(this.readMode());
    private readonly systemDark = signal(this.matchesSystemDark());
    private readonly darkSignal = computed(
        () => (this.modeSignal() === 'system' ? this.systemDark() : this.modeSignal() === 'dark'),
    );

    constructor() {
        this.document.defaultView?.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (event) => {
            this.systemDark.set(event.matches);
        });
        this.apply();
    }

    readonly mode = this.modeSignal.asReadonly();
    readonly isDark = this.darkSignal.asReadonly();

    setMode(mode: ThemeMode): void {
        this.modeSignal.set(mode);
        localStorage.setItem('theme', mode);
        this.apply();
    }

    private apply(): void {
        const dark = this.darkSignal();
        this.document.documentElement.classList.toggle('dark', dark);
        this.document.documentElement.setAttribute('data-bs-theme', dark ? 'dark' : 'light');
    }

    private readMode(): ThemeMode {
        const stored = localStorage.getItem('theme') as ThemeMode | null;
        return stored === 'light' || stored === 'dark' || stored === 'system' ? stored : 'system';
    }

    private matchesSystemDark(): boolean {
        return this.document.defaultView?.matchMedia('(prefers-color-scheme: dark)').matches ?? false;
    }
}
'@

$angular_ngx_bootstrap_toggle_mode_content = @'
import { ChangeDetectionStrategy, Component, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ButtonsModule } from 'ngx-bootstrap/buttons';
import { ThemeService, ThemeMode } from '../../theme/theme';

interface ThemeOption {
    value: ThemeMode;
    label: string;
    icon: string;
}

const OPTIONS: ThemeOption[] = [
    { value: 'system', label: 'System', icon: 'bi bi-display' },
    { value: 'light', label: 'Light', icon: 'bi bi-sun' },
    { value: 'dark', label: 'Dark', icon: 'bi bi-moon-stars' },
];

@Component({
    selector: 'app-toggle-mode',
    imports: [FormsModule, ButtonsModule],
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <div class="theme-toggle btn-group" btnRadioGroup [ngModel]="mode()" (ngModelChange)="setMode($event)">
            @for (option of options; track option.value) {
                <label
                    class="btn btn-sm"
                    [ngClass]="mode() === option.value ? 'btn-primary' : 'btn-outline-secondary'"
                    [btnRadio]="option.value"
                    aria-label="Theme"
                >
                    <i class="{{ option.icon }}"></i>
                    <span class="toggle-label">{{ option.label }}</span>
                </label>
            }
        </div>
    `,
    styles: `
        .theme-toggle {
            position: fixed;
            top: 1rem;
            right: 1rem;
            z-index: 50;
            box-shadow: var(--bs-box-shadow-sm);
        }

        .toggle-label {
            margin-left: 0.35rem;
            font-size: 0.8rem;
        }
    `,
})
export class ToggleMode {
    readonly options = OPTIONS;
    private readonly themeService = inject(ThemeService);
    readonly mode = this.themeService.mode;

    setMode(mode: ThemeMode): void {
        this.themeService.setMode(mode);
    }
}
'@

$angular_ngx_bootstrap_default_layout_content = @'
import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';

@Component({
    selector: 'app-default-layout',
    imports: [RouterOutlet],
    template: `<router-outlet />`,
    styles: ``,
})
export class DefaultLayout {}
'@

$angular_ngx_bootstrap_home_content = @'
import { Component } from '@angular/core';

@Component({
    selector: 'app-home',
    templateUrl: './home.html',
    styleUrl: './home.scss',
})
export class Home {
    openAngular(): void {
        window.open('https://angular.dev', '_blank', 'noopener');
    }

    openNgxBootstrap(): void {
        window.open('https://valor-software.com/ngx-bootstrap/', '_blank', 'noopener');
    }
}
'@

$angular_ngx_bootstrap_home_template_content = @'
<main class="home">
    <div class="glow glow-cyan"></div>
    <div class="glow glow-purple"></div>

    <span class="badge rounded-pill text-bg-primary">
        <span class="badge-dot"></span>
        Angular • ngx-bootstrap
    </span>

    <div class="icon-badge">
        <i class="bi bi-bootstrap"></i>
    </div>

    <h1 class="heading">Bienvenue sur votre projet Angular</h1>

    <p class="subtitle">
        Ce projet est pré-configuré avec
        <span class="highlight highlight-cyan">ngx-bootstrap</span>,
        <span class="highlight highlight-purple">SCSS</span> et
        <span class="highlight highlight-pink">Bootstrap Icons</span>
        pour un développement rapide et élégant.
    </p>

    <div class="actions">
        <button type="button" class="btn btn-primary" (click)="openAngular()">
            <i class="bi bi-rocket-takeoff"></i>
            Démarrer
        </button>
        <button type="button" class="btn btn-outline-secondary" (click)="openNgxBootstrap()">
            <i class="bi bi-book"></i>
            Documentation
        </button>
    </div>
</main>
'@

$angular_ngx_bootstrap_home_scss_content = @'
.home {
    position: relative;
    display: flex;
    min-height: 100vh;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 1.25rem;
    overflow: hidden;
    padding: 4rem 1.5rem;
    text-align: center;
    background-color: var(--bs-body-bg);
    color: var(--bs-body-color);
}

.glow {
    position: absolute;
    height: 18rem;
    width: 18rem;
    border-radius: 9999px;
    filter: blur(64px);
    pointer-events: none;
    opacity: 0.25;
}

.glow-cyan {
    top: -4rem;
    left: -4rem;
    background: #0d6efd;
}

.glow-purple {
    right: -4rem;
    bottom: -4rem;
    background: #6f42c1;
}

.badge-dot {
    display: inline-block;
    width: 0.5rem;
    height: 0.5rem;
    border-radius: 9999px;
    background: currentColor;
    animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

@keyframes pulse {
    0%,
    100% {
        opacity: 1;
    }
    50% {
        opacity: 0.4;
    }
}

.icon-badge {
    display: flex;
    height: 5rem;
    width: 5rem;
    align-items: center;
    justify-content: center;
    border-radius: 1rem;
    background: linear-gradient(135deg, #0d6efd, #6f42c1);
    color: white;
    box-shadow: 0 10px 25px rgb(13 110 253 / 0.25);
}

.icon-badge .bi {
    font-size: 2.5rem;
}

.heading {
    max-width: 42rem;
    margin: 0;
    font-size: 2.5rem;
    font-weight: 800;
    letter-spacing: -0.025em;
    line-height: 1.1;
    color: var(--bs-body-color);
}

.subtitle {
    max-width: 42rem;
    margin: 0;
    font-size: 1.1rem;
    line-height: 1.7;
    color: var(--bs-secondary-color);
}

.highlight {
    font-weight: 600;
}

.highlight-cyan {
    color: #0d6efd;
}

.highlight-purple {
    color: #6f42c1;
}

.highlight-pink {
    color: #d63384;
}

.actions {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: center;
    gap: 1rem;
    margin-top: 0.75rem;
}

.actions .btn i {
    margin-right: 0.35rem;
}
'@

$angular_ngx_bootstrap_not_found_content = @'
import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';

@Component({
    selector: 'app-not-found',
    templateUrl: './not-found.html',
    styleUrl: './not-found.scss',
})
export class NotFound {
    private readonly router = inject(Router);

    goHome(): void {
        this.router.navigate(['/home']);
    }
}
'@

$angular_ngx_bootstrap_not_found_template_content = @'
<main class="not-found">
    <div class="glow glow-pink"></div>
    <div class="glow glow-purple"></div>

    <span class="badge rounded-pill text-bg-danger">Erreur 404</span>

    <div class="icon-badge">
        <i class="bi bi-sign-stop"></i>
    </div>

    <h1 class="heading">Page introuvable</h1>

    <p class="subtitle">
        Oups... la page que vous cherchez semble avoir disparu.<br />
        Vérifiez l'URL ou revenez à une page connue.
    </p>

    <div class="actions">
        <button type="button" class="btn btn-primary" (click)="goHome()">
            <i class="bi bi-house"></i>
            Accueil
        </button>
    </div>
</main>
'@

$angular_ngx_bootstrap_not_found_scss_content = @'
.not-found {
    position: relative;
    display: flex;
    min-height: 100vh;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 1.25rem;
    overflow: hidden;
    padding: 4rem 1.5rem;
    text-align: center;
    background-color: var(--bs-body-bg);
    color: var(--bs-body-color);
}

.glow {
    position: absolute;
    height: 18rem;
    width: 18rem;
    border-radius: 9999px;
    filter: blur(64px);
    pointer-events: none;
    opacity: 0.25;
}

.glow-pink {
    top: -4rem;
    left: -4rem;
    background: #d63384;
}

.glow-purple {
    right: -4rem;
    bottom: -4rem;
    background: #6f42c1;
}

.icon-badge {
    display: flex;
    height: 5rem;
    width: 5rem;
    align-items: center;
    justify-content: center;
    border-radius: 1rem;
    background: linear-gradient(135deg, #d63384, #6f42c1);
    color: white;
    box-shadow: 0 10px 25px rgb(214 51 132 / 0.25);
}

.icon-badge .bi {
    font-size: 2.5rem;
}

.heading {
    max-width: 42rem;
    margin: 0;
    font-size: 2.5rem;
    font-weight: 800;
    letter-spacing: -0.025em;
    line-height: 1.1;
    color: var(--bs-body-color);
}

.subtitle {
    max-width: 42rem;
    margin: 0;
    font-size: 1.1rem;
    line-height: 1.7;
    color: var(--bs-secondary-color);
}

.actions {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: center;
    gap: 1rem;
    margin-top: 0.75rem;
}

.actions .btn i {
    margin-right: 0.35rem;
}
'@

<#
.SYNOPSIS
    Crée un projet Angular + ngx-bootstrap + TypeScript pré-configuré (Windows).

.DESCRIPTION
    Scaffold un projet Angular (SCSS + Routing) via Angular CLI, installe ngx-bootstrap
    et Bootstrap, puis génère le layout, les pages Home/404, le sélecteur de thème
    (Clair / Sombre / Système) et le thème Bootstrap 5.3 (data-bs-theme).
    Bootstrap Icons est chargé via CDN (non installé en package).

.PARAMETER PROJECT_NAME
    Nom du répertoire du projet à créer.

.EXAMPLE
    New-AngularNgxBootstrap myapp
#>
function New-AngularNgxBootstrap {
    param([string]$PROJECT_NAME)

    if (-not $PROJECT_NAME) { $PROJECT_NAME = Read-Host "Project name" }

    Write-Host "Creating project: $PROJECT_NAME (Angular + ngx-bootstrap + SCSS + Routing)"
    npx -y @angular/cli@latest new "$PROJECT_NAME" --defaults --style=scss --routing --skip-git --skip-tests --no-ssr
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erreur lors de la création du projet Angular." -ForegroundColor Red
        return
    }

    Set-Location "$PROJECT_NAME"

    Write-Host "Installing ngx-bootstrap..."
    $pkg = Get-Content "package.json" -Raw | ConvertFrom-Json
    $ngVersion = $pkg.dependencies.'@angular/core'
    $ngMajor = [int](([regex]::Match($ngVersion, '\d+')).Value)
    npm install "ngx-bootstrap@$ngMajor" "bootstrap" "@angular/animations@$ngVersion"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ngx-bootstrap aligned with Angular $ngMajor not available. Retrying with --legacy-peer-deps..." -ForegroundColor Yellow
        npm install "ngx-bootstrap@latest" "bootstrap" --legacy-peer-deps
    }
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erreur lors de l'installation de ngx-bootstrap." -ForegroundColor Red
        return
    }

    Remove-Item "src/app/app.component.ts", "src/app/app.component.html", "src/app/app.component.scss", "src/app/app.component.css", "src/app/app.component.spec.ts", "src/app/app.ts", "src/app/app.html", "src/app/app.scss", "src/app/app.css", "src/app/app.spec.ts" -ErrorAction SilentlyContinue

    $dirs = @(
        "src/app/components/toggle-mode",
        "src/app/layouts/default-layout",
        "src/app/pages/home",
        "src/app/pages/not-found",
        "src/app/theme"
    )
    foreach ($d in $dirs) { if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null } }

    Set-Content "src/index.html" -Value $angular_ngx_bootstrap_index_content -Encoding UTF8
    Set-Content "src/styles.scss" -Value $angular_ngx_bootstrap_styles_content -Encoding UTF8
    Set-Content "src/main.ts" -Value $angular_ngx_bootstrap_main_content -Encoding UTF8
    Set-Content "src/app/app.ts" -Value $angular_ngx_bootstrap_app_component_content -Encoding UTF8
    Set-Content "src/app/app.html" -Value $angular_ngx_bootstrap_app_template_content -Encoding UTF8
    Set-Content "src/app/app.scss" -Value $angular_ngx_bootstrap_app_scss_content -Encoding UTF8
    Set-Content "src/app/app.config.ts" -Value $angular_ngx_bootstrap_app_config_content -Encoding UTF8
    Set-Content "src/app/app.routes.ts" -Value $angular_ngx_bootstrap_routes_content -Encoding UTF8
    Set-Content "src/app/theme/theme.ts" -Value $angular_ngx_bootstrap_theme_service_content -Encoding UTF8
    Set-Content "src/app/components/toggle-mode/toggle-mode.ts" -Value $angular_ngx_bootstrap_toggle_mode_content -Encoding UTF8
    Set-Content "src/app/layouts/default-layout/default-layout.ts" -Value $angular_ngx_bootstrap_default_layout_content -Encoding UTF8
    Set-Content "src/app/pages/home/home.ts" -Value $angular_ngx_bootstrap_home_content -Encoding UTF8
    Set-Content "src/app/pages/home/home.html" -Value $angular_ngx_bootstrap_home_template_content -Encoding UTF8
    Set-Content "src/app/pages/home/home.scss" -Value $angular_ngx_bootstrap_home_scss_content -Encoding UTF8
    Set-Content "src/app/pages/not-found/not-found.ts" -Value $angular_ngx_bootstrap_not_found_content -Encoding UTF8
    Set-Content "src/app/pages/not-found/not-found.html" -Value $angular_ngx_bootstrap_not_found_template_content -Encoding UTF8
    Set-Content "src/app/pages/not-found/not-found.scss" -Value $angular_ngx_bootstrap_not_found_scss_content -Encoding UTF8

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
