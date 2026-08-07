$angular_material_index_content = @'
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>Angular Material</title>
        <base href="/" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" type="image/x-icon" href="favicon.ico" />
        <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap"
        />
        <link
            rel="stylesheet"
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200&display=swap"
        />
    </head>
    <body>
        <app-root></app-root>
    </body>
</html>
'@

$angular_material_styles_content = @'
@use '@angular/material' as mat;

html,
body {
    height: 100%;
}

body {
    margin: 0;
    font-family: Roboto, 'Helvetica Neue', sans-serif;
    background-color: var(--mat-sys-background);
    color: var(--mat-sys-on-background);
}

@include mat.theme(
    (
        color: (
            theme-type: light,
            primary: mat.$azure-palette,
            tertiary: mat.$blue-palette,
        ),
        typography: Roboto,
        density: 0,
    )
);

html.dark {
    color-scheme: dark;
    @include mat.theme(
        (
            color: (
                theme-type: dark,
                primary: mat.$azure-palette,
                tertiary: mat.$blue-palette,
            ),
            typography: Roboto,
            density: 0,
        )
    );
}
'@

$angular_material_main_content = @'
import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { App } from './app/app';

bootstrapApplication(App, appConfig).catch((err) => console.error(err));
'@

$angular_material_app_config_content = @'
import { ApplicationConfig, provideZonelessChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { MAT_ICON_DEFAULT_OPTIONS } from '@angular/material/icon';
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
    providers: [
        provideZonelessChangeDetection(),
        provideRouter(routes),
        provideAnimationsAsync(),
        { provide: MAT_ICON_DEFAULT_OPTIONS, useValue: { fontSet: 'material-symbols-outlined' } },
    ],
};
'@

$angular_material_app_component_content = @'
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

$angular_material_app_template_content = @'
<router-outlet />
<app-toggle-mode />
'@

$angular_material_app_scss_content = @'
:host {
    display: block;
    min-height: 100vh;
}
'@

$angular_material_routes_content = @'
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

$angular_material_theme_service_content = @'
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
        this.document.documentElement.classList.toggle('dark', this.darkSignal());
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

$angular_material_toggle_mode_content = @'
import { ChangeDetectionStrategy, Component, inject } from '@angular/core';
import { MatButtonToggleModule } from '@angular/material/button-toggle';
import { MatIconModule } from '@angular/material/icon';
import { ThemeService, ThemeMode } from '../../theme/theme';

interface ThemeOption {
    value: ThemeMode;
    label: string;
    icon: string;
}

const OPTIONS: ThemeOption[] = [
    { value: 'system', label: 'System', icon: 'computer' },
    { value: 'light', label: 'Light', icon: 'light_mode' },
    { value: 'dark', label: 'Dark', icon: 'dark_mode' },
];

@Component({
    selector: 'app-toggle-mode',
    imports: [MatButtonToggleModule, MatIconModule],
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <mat-button-toggle-group
            class="theme-toggle"
            [value]="themeService.mode()"
            (valueChange)="themeService.setMode($event)"
            [hideSingleSelectionIndicator]="true"
            aria-label="Theme"
        >
            @for (option of options; track option.value) {
                <mat-button-toggle [value]="option.value">
                    <mat-icon>{{ option.icon }}</mat-icon>
                    <span class="toggle-label">{{ option.label }}</span>
                </mat-button-toggle>
            }
        </mat-button-toggle-group>
    `,
    styles: `
        .theme-toggle {
            position: fixed;
            top: 1rem;
            right: 1rem;
            z-index: 50;
            border-radius: 9999px;
            overflow: hidden;
        }

        .toggle-label {
            margin-left: 0.35rem;
            font-size: 0.8rem;
        }
    `,
})
export class ToggleMode {
    readonly options = OPTIONS;
    readonly themeService = inject(ThemeService);
}
'@

$angular_material_default_layout_content = @'
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

$angular_material_home_content = @'
import { Component } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
    selector: 'app-home',
    imports: [MatButtonModule, MatIconModule],
    templateUrl: './home.html',
    styleUrl: './home.scss',
})
export class Home {}
'@

$angular_material_home_template_content = @'
<main class="home">
    <div class="glow glow-cyan"></div>
    <div class="glow glow-purple"></div>

    <div class="badge">
        <span class="badge-dot"></span>
        Angular • Angular Material
    </div>

    <div class="icon-badge">
        <mat-icon>auto_awesome</mat-icon>
    </div>

    <h1 class="heading">Bienvenue sur votre projet Angular</h1>

    <p class="subtitle">
        Ce projet est pré-configuré avec
        <span class="highlight highlight-cyan">Angular Material</span>,
        <span class="highlight highlight-purple">SCSS</span> et
        <span class="highlight highlight-pink">les icônes Material</span>
        pour un développement rapide et élégant.
    </p>

    <div class="actions">
        <a mat-flat-button color="primary" href="https://material.angular.io" target="_blank" rel="noopener">
            <mat-icon>rocket_launch</mat-icon>
            Démarrer
        </a>
        <a mat-stroked-button href="https://angular.dev" target="_blank" rel="noopener">
            <mat-icon>menu_book</mat-icon>
            Documentation
        </a>
    </div>
</main>
'@

$angular_material_home_scss_content = @'
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
    background: var(--mat-sys-background);
    color: var(--mat-sys-on-background);
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
    background: #06b6d4;
}

.glow-purple {
    right: -4rem;
    bottom: -4rem;
    background: #8b5cf6;
}

.badge {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    border: 1px solid var(--mat-sys-outline-variant);
    border-radius: 9999px;
    padding: 0.35rem 1rem;
    background: var(--mat-sys-surface-container);
    font-size: 0.75rem;
    font-weight: 600;
    letter-spacing: 0.05em;
    text-transform: uppercase;
    color: var(--mat-sys-primary);
}

.badge-dot {
    width: 0.5rem;
    height: 0.5rem;
    border-radius: 9999px;
    background: var(--mat-sys-primary);
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
    background: linear-gradient(135deg, #06b6d4, #8b5cf6);
    color: white;
    box-shadow: 0 10px 25px rgb(6 182 212 / 0.25);
}

.icon-badge mat-icon {
    font-size: 2.5rem;
    width: 2.5rem;
    height: 2.5rem;
}

.heading {
    max-width: 42rem;
    margin: 0;
    font-size: 2.5rem;
    font-weight: 800;
    letter-spacing: -0.025em;
    line-height: 1.1;
    color: var(--mat-sys-on-surface);
}

.subtitle {
    max-width: 42rem;
    margin: 0;
    font-size: 1.1rem;
    line-height: 1.7;
    color: var(--mat-sys-on-surface-variant);
}

.highlight {
    font-weight: 600;
}

.highlight-cyan {
    color: #06b6d4;
}

.highlight-purple {
    color: #8b5cf6;
}

.highlight-pink {
    color: #ec4899;
}

.actions {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: center;
    gap: 1rem;
    margin-top: 0.75rem;
}

.actions a mat-icon {
    margin-right: 0.35rem;
}
'@

$angular_material_not_found_content = @'
import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
    selector: 'app-not-found',
    imports: [MatButtonModule, MatIconModule, RouterLink],
    templateUrl: './not-found.html',
    styleUrl: './not-found.scss',
})
export class NotFound {}
'@

$angular_material_not_found_template_content = @'
<main class="not-found">
    <div class="glow glow-pink"></div>
    <div class="glow glow-purple"></div>

    <div class="badge">Erreur 404</div>

    <div class="icon-badge">
        <mat-icon>block</mat-icon>
    </div>

    <h1 class="heading">Page introuvable</h1>

    <p class="subtitle">
        Oups... la page que vous cherchez semble avoir disparu.<br />
        Vérifiez l'URL ou revenez à une page connue.
    </p>

    <div class="actions">
        <a mat-flat-button color="primary" routerLink="/home">
            <mat-icon>home</mat-icon>
            Accueil
        </a>
    </div>
</main>
'@

$angular_material_not_found_scss_content = @'
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
    background: var(--mat-sys-background);
    color: var(--mat-sys-on-background);
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
    background: #ec4899;
}

.glow-purple {
    right: -4rem;
    bottom: -4rem;
    background: #8b5cf6;
}

.badge {
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    border: 1px solid var(--mat-sys-outline-variant);
    border-radius: 9999px;
    padding: 0.35rem 1rem;
    background: var(--mat-sys-surface-container);
    font-size: 0.75rem;
    font-weight: 600;
    letter-spacing: 0.05em;
    text-transform: uppercase;
    color: var(--mat-sys-error);
}

.icon-badge {
    display: flex;
    height: 5rem;
    width: 5rem;
    align-items: center;
    justify-content: center;
    border-radius: 1rem;
    background: linear-gradient(135deg, #ec4899, #8b5cf6);
    color: white;
    box-shadow: 0 10px 25px rgb(236 72 153 / 0.25);
}

.icon-badge mat-icon {
    font-size: 2.5rem;
    width: 2.5rem;
    height: 2.5rem;
}

.heading {
    max-width: 42rem;
    margin: 0;
    font-size: 2.5rem;
    font-weight: 800;
    letter-spacing: -0.025em;
    line-height: 1.1;
    color: var(--mat-sys-on-surface);
}

.subtitle {
    max-width: 42rem;
    margin: 0;
    font-size: 1.1rem;
    line-height: 1.7;
    color: var(--mat-sys-on-surface-variant);
}

.actions {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: center;
    gap: 1rem;
    margin-top: 0.75rem;
}

.actions a mat-icon {
    margin-right: 0.35rem;
}
'@

<#
.SYNOPSIS
    Crée un projet Angular + Angular Material + TypeScript pré-configuré.

.DESCRIPTION
    Scaffold un projet Angular (SCSS + Routing) via Angular CLI, installe Angular Material
    et le CDK, puis génère le layout, les pages Home/404, le sélecteur de thème
    (Clair / Sombre / Système) et le thème Material 3.

.PARAMETER PROJECT_NAME
    Nom du répertoire du projet à créer.

.EXAMPLE
    New-AngularMaterial myapp
#>
function New-AngularMaterial {
    param([string]$PROJECT_NAME)

    if (-not $PROJECT_NAME) { $PROJECT_NAME = Read-Host "Project name" }

    Write-Host "Creating project: $PROJECT_NAME (Angular + Angular Material + SCSS + Routing)"
    npx -y @angular/cli@latest new "$PROJECT_NAME" --defaults --style=scss --routing --skip-git --skip-tests --no-ssr
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erreur lors de la création du projet Angular." -ForegroundColor Red
        return
    }

    Set-Location "$PROJECT_NAME"

    Write-Host "Installing Angular Material..."
    $pkg = Get-Content "package.json" -Raw | ConvertFrom-Json
    $ngVersion = $pkg.dependencies.'@angular/core'
    npm install "@angular/material@$ngVersion" "@angular/cdk@$ngVersion" "@angular/animations@$ngVersion"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erreur lors de l'installation d'Angular Material." -ForegroundColor Red
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

    Set-Content "src/index.html" -Value $angular_material_index_content -Encoding UTF8
    Set-Content "src/styles.scss" -Value $angular_material_styles_content -Encoding UTF8
    Set-Content "src/main.ts" -Value $angular_material_main_content -Encoding UTF8
    Set-Content "src/app/app.ts" -Value $angular_material_app_component_content -Encoding UTF8
    Set-Content "src/app/app.html" -Value $angular_material_app_template_content -Encoding UTF8
    Set-Content "src/app/app.scss" -Value $angular_material_app_scss_content -Encoding UTF8
    Set-Content "src/app/app.config.ts" -Value $angular_material_app_config_content -Encoding UTF8
    Set-Content "src/app/app.routes.ts" -Value $angular_material_routes_content -Encoding UTF8
    Set-Content "src/app/theme/theme.ts" -Value $angular_material_theme_service_content -Encoding UTF8
    Set-Content "src/app/components/toggle-mode/toggle-mode.ts" -Value $angular_material_toggle_mode_content -Encoding UTF8
    Set-Content "src/app/layouts/default-layout/default-layout.ts" -Value $angular_material_default_layout_content -Encoding UTF8
    Set-Content "src/app/pages/home/home.ts" -Value $angular_material_home_content -Encoding UTF8
    Set-Content "src/app/pages/home/home.html" -Value $angular_material_home_template_content -Encoding UTF8
    Set-Content "src/app/pages/home/home.scss" -Value $angular_material_home_scss_content -Encoding UTF8
    Set-Content "src/app/pages/not-found/not-found.ts" -Value $angular_material_not_found_content -Encoding UTF8
    Set-Content "src/app/pages/not-found/not-found.html" -Value $angular_material_not_found_template_content -Encoding UTF8
    Set-Content "src/app/pages/not-found/not-found.scss" -Value $angular_material_not_found_scss_content -Encoding UTF8

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
