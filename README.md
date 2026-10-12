# Pinkall

Pinkall est un projet expérimental composé d’une application Flutter et d’un site Vite/React.

## Aperçu

Landing page :

![Landing page Pinkall](docs/screenshots/landing-desktop.png)

<p>
  <img src="docs/screenshots/landing-coaching.png" alt="Section coaching de la landing page" width="62%">
  <img src="docs/screenshots/landing-mobile.png" alt="Landing page sur mobile" width="24%">
</p>

Application (téléphone, coaching pendant l’appel, débrief) :

<p>
  <img src="docs/screenshots/app-home.png" alt="Écran téléphone" width="30%">
  <img src="docs/screenshots/app-live-call.png" alt="Coaching pendant l’appel" width="30%">
  <img src="docs/screenshots/app-debrief.png" alt="Débrief après l’appel" width="30%">
</p>

Les écrans de l’application sont rendus hors écran à partir des widgets réels, avec des données fictives.

## Structure

- `app/` : workspace Flutter/Dart.
- `site/` : landing page Vite/React.
- `ARCHITECTURE.md` : documentation d’architecture.
- `PRODUCT.md` : cadrage produit.

## Démarrage du site

```bash
cd site
cp .env.example .env.local
npm ci
npm run dev
```

`VITE_WAITLIST_ENDPOINT` est une URL publique intégrée au bundle client. N’y placez jamais de secret, de token ou d’identifiants.

## Démarrage de l’application

Installez une version de Flutter compatible avec `app/pubspec.yaml`, puis
utilisez les wrappers épinglés du workspace :

```bash
cd app
./tool/flutter.sh pub get
./tool/check.sh
```

`check.sh` couvre le formatage, l'analyse, les suites API/domain/data/mobile,
le build macOS et les tests natifs macOS. La CI ajoute l'image Docker et les
builds Android/iOS.

## Sécurité

Ne commitez jamais de fichier `.env`, de clé de signature ou de configuration locale. Consultez [SECURITY.md](SECURITY.md) pour signaler une vulnérabilité.

## Contribution et licence

Les règles de contribution sont dans [CONTRIBUTING.md](CONTRIBUTING.md).

Copyright (C) 2026 Clement Guyon.

Le code est publié sous la [GNU General Public License v3.0](LICENSE). Vous pouvez l’utiliser, le modifier et le redistribuer, à condition de publier les versions modifiées sous la même licence. Il est fourni sans aucune garantie.

Le code tiers embarqué dans `app/third_party/` et `.agents/skills/` conserve sa propre licence.
