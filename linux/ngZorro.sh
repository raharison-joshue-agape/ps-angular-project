#!/usr/bin/env bash
# ngZorro.sh — Crée un projet Angular + ng-zorro-antd + TypeScript pré-configuré.

new_angular_ngzorro() {
    local PROJECT_NAME="${1:-}"

    if [ -z "$PROJECT_NAME" ]; then
        read -r -p "Project name: " PROJECT_NAME
    fi

    echo "Creating project: $PROJECT_NAME (Angular + ng-zorro-antd + SCSS + Routing)"
    npx -y @angular/cli@latest new "$PROJECT_NAME" --defaults --style=scss --routing --skip-git --skip-tests --no-ssr
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la création du projet Angular." >&2
        return 1
    fi

    cd "$PROJECT_NAME" || return 1

    echo "Installing ng-zorro-antd..."
    local NG_VERSION
    NG_VERSION=$(node -p "require('./package.json').dependencies['@angular/core']")
    npm install "ng-zorro-antd@$NG_VERSION" "@angular/cdk@$NG_VERSION" "@angular/animations@$NG_VERSION" "@ant-design/icons-angular@$NG_VERSION"
    if [ $? -ne 0 ]; then
        echo "Erreur lors de l'installation de ng-zorro-antd." >&2
        return 1
    fi

    rm -f src/app/app.component.ts src/app/app.component.html src/app/app.component.scss src/app/app.component.css src/app/app.component.spec.ts src/app/app.ts src/app/app.html src/app/app.scss src/app/app.css src/app/app.spec.ts

    mkdir -p src/app/components/toggle-mode src/app/layouts/default-layout src/app/pages/home src/app/pages/not-found src/app/theme

    cat > src/index.html <<'EOF'
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>ng-zorro</title>
        <base href="/" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" type="image/x-icon" href="favicon.ico" />
    </head>
    <body>
        <app-root></app-root>
    </body>
</html>
EOF

    cat > src/styles.scss <<'EOF'
@use 'sass:meta';

@include meta.load-css('ng-zorro-antd/ng-zorro-antd.css');

html,
body {
    height: 100%;
}

body {
    margin: 0;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    background-color: #ffffff;
    color: rgba(0, 0, 0, 0.88);
}

html.dark body {
    background-color: #141414;
    color: rgba(255, 255, 255, 0.85);
}

html.dark {
    color-scheme: dark;
    @include meta.load-css('ng-zorro-antd/ng-zorro-antd.dark.css');
}
EOF

    cat > src/main.ts <<'EOF'
import { bootstrapApplication } from '@angular/platform-browser';
import { appConfig } from './app/app.config';
import { App } from './app/app';

bootstrapApplication(App, appConfig).catch((err) => console.error(err));
EOF

    cat > src/app/app.config.ts <<'EOF'
import { ApplicationConfig, provideZonelessChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import { provideNzI18n, en_US } from 'ng-zorro-antd/i18n';
import { provideNzIcons } from 'ng-zorro-antd/icon';
import {
    BookOutlined,
    DesktopOutlined,
    HomeOutlined,
    MoonOutlined,
    RocketOutlined,
    StopOutlined,
    SunOutlined,
    ThunderboltOutlined,
} from '@ant-design/icons-angular/icons';
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
    providers: [
        provideZonelessChangeDetection(),
        provideRouter(routes),
        provideAnimationsAsync(),
        provideNzI18n(en_US),
        provideNzIcons([
            BookOutlined,
            DesktopOutlined,
            HomeOutlined,
            MoonOutlined,
            RocketOutlined,
            StopOutlined,
            SunOutlined,
            ThunderboltOutlined,
        ]),
    ],
};
EOF

    cat > src/app/app.ts <<'EOF'
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
EOF

    cat > src/app/app.html <<'EOF'
<router-outlet />
<app-toggle-mode />
EOF

    cat > src/app/app.scss <<'EOF'
:host {
    display: block;
    min-height: 100vh;
}
EOF

    cat > src/app/app.routes.ts <<'EOF'
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
EOF

    cat > src/app/theme/theme.ts <<'EOF'
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
EOF

    cat > src/app/components/toggle-mode/toggle-mode.ts <<'EOF'
import { ChangeDetectionStrategy, Component, inject } from '@angular/core';
import { NzSegmentedModule } from 'ng-zorro-antd/segmented';
import { ThemeService, ThemeMode } from '../../theme/theme';

interface ThemeOption {
    label: string;
    value: ThemeMode;
    icon: string;
}

const OPTIONS: ThemeOption[] = [
    { label: 'System', value: 'system', icon: 'desktop' },
    { label: 'Light', value: 'light', icon: 'sun' },
    { label: 'Dark', value: 'dark', icon: 'moon' },
];

@Component({
    selector: 'app-toggle-mode',
    imports: [NzSegmentedModule],
    changeDetection: ChangeDetectionStrategy.OnPush,
    template: `
        <nz-segmented
            class="theme-toggle"
            [nzOptions]="options"
            [nzValue]="themeService.mode()"
            (nzValueChange)="themeService.setMode($event)"
        />
    `,
    styles: `
        :host {
            position: fixed;
            top: 1rem;
            right: 1rem;
            z-index: 50;
        }
    `,
})
export class ToggleMode {
    readonly options = OPTIONS;
    readonly themeService = inject(ThemeService);
}
EOF

    cat > src/app/layouts/default-layout/default-layout.ts <<'EOF'
import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';

@Component({
    selector: 'app-default-layout',
    imports: [RouterOutlet],
    template: `<router-outlet />`,
    styles: ``,
})
export class DefaultLayout {}
EOF

    cat > src/app/pages/home/home.ts <<'EOF'
import { Component } from '@angular/core';
import { NzButtonModule } from 'ng-zorro-antd/button';

@Component({
    selector: 'app-home',
    imports: [NzButtonModule],
    templateUrl: './home.html',
    styleUrl: './home.scss',
})
export class Home {
    openAngular(): void {
        window.open('https://angular.dev', '_blank', 'noopener');
    }

    openNgZorro(): void {
        window.open('https://ng.ant.design', '_blank', 'noopener');
    }
}
EOF

    cat > src/app/pages/home/home.html <<'EOF'
<main class="home">
    <div class="glow glow-cyan"></div>
    <div class="glow glow-purple"></div>

    <div class="badge">
        <span class="badge-dot"></span>
        Angular • ng-zorro
    </div>

    <div class="icon-badge">
        <span nz-icon nzType="thunderbolt"></span>
    </div>

    <h1 class="heading">Bienvenue sur votre projet Angular</h1>

    <p class="subtitle">
        Ce projet est pré-configuré avec
        <span class="highlight highlight-cyan">ng-zorro-antd</span>,
        <span class="highlight highlight-purple">SCSS</span> et
        <span class="highlight highlight-pink">les icônes Ant Design</span>
        pour un développement rapide et élégant.
    </p>

    <div class="actions">
        <button nz-button nzType="primary" (click)="openAngular()">
            <span nz-icon nzType="rocket"></span>
            <span>Démarrer</span>
        </button>
        <button nz-button nzType="default" (click)="openNgZorro()">
            <span nz-icon nzType="book"></span>
            <span>Documentation</span>
        </button>
    </div>
</main>
EOF

    cat > src/app/pages/home/home.scss <<'EOF'
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
    background: #ffffff;
    color: rgba(0, 0, 0, 0.88);
}

html.dark .home {
    background: #141414;
    color: rgba(255, 255, 255, 0.85);
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
    border: 1px solid #d9d9d9;
    border-radius: 9999px;
    padding: 0.35rem 1rem;
    background: #f5f5f5;
    font-size: 0.75rem;
    font-weight: 600;
    letter-spacing: 0.05em;
    text-transform: uppercase;
    color: #1677ff;
}

html.dark .badge {
    border-color: #424242;
    background: #1f1f1f;
    color: #1668dc;
}

.badge-dot {
    width: 0.5rem;
    height: 0.5rem;
    border-radius: 9999px;
    background: #1677ff;
    animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}

html.dark .badge-dot {
    background: #1668dc;
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

.icon-badge .anticon {
    font-size: 2.5rem;
}

.heading {
    max-width: 42rem;
    margin: 0;
    font-size: 2.5rem;
    font-weight: 800;
    letter-spacing: -0.025em;
    line-height: 1.1;
    color: rgba(0, 0, 0, 0.88);
}

html.dark .heading {
    color: rgba(255, 255, 255, 0.85);
}

.subtitle {
    max-width: 42rem;
    margin: 0;
    font-size: 1.1rem;
    line-height: 1.7;
    color: rgba(0, 0, 0, 0.65);
}

html.dark .subtitle {
    color: rgba(255, 255, 255, 0.65);
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
EOF

    cat > src/app/pages/not-found/not-found.ts <<'EOF'
import { Component, inject } from '@angular/core';
import { Router } from '@angular/router';
import { NzButtonModule } from 'ng-zorro-antd/button';

@Component({
    selector: 'app-not-found',
    imports: [NzButtonModule],
    templateUrl: './not-found.html',
    styleUrl: './not-found.scss',
})
export class NotFound {
    private readonly router = inject(Router);

    goHome(): void {
        this.router.navigate(['/home']);
    }
}
EOF

    cat > src/app/pages/not-found/not-found.html <<'EOF'
<main class="not-found">
    <div class="glow glow-pink"></div>
    <div class="glow glow-purple"></div>

    <div class="badge">Erreur 404</div>

    <div class="icon-badge">
        <span nz-icon nzType="stop"></span>
    </div>

    <h1 class="heading">Page introuvable</h1>

    <p class="subtitle">
        Oups... la page que vous cherchez semble avoir disparu.<br />
        Vérifiez l'URL ou revenez à une page connue.
    </p>

    <div class="actions">
        <button nz-button nzType="primary" (click)="goHome()">
            <span nz-icon nzType="home"></span>
            <span>Accueil</span>
        </button>
    </div>
</main>
EOF

    cat > src/app/pages/not-found/not-found.scss <<'EOF'
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
    background: #ffffff;
    color: rgba(0, 0, 0, 0.88);
}

html.dark .not-found {
    background: #141414;
    color: rgba(255, 255, 255, 0.85);
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
    border: 1px solid #d9d9d9;
    border-radius: 9999px;
    padding: 0.35rem 1rem;
    background: #f5f5f5;
    font-size: 0.75rem;
    font-weight: 600;
    letter-spacing: 0.05em;
    text-transform: uppercase;
    color: #ff4d4f;
}

html.dark .badge {
    border-color: #424242;
    background: #1f1f1f;
    color: #ff7875;
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

.icon-badge .anticon {
    font-size: 2.5rem;
}

.heading {
    max-width: 42rem;
    margin: 0;
    font-size: 2.5rem;
    font-weight: 800;
    letter-spacing: -0.025em;
    line-height: 1.1;
    color: rgba(0, 0, 0, 0.88);
}

html.dark .heading {
    color: rgba(255, 255, 255, 0.85);
}

.subtitle {
    max-width: 42rem;
    margin: 0;
    font-size: 1.1rem;
    line-height: 1.7;
    color: rgba(0, 0, 0, 0.65);
}

html.dark .subtitle {
    color: rgba(255, 255, 255, 0.65);
}

.actions {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    justify-content: center;
    gap: 1rem;
    margin-top: 0.75rem;
}
EOF

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
