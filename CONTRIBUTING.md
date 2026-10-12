# Contribuer

## Avant de proposer un changement

1. Ouvrez un ticket décrivant le problème ou la proposition.
2. Limitez chaque contribution à un objectif cohérent.
3. Ajoutez ou adaptez les tests concernés.
4. Vérifiez qu’aucun secret, fichier `.env`, chemin local ou artefact généré n’est inclus.

## Vérifications

Pour le site :

```bash
cd site
npm ci
npm run lint
npm run build
```

Pour l’application :

```bash
cd app
flutter pub get
flutter test
```

## Données sensibles

Utilisez uniquement des valeurs fictives dans les tests, captures, exemples et journaux. Toute variable `VITE_*` est publique et ne doit jamais contenir de secret.
