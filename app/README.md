# Pinkall — POC SaaS d’appels coachés

Pinkall est un téléphone de prospection pour iOS, Android et macOS. Le POC
compose un vrai appel avec Telnyx, sépare les deux pistes audio, transcrit avec
Deepgram Flux en direct, synchronise l’appel avec le Mac et produit un débrief
exploitable dans le mini-CRM. Le coach temps réel est optionnel et s’active
depuis l’appel.

Il n’existe aucune datasource métier, transcription ou suggestion simulée dans
le runtime. Sans clés fournisseur, l’application reste navigable mais affiche
explicitement que l’appel ou la transcription est indisponible.

## Flux implémenté

```text
Flutter
  -> POST /v1/voice/token (JWT Telnyx éphémère)
  -> création de la session Pinkall
  -> A-leg WebRTC Telnyx parquée
  -> webhook Telnyx Ed25519 vérifié
  -> B-leg PSTN créée et reliée à l’A-leg
  -> Media Streaming, pistes seller/prospect séparées
  -> gate de consentement à la transcription
  -> Deepgram Flux live, par piste
  -> transcript et coach optionnel dans l’app
  -> Voxtral batch, débrief final et CRM
```

Le transport audio live suit Telnyx → Deepgram Flux ; Voxtral reste l’adaptateur
batch final et le fallback live remplaçable. Quand l’utilisateur active le
coach pendant l’appel, OpenAI reçoit uniquement le transcript et le contexte
commercial explicitement autorisé. Mistral reste exclusivement dédié à la
transcription. Une recommandation rattachée au catalogue conserve ses sources ;
une interprétation IA sans carte éligible reste explicitement non sourcée.
Le canal `internal_alpha` autorise explicitement quelques cartes encore en
revue pour tester le POC ; il ne les présente pas comme approuvées.

Au premier démarrage, le workspace enregistre une présentation Markdown de
l’entreprise, de l’offre, de l’ICP, du pitch et de la stratégie. Chaque session
fige une révision de ce contexte côté serveur pour alimenter le coach live et le
débrief sans exposer le document dans le JSON public. Le débrief v2 ajoute les
reformulations exactes du pitch, huit axes calibrés sur un radar et des conseils
transverses vente, marketing, produit, stratégie et communication.

L'écran **Progression** ajoute une lecture historique descriptive : il compare
les derniers appels analysés à la fenêtre précédente, affiche les huit axes du
débrief sur un radar sans score global et montre des mesures objectives
recalculées depuis les transcriptions finales (part de parole vendeur,
questions, durée des tours et hésitations). Les fenêtres proposées par le
client sont de 5, 10 ou 20 appels. Il ne s'agit ni d'un benchmark universel, ni
d'une prédiction de conversion : la rubrique reste versionnée
`performance-v1` et la comparaison porte encore sur l'unique workspace du POC.

## Structure

```text
apps/app_mobile/            Flutter iOS, Android et macOS
apps/api_agent_vocal/       Backend Dart Telnyx, Deepgram/Voxtral et coach
packages/core_foundation/   Résultats, erreurs et bases des use cases
packages/core_domain/       Entités et contrats indépendants des fournisseurs
packages/core_data/         Adaptateurs HTTP, WebSocket et Telnyx SDK
packages/core_presentation/ Design system partagé
knowledge/coaching/         Sources, claims, cartes et politique de publication
docs/                       PRD, architecture, sprint et stories BMAD
```

La règle normative de dépendances est dans [ARCHITECTURE.md](ARCHITECTURE.md).

## Ce qu’il faut configurer

### Telnyx

1. Créer une Credential Connection WebRTC et activer **Park Outbound Calls**.
2. Créer une application Call Control distincte, reliée à un Outbound Voice
   Profile.
3. Pointer le webhook de la Credential Connection vers
   `https://<domaine>/v1/telnyx/webhooks`.
4. Relever l’ID de la Telephony Credential, les deux connection IDs, la clé
   publique de signature Telnyx et un numéro appelant E.164 autorisé.
5. Exposer le backend par une URL HTTPS publique ; Telnyx ouvrira le WebSocket
   WSS dérivé sur `/v1/telnyx/media/:sessionId`.

Les deux connection IDs doivent être différents : la première reçoit l’A-leg
WebRTC parquée, la seconde crée la B-leg PSTN. Le backend filtre strictement la
première pour éviter qu’un événement de la B-leg ne déclenche une boucle.

### Transcription et coach

- `DEEPGRAM_API_KEY` active Deepgram Flux, moteur live principal de détection
  des tours et de transcription.
- `MISTRAL_API_KEY` active le fallback Voxtral Realtime et la transcription
  finale batch.
- `OPENAI_API_KEY` active exclusivement le coach live et le débrief via l’API
  Responses en texte. L’audio n’est jamais envoyé à OpenAI et il n’existe aucun
  fallback du coach vers Mistral.
- Le coach démarre `off` et s’active depuis l’écran d’appel ;
  `COACH_CATALOG_DIR` reste obligatoire pour produire une suggestion.
- Les cartes livrées sont volontairement `draft`. Un humain doit les promouvoir
  en `shadow`, puis en `live`, après revue des sources et évaluation.

Copier les noms de [`.env.example`](apps/api_agent_vocal/.env.example) dans
l’environnement du serveur. Le backend ne charge volontairement aucun fichier
`.env` et ne livre aucun secret à l’application.

Sur macOS, ajoute la clé OpenAI au Trousseau sans la placer dans la ligne de
commande ni dans le dépôt ; `security` demandera sa valeur de façon interactive :

```bash
/usr/bin/security add-generic-password -U \
  -a pinkall-poc \
  -s com.pinkall.openai.api-key \
  -w
```

## Lancer en local

Sur la machine POC configurée, les secrets Telnyx, Mistral, OpenAI et le token
interne Pinkall sont conservés dans le Trousseau macOS. Le parcours recommandé
prépare le workspace, vérifie les prérequis, démarre ngrok et l’API puis lance
macOS :

```bash
./tool/bootstrap.sh
./tool/doctor.sh
./tool/dev_macos.sh
```

Pour compiler puis ouvrir le bundle Release contre la même API locale :

```bash
./tool/dev_macos.sh release
```

Pour utiliser directement l'API Render persistante, sans lancer le backend
local ni ngrok :

```bash
./tool/run_macos_render.sh
```

Le script lit `PINKALL_API_BASE_URL` et `PINKALL_SUPABASE_URL` dans
l'environnement ou dans `~/.config/pinkall/render.env`.

Le mode Release est disponible avec
`./tool/run_macos_render.sh release`. Les deux modes vérifient d'abord que
l'API est prête puis activent l'authentification Supabase sur invitation. La clé
publique `publishable` est lue dans le Trousseau sous le compte `pinkall-poc` et
le service `com.pinkall.supabase.publishable-key`, puis transmise avec les URL
publiques HTTPS/WSS comme `dart-define`. Aucun secret Supabase ni jeton
utilisateur n'est compilé dans l'app.

Les scripts détectent l'URL HTTPS/WSS ngrok active et ne recopient aucun secret
dans le dépôt. Le Runner macOS lit le token POC dans le Trousseau avant de créer
le moteur Flutter ; il n’apparaît donc ni dans les arguments de compilation ni
dans `pinkall.app`. `run_poc.sh` utilise Flutter 3.44.3 / Dart 3.12.2,
conformément aux artefacts du workspace. Sans clé Mistral dans le Trousseau, les
appels Telnyx restent disponibles mais la transcription est explicitement
désactivée. Sans clé OpenAI, les appels et la transcription restent disponibles,
mais le coach et le débrief IA sont explicitement indisponibles ; Mistral ne les
remplace jamais.

Pour une configuration manuelle ou une autre machine, depuis ce dossier :

```bash
./tool/flutter.sh pub get

/usr/bin/env \
  PINKALL_ALLOW_EPHEMERAL_STORE=true \
  PINKALL_API_TOKEN=<jeton-local-de-32-octets-ou-plus> \
  ./tool/dart.sh run apps/api_agent_vocal/bin/server.dart
```

Dans un second terminal :

```bash
cd apps/app_mobile
/usr/bin/env \
  PINKALL_API_TOKEN=<même-jeton-local> \
  ../../tool/flutter.sh run -d macos \
  --dart-define=PINKALL_API_BASE_URL=http://127.0.0.1:8080 \
  --dart-define=PINKALL_WS_BASE_URL=ws://127.0.0.1:8080
```

Le token est lu par le processus macOS à l’exécution et n’est donc pas embarqué
dans le binaire. Les builds iOS et Android compilent aussi, mais leur connexion
à un backend SaaS devra passer par l’authentification utilisateur et un jeton
court récupéré après connexion, et non par ce token POC partagé. Pour un
téléphone physique, `127.0.0.1` désigne le téléphone et ne peut pas servir à
joindre le backend du Mac.

Ce lancement local utilise volontairement le store éphémère. Le backend accepte
aussi `DATABASE_URL` avec `PINKALL_STORAGE_TENANT_ID` et persiste alors les
données métier finalisées dans un snapshot PostgreSQL versionné. L’audio, les
deltas STT et une session live restent non reprenables. La progression est
recalculée à la demande depuis les sessions, transcriptions finales et débriefs
de ce snapshot ; elle n'ajoute pas de table analytique ni de score persistant.
Le guide Cloud Run
reste une alternative; la cible retenue Render + Supabase est documentée dans
`infra/render/README.md` et `infra/supabase/README.md`.

## Vérifier

```bash
./tool/check.sh
```

Le backend détaille ses endpoints, ses garde-fous et les inconnues restantes
dans [apps/api_agent_vocal/README.md](apps/api_agent_vocal/README.md).
La séparation entre fonctionnalités actives, fondations désactivées et gates
avant pilote est tenue dans [docs/beta-readiness.md](docs/beta-readiness.md).
