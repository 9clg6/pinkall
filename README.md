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

## Comment ça marche

<img src="docs/anatomy/pinkall-live-coach.svg" alt="Schéma : le coaching en direct de Pinkall vu comme un magnétophone à bandes" width="100%">

Le coaching en direct, dessiné comme un magnétophone à bandes :

- le combiné posé sur le coupleur est l’audio de l’appel, et l’interrupteur fermé le consentement à la transcription ;
- la bande passe devant deux têtes : l’ingestion par le backend, puis la transcription en direct ;
- le cadran détecte la fin d’un tour de parole (seuil 0,85) ;
- le portique lève alors une seule fiche du bac de 50 cartes : la suggestion affichée pendant l’appel, en rose ;
- la touche stop imprime le ticket : le débrief après l’appel.

Figure dessinée avec le skill [Anatomy](https://skills.wheresryan.sh/anatomy).

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
