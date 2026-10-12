# Pinkall Flutter

Application Pinkall commune à iOS, Android et macOS. Elle utilise le backend
SaaS pour obtenir un jeton Telnyx éphémère : aucune clé API Telnyx et aucun
identifiant SIP persistant ne sont demandés à l’utilisateur.

Fonctions du POC :

- clavier et appel depuis le device courant ;
- gate d’éligibilité B2B/B2C avant composition ;
- session créée avant le dial et corrélée à Telnyx ;
- transcript vendeur/prospect et consentement séparé ;
- action « Activer le coach » disponible pendant l’appel, avec `shadow`
  invisible côté client ;
- débrief final, contacts et import CSV/JSON ;
- écran « Progression » : radar historique des huit axes sans score global,
  comparaison des 5, 10 ou 20 derniers appels à la fenêtre précédente,
  métriques objectives, priorité, point fort et accès aux appels récents ;
- compagnon macOS synchronisant les sessions actives du workspace ;
- « Instant Help » sur macOS : capture consentie du son système et du micro
  pour coacher un appel Meet/Zoom puis produire le même débrief ;
- import post-appel iOS/Android depuis la feuille de partage, « Ouvrir avec
  Pinkall », le raccourci d’app ou l’action Raccourcis iOS.

Un appel lancé depuis le Mac utilise directement son micro et sa sortie audio,
sélectionnables dans l’écran d’appel. Lorsqu’un appel est lancé sur le mobile,
le Mac peut en afficher le transcript et le coach en compagnon, mais le POC ne
transfère pas silencieusement l’audio d’un appareil à l’autre.
Les systèmes mobiles n’autorisent pas Pinkall à capturer secrètement les deux
côtés d’un appel cellulaire en cours. Le parcours mobile traite donc un
enregistrement existant obtenu avec l’accord des participants : copie native
streamée et bornée dans le cache privé, consentement confirmé avant upload,
diarisation sans rôles, puis identification explicite de la voix de
l’utilisateur avant tout mapping vendeur/prospect.
L’authentification Telnyx manuelle n’existe qu’en mode diagnostic explicite via
`PINKALL_ENABLE_MANUAL_TELNYX_AUTH=true` et reste masquée par défaut.

## Lancer

### Authentification SaaS Supabase (iOS, Android et macOS)

Pinkall initialise le SDK officiel uniquement lorsque les deux valeurs
publiques suivantes sont fournies à la compilation :

```bash
../../tool/flutter.sh run -d macos \
  --dart-define=PINKALL_API_BASE_URL=https://api.example.com \
  --dart-define=PINKALL_WS_BASE_URL=wss://api.example.com \
  --dart-define=PINKALL_SUPABASE_URL=https://PROJECT.supabase.co \
  --dart-define=PINKALL_SUPABASE_PUBLISHABLE_KEY=sb_publishable_...
```

La clé attendue est exclusivement la clé **publishable** publique du projet.
Ne jamais utiliser une clé `service_role` dans une application Flutter. Le
jeton utilisateur n'est pas un `dart-define` : il provient de la session
Supabase restaurée, puis est relu ou rafraîchi avant chaque requête HTTP et
chaque nouvelle connexion WebSocket.

Le parcours est volontairement sur invitation : l'app ne propose aucune
création de compte. Dans Supabase :

1. activer le provider Email dans `Authentication > Providers` ;
2. désactiver `Allow new users to sign up` ;
3. créer les utilisateurs autorisés depuis `Authentication > Users` (pour le
   POC, compte confirmé avec mot de passe temporaire transmis séparément) ;
4. conserver les expirations et la rotation des refresh tokens activées.

Le SDK persiste et restaure la session avec son stockage Flutter officiel. Le
bouton de déconnexion supprime la session locale et remet immédiatement
l'AuthGate. Une erreur Supabase brute n'est jamais affichée : l'interface ne
reçoit que des catégories stables (`invalidCredentials`, réseau,
indisponible, inconnu).

`PINKALL_API_TOKEN` reste uniquement un fallback de développement lu à
l'exécution. Dès qu'une des deux valeurs Supabase est présente — même si la
configuration est incomplète — ce fallback est ignoré afin d'éviter tout
retour silencieux à un token partagé.

### API hébergée Render

Le lanceur hébergé compile les URL publiques HTTPS/WSS de Render et active le
parcours Supabase sur invitation. Il ne démarre ni API locale ni tunnel ngrok
et n'embarque aucun secret dans le bundle. Depuis la racine `app/` :

```bash
./tool/run_macos_render.sh
```

Pour compiler puis ouvrir le bundle Release :

```bash
./tool/run_macos_render.sh release
```

Le lanceur attend la clé publique `publishable` du projet dans le Trousseau :
compte `pinkall-poc`, service `com.pinkall.supabase.publishable-key`. Cette clé
est publique et compilée dans le client ; les autorisations reposent sur la
session utilisateur, l'Auth Supabase et les politiques RLS. Ne jamais utiliser
une clé `secret` ou `service_role`. Pour l'ajouter sans la mettre dans
l'historique du terminal :

```bash
/usr/bin/security add-generic-password -U \
  -a pinkall-poc \
  -s com.pinkall.supabase.publishable-key \
  -w
```

### API locale

Le backend local et ngrok doivent être démarrés en premier. Depuis ce dossier :

```bash
./run_poc_macos.sh
```

Ce lanceur macOS utilise le tunnel ngrok HTTPS/WSS actif. Le bootstrap natif du
Runner récupère le token POC dans le Trousseau avant le démarrage de Flutter,
sans l’embarquer dans le bundle. Depuis la racine du
workspace, `./tool/dev_macos.sh release` compile et ouvre directement la version
Release avec l’API locale et ngrok. Pour une configuration manuelle :

```bash
flutter pub get
PINKALL_API_TOKEN=<jeton-du-backend> \
flutter run -d macos \
  --dart-define=PINKALL_API_BASE_URL=http://127.0.0.1:8080 \
  --dart-define=PINKALL_WS_BASE_URL=ws://127.0.0.1:8080
```

Le token POC est lu à l’exécution sur macOS et n’est jamais compilé dans
`pinkall.app`. Les cibles iOS et Android sont compilables, mais leur accès SaaS
doit utiliser une authentification utilisateur et un jeton court récupéré à
l’exécution. Sur un appareil physique, utiliser une URL HTTPS/WSS joignable par
celui-ci.

Sans configuration backend ou fournisseur, l’interface l’indique et ne crée
aucun faux appel, faux transcript ou faux conseil.

Le dashboard ne calcule rien dans Flutter : il consomme
`GET /v1/coaching/progress` afin que les fenêtres, exclusions et mesures restent
identiques sur iOS, Android et macOS. Une fenêtre précédente absente est
présentée comme telle, sans delta inventé. Les axes résument la rubrique
`performance-v1` du débrief ; les durées, questions, hésitations et parts de
parole sont recalculées côté serveur depuis la transcription finale.

Consultez la [documentation du workspace](../../README.md) pour la configuration
Telnyx, Deepgram pour le STT temps réel et batch, et OpenAI pour le coach et le
débrief.

## Ouvrir le composeur par deep link

Pinkall accepte un numéro E.164 encodé dans le paramètre `number` :

```text
pinkall://call?number=%2B33612345678
https://www.pinkall.app/call?number=%2B33612345678
```

Le lien ouvre l'écran Appeler, normalise aussi les numéros français commençant
par `06` ou `07`, puis préremplit le champ. Il ne lance jamais l'appel sans une
action explicite de l'utilisateur. Le schéma `pinkall://` fonctionne sur les
trois plateformes installées. Le lien HTTPS est préparé pour iOS et Android ;
sa vérification dépend des profils Apple et de la clé de signature Android de
distribution. macOS reste sur le schéma personnalisé tant que le bundle est
signé ad hoc.

## Appels entrants en arrière-plan

Les bridges PushKit/CallKit et FCM/ConnectionService sont compilables mais
désactivés par défaut. Pinkall affiche leur capacité réelle et ne déduit jamais
qu’un appareil peut sonner en arrière-plan de la seule présence du code.

La configuration Apple, Firebase et Telnyx, les flags d’activation et les
limites Android restantes sont documentés dans
[`docs/incoming-calls-native-setup.md`](../../docs/incoming-calls-native-setup.md).

## Avertissements macOS connus avec Flutter 3.44.x

La commande `flutter build macos --release` peut actuellement afficher deux
avertissements qui ne rendent pas l'artefact invalide :

- `flutter_webrtc` 1.5.2 ne fournit pas encore de package SwiftPM. Pinkall reste
  donc compilé par la voie CocoaPods supportée par Flutter 3.44. Ne pas intégrer
  la [PR SwiftPM amont](https://github.com/flutter-webrtc/flutter-webrtc/pull/2062)
  tant qu'elle n'est pas fusionnée et publiée : elle contient encore des
  problèmes de compilation signalés par ses mainteneurs. Mettre à jour la
  dépendance dès qu'une version officielle avec SwiftPM est disponible, avant
  d'adopter une version de Flutter qui ne tolère plus le fallback CocoaPods.
- Le message `objective_c.framework` / `objective_c1.framework` est causé par
  le regroupement multi-architecture de Flutter stable, pas par le hook
  `objective_c`. Le [bug Flutter #188878](https://github.com/flutter/flutter/issues/188878)
  est corrigé sur la branche Flutter suivante, mais se reproduit encore en
  3.44.x. Ne pas rétrograder `objective_c`, limiter l'application à une seule
  architecture ou modifier le SDK local pour masquer ce message.

L'artefact Release doit néanmoins être contrôlé avec `lipo -info` pour le
binaire de l'app et `objective_c.framework`, puis avec
`codesign --verify --deep --strict`. Les deux binaires attendus sont universels
(`x86_64 arm64`) et la signature doit être valide.
