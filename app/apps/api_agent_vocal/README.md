# Pinkall API Agent Vocal — POC réel

Backend Dart modulaire pour le flux Telnyx Media Streaming → STT remplaçable →
événements client → coaching optionnel. Il ne contient aucune transcription,
contact ou résultat d’appel préfabriqué. Les seuls conseils possibles viennent
du catalogue de sources versionné dans `knowledge/coaching`.

## Garde-fous

- Toutes les clés restent dans les variables d’environnement du serveur.
- Le mobile obtient un JWT Voice SDK court via `POST /v1/voice/token`; la clé
  API Telnyx ne quitte jamais le backend et le jeton n’est jamais journalisé.
- Tous les endpoints métier exigent `Authorization: Bearer <token>`. Le mode
  SaaS vérifie les access tokens Supabase via JWKS (`ES256`/`RS256`), résout la
  membership PostgreSQL, puis injecte un `AuthPrincipal` (`userId`,
  `workspaceId`, `mode`, `membershipRole`) dans le contexte de la requête. Le
  bearer partagé du POC n'est accepté que si
  `PINKALL_ALLOW_POC_BEARER=true`.
- Le WebSocket Telnyx utilise un jeton aléatoire propre à la session dans son
  URL. Le serveur ne journalise que le path; l’ingress et le reverse proxy
  doivent masquer toute query string. Le jeton n’est accepté que pendant les
  états `created/active` et devient invalide à la fin de la session.
- Une session commence avec `transcription_allowed=false`. Avant
  `POST /v1/sessions/:id/transcription-consent`, les frames audio sont jetées
  sans décodage, buffer ni appel fournisseur.
- Le coach est `off`, `shadow` ou `live`. `off` ne fait aucun appel au modèle
  texte. `shadow` mesure sans publier. `live` ne peut sélectionner qu’une carte
  autorisée par la politique de release. `strict` exige une carte revue ;
  `internal_alpha` autorise explicitement les cartes draft éligibles du POC
  sans les présenter comme approuvées.
- `POST /v1/sessions` accepte un `preparation_markdown` optionnel. Il est
  normalisé, limité à 32 Kio UTF-8 et persisté avec la session. OpenAI le
  reçoit dans son entrée comme contexte utilisateur non fiable : il peut
  orienter les priorités, mais ne peut ni remplacer les règles système, ni
  servir de preuve, ni élargir le catalogue de recommandations.
- Le sélecteur reçoit uniquement le texte produit par l’adaptateur STT et utilise
  OpenAI Responses avec un schéma JSON strict. Les IDs de carte et de preuve
  sont contraints puis revérifiés côté serveur. Deepgram et Mistral restent
  cantonnés au STT et aucune session audio OpenAI Realtime n’est ouverte.
- Le catalogue n’est chargé que si `COACH_CATALOG_DIR` est défini. Il n’existe
  aucun fallback inventé.
- Sans `DATABASE_URL`, le store mémoire démarre vide, perd tout au redémarrage
  et exige `PINKALL_ALLOW_EPHEMERAL_STORE=true`. Avec `DATABASE_URL` et
  `PINKALL_STORAGE_TENANT_ID`, le POC hydrate puis persiste un snapshot JSONB
  versionné (`schema/002_poc_snapshot.sql`) avant de répondre. Contacts,
  sessions terminales, transcripts finaux, débriefs, préférences,
  feedback/outcomes survivent. Audio, deltas STT et sessions live ne sont pas
  reprenables; une session live restaurée devient
  `interrupted_by_server_restart`. `schema/001_initial.sql` reste le modèle
  relationnel SaaS cible, pas une promesse déjà implémentée.
- `schema/003_saas_auth_foundation.sql` normalise uniquement workspaces et
  memberships. Tant que les appels restent dans le snapshot global, un JWT
  Supabase n'est accepté que pour `PINKALL_SNAPSHOT_WORKSPACE_ID`; cela évite
  de présenter une fausse isolation multi-tenant.

## Démarrage

Depuis `app/`, utilisez le Dart fourni avec Flutter 3.44.3 / Dart 3.12.2 :

```bash
./tool/doctor.sh
./tool/dev_macos.sh
```

Le lanceur POC lit les secrets dans le Trousseau macOS, détecte le tunnel ngrok
HTTPS actif et ne journalise pas les clés. Ajouter la clé Deepgram sous le
service `com.pinkall.deepgram.api-key` active automatiquement Flux ; en son
absence, le lanceur conserve Voxtral en temps réel :

```bash
/usr/bin/security add-generic-password -U -a pinkall-poc \
  -s com.pinkall.deepgram.api-key -w
```

Pour une configuration manuelle :

```bash
./tool/flutter.sh pub get
./tool/dart.sh run apps/api_agent_vocal/bin/server.dart
```

Copier les noms de `.env.example` dans l’environnement du processus; le serveur
ne charge volontairement pas de fichier `.env`. `GET /health` expose seulement
`status` et `ready`; les diagnostics `GET /v1/health` et `GET /v1/config`
demandent le bearer et n’affichent jamais les secrets.
Pour Render + Supabase, utiliser le Shared Session pooler IPv4 `:5432` avec
`sslmode=verify-full` et la CA montée via `DATABASE_SSL_ROOT_CERT`; voir
`infra/render/README.md` et
`infra/supabase/README.md`. Pour la transition, le bearer global peut rester
activé explicitement en parallèle de Supabase Auth, puis être supprimé une
fois les clients migrés.

## Contrat `/v1`

- `GET|POST /sessions`; la création accepte notamment
  `preparation_markdown?: string|null` pour le texte d’un fichier `.md` ou du
  Markdown saisi directement
- `POST /sessions/external` crée une session macOS hors téléphonie avec
  `{ "source": "macos_meeting", "title"?, "locale"?,
  "preparation_markdown"?, "coach_mode_override"? }` et retourne deux URLs
  WebSocket éphémères, une pour `seller` et une pour `prospect`
- `POST /voice/token` avec `{ "device_id": "..." }` retourne directement
  `{ token, expires_at, caller_name, caller_number }`
- `GET /sessions/active` et `WS /events` pour synchroniser mobile et Mac dans
  le workspace POC identifié par le bearer
- `POST /sessions/:id/transcription-consent`
- `POST /sessions/:id/cancel` annule idempotemment une session créée lorsque
  le dial client échoue (`failure_reason=client_dial_failed`)
- `POST /sessions/:id/finalize`
- `GET /sessions/:id/debrief`
- `PATCH /sessions/:id/coach-mode`
- `WS /sessions/:id/events` et `GET /sessions/:id/events/sse`
- `GET /sessions/:id/transcript/final`
- `POST /telnyx/webhooks` est public mais refuse toute requête sans signature
  Ed25519 Telnyx valide et timestamp frais
- `WS /telnyx/media/:id?token=...`
- `WS /sessions/:id/media/client?track=seller|prospect&sample_rate=16000&token=...`
  ingère uniquement des frames binaires PCM S16LE mono 16 kHz
- `POST /recording-imports`, `GET /recording-imports/:id`,
  `PUT /recording-imports/:id/audio` et
  `POST /recording-imports/:id/speaker-assignment` forment le parcours
  d’import d’un enregistrement existant décrit ci-dessous
- `GET|POST /contacts`, `POST /contacts/import`
- `POST /call-eligibility/evaluate`
- `GET|PUT /coach/preferences/me`
- `GET /coaching/progress?window=5&limit=20`
- `POST /coaching/feedback`
- `PUT /sessions/:id/outcome`
- `GET /metrics`

### Finalisation et débrief fiable

`POST /v1/sessions/:id/finalize` conserve son contrat : le transcript final
reste utilisable et la route renvoie `200` même si le fournisseur de débrief
échoue. La réponse et les snapshots de session exposent désormais
`debrief_generation` avec `status`, `attempt_count`, `failure_code`,
`retryable`, `updated_at` et, pendant un backoff, `next_retry_at`. Les codes
sont sanitisés ; ni transcript, ni numéro, ni corps de réponse fournisseur ne
sont persistés ou journalisés dans ce diagnostic.

L’adaptateur OpenAI ne retente que les pannes explicitement transitoires :
transport, timeout, HTTP 408/409/429/5xx ou réponse fournisseur encore
`incomplete|in_progress`. Le nombre de tentatives et le délai total sont
bornés. Un JSON tronqué, une erreur de schéma, une preuve invalide, un refus ou
une validation métier échoue immédiatement sans nouvelle dépense modèle. Les
appels concurrents pour la même session partagent toujours un seul job.

Avec le snapshot PostgreSQL, les états `pending`, `running` et `retrying`
survivent au redémarrage et sont repris idempotemment au bootstrap. Un échec
terminal n’est jamais relancé automatiquement. Cette reprise reste une tranche
mono-instance du POC : ce n’est pas encore une file distribuée avec lease,
dead-letter queue et isolation relationnelle multi-workspace. Ces garanties
nécessiteront la migration du snapshot d’appels vers le modèle SaaS normalisé.

### Progression historique

`GET /v1/coaching/progress` exige le bearer métier. `window` définit la taille
de la fenêtre courante et de la fenêtre précédente (`1..20`, défaut `5`) ;
`limit` borne l'historique détaillé renvoyé (`1..50`, défaut `20`). Une valeur
hors bornes ou non numérique renvoie `400`.

Le service trie les appels analysables chronologiquement, compare les `window`
plus récents aux `window` qui les précèdent, puis renvoie notamment :

- `session_count`, `analyzed_call_count`, `current_window_size`,
  `previous_window_size` et `has_comparison` ;
- `axes`, moyenne des huit axes du débrief v2 avec `current_score`,
  `previous_score`, `delta`, signal dominant, observation récente et taille
  d'échantillon ;
- `observed_metrics`, moyennes déterministes courantes/précédentes de
  `seller_talk_ratio`, `question_count`, `average_seller_turn_seconds`,
  `longest_seller_turn_seconds`, `hesitation_count`,
  `questions_per_minute` et `hesitations_per_minute` ;
- `focus`, axe courant le plus bas, `strength`, axe courant le plus haut, et
  `recent_calls` pour la tendance et l'accès au détail ;
- `version: 1`, `rubric_version: "performance-v1"`, `storage`,
  `scope: "single_snapshot_workspace"`, `workspace_id` et `auth_mode`.

Un appel n'entre dans les agrégats que si son débrief possède exactement les
huit axes attendus et la même `performance_rubric_version`. Cette version est
persistée dans chaque débrief afin de ne pas mélanger deux grilles futures dans
une comparaison. Les métriques objectives sont recalculées côté serveur à
partir des segments finaux horodatés et étiquetés `seller`/`prospect`. Les
fragments STT vendeur consécutifs sont fusionnés jusqu'à un silence de 1,5 s ;
ces mesures ne sont pas estimées par OpenAI. L'absence de transcript exploitable
produit
des métriques `null` plutôt que des valeurs inventées. La réponse ne contient
aucun score global, classement, cible universelle ou prédiction de conversion.

Limites du POC : même avec Supabase Auth, le snapshot désigne encore un unique
workspace lié à l'instance ; les
appels ne sont pas encore filtrés par type, ICP ou objectif comparable, et les
agrégats sont reconstruits en mémoire à chaque requête. Avec PostgreSQL, leurs
artefacts sources survivent dans le snapshot JSONB ; avec le store éphémère,
l'historique disparaît au redémarrage. L'audio, les deltas STT et les sessions
live ne deviennent pas durables grâce à cet endpoint.

## Confidentialité et cycle de vie des données

Les routes suivantes sont authentifiées et bornées au workspace résolu par le
middleware :

- `GET /v1/privacy/export` produit un export JSON portable du contexte, des
  contacts, préférences, sessions, transcripts finaux et débriefs. Il exclut
  le jeton média et l'audio brut ;
- `GET /v1/privacy/retention` effectue un dry-run de la politique de rétention
  des sessions terminales ;
- `POST /v1/privacy/retention/apply` exige un rôle `owner|admin` et la
  confirmation exacte `APPLY 90 DAY RETENTION` ;
- `DELETE /v1/privacy/workspace-data` exige le rôle `owner`, la confirmation
  exacte `DELETE MY PINKALL WORKSPACE`.

Les deux mutations destructives exigent en plus une session utilisateur
Supabase active ; le bearer POC partagé peut exporter et prévisualiser, mais il
est refusé pour appliquer la rétention ou vider le workspace.

La rétention et la suppression refusent toute mutation pendant un appel, un
import audio ou une génération post-appel en cours. La barrière couvre à la
fois les statuts durables et les jobs conservés en mémoire ; après une mutation
sûre, les métadonnées d'import devenues orphelines sont aussi purgées. Toutes
les réponses `/v1/privacy/*`, y compris les erreurs, utilisent
`Cache-Control: private, no-store`.

La suppression efface les données métier du snapshot et les métadonnées
d'import transitoires, mais **pas** l'identité Supabase Auth. Elle ne lance pas
non plus une demande d'effacement chez les fournisseurs externes éventuellement
utilisés (Telnyx, Deepgram, OpenAI ou Mistral) : ces opérations de contrôle et
leur preuve restent une procédure privilégiée distincte. La réponse expose
explicitement `auth_identity_deleted: false` et
`external_provider_deletion_requested: false` pour éviter de promettre une
purge non exécutée. La rétention n'est pas encore planifiée automatiquement :
l'endpoint explicite évite une suppression silencieuse tant que la politique
juridique et produit n'a pas été validée. Chaque réponse transporte
`X-Request-Id` et chaque ligne de télémétrie HTTP exclut body, query string,
authorization, transcript et numéro de téléphone.

## Protocoles vérifiés

Telnyx envoie d’abord `connected`, puis `start`, des frames `media` base64 avec
`track` inbound ou outbound, puis `stop`. Le handshake `connected` est un no-op
explicite. Le POC décode PCMU, PCMA et L16 vers PCM S16LE. Les codecs compressés
non pris en charge échouent explicitement.

Pour une session externe, chaque source macOS utilise son propre WebSocket et
envoie directement du PCM S16LE mono 16 kHz, sans JSON ni base64. Le jeton média
de la session remplace le bearer sur ce seul endpoint. Une frame est limitée à
64 Kio et chaque connexion à 512 Kio sur cinq secondes. Les codes de fermeture
privés sont stables : `4003` type non binaire, `4007` PCM invalide, `4008`
conflit de piste, `4009` taille ou capacité dépassée, `4011` erreur interne et
`4013` quota dépassé. Avant le consentement, les octets sont consommés puis
jetés sans buffer ni STT. La session passe à `stopped` après la fermeture de la
dernière piste ; le client appelle ensuite l’endpoint de finalisation existant.

## Import d’un enregistrement après l’appel

Le parcours est volontairement en cinq temps afin de ne jamais attribuer un
rôle humain à partir de la seule diarisation :

1. `POST /v1/recording-imports` avec le bearer et
   `{source:"recording_import",file_name,mime_type,size_bytes,title?,locale?,preparation_markdown?}`
   crée une session coach `off`. La réponse `201` contient un `upload_url`
   relatif au même origin et le statut `awaiting_consent`.
2. Le client utilise le endpoint existant
   `POST /v1/sessions/:session_id/transcription-consent`. Aucun octet audio
   n’est accepté avant cet accord explicite.
3. `PUT /v1/recording-imports/:id/audio` reçoit directement le flux binaire,
   avec son vrai `Content-Type` et, si possible, `Content-Length`. La taille
   reçue doit correspondre exactement au `size_bytes` déclaré. La réponse
   `202` passe à `transcribing` ; le client poll le `GET`.
4. Une fois Deepgram terminé, le statut devient
   `awaiting_speaker_assignment`. La réponse ne contient que `voices: ["A",
   "B", ...]` et des `provisional_segments` avec `voice`, texte et timings :
   aucun `seller`, `prospect` ou `track`. Les lettres suivent la première
   apparition des identifiants opaques du diarizer ; une voix absente n’est
   jamais inventée.
5. `POST /v1/recording-imports/:id/speaker-assignment` avec
   `{ "user_voice": "A" }` transforme seulement alors cette voix en `seller`
   et les autres voix détectées en `prospect`, persiste le transcript final,
   puis exécute l’analyse OpenAI post-appel. Répéter la même assignation est
   idempotent ; tenter de la changer après finalisation renvoie `409`.

Formats acceptés : WAV, MP3, M4A/MP4 audio, AAC, FLAC, OGG/Opus et WebM audio.
Les alias MIME Apple usuels sont normalisés, mais l’extension et le MIME doivent
rester cohérents. Limites POC : 200 Mio par fichier, trois heures, 10 Mbit/s
encodés, deux transcriptions simultanées, dix démarrages et 400 Mio reçus par
minute et par processus. L’upload est streamé dans un répertoire temporaire
unique puis supprimé dans tous les chemins de succès/erreur et au shutdown. Le
fichier et le transcript provisoire ne rejoignent jamais le snapshot durable.
Après une erreur retryable, le client renvoie le `PUT` complet car Pinkall ne
conserve volontairement aucun audio à rejouer.

Le premier adaptateur utilise la clé `DEEPGRAM_API_KEY` existante, l’endpoint
EU `/v1/listen`, Nova-3, `diarize_model=latest`, `utterances=true` et
`smart_format=true`. Chaque requête envoie aussi `mip_opt_out=true` pour
exclure ces appels du programme d’amélioration des modèles Deepgram. Les
overrides optionnels sont
`DEEPGRAM_PRERECORDED_BASE_URL`, `DEEPGRAM_PRERECORDED_MODEL` et
`DEEPGRAM_DIARIZE_MODEL`. La phase provisoire et son job restent locaux au
processus POC : après un restart pendant l’import, le client doit recréer et
réenvoyer l’import. Le transcript final et le débrief restent, eux, durables.

Avec `STT_PROVIDER=deepgram_flux`, chaque piste Telnyx mono ouvre sa propre
connexion sur l’endpoint européen Deepgram `/v2/listen`. L’adaptateur envoie le
PCM S16LE brut en blocs de 80 ms et interprète `Update`, `StartOfTurn`,
`EagerEndOfTurn`, `TurnResumed` et `EndOfTurn`. `EagerEndOfTurn` lance le
sélecteur OpenAI en avance, mais son résultat reste bloqué jusqu’au
`EndOfTurn` final. `TurnResumed` invalide la tentative et une révision du texte
final force une nouvelle évaluation ; aucun conseil spéculatif n’est exposé.
Pinkall n’applique donc pas son ancien délai local de 2,5 s à Flux. Un watchdog
séparé de 12 s ne finalise une prise de parole que si le fournisseur n’émet
plus aucun signal de tour. Les valeurs POC par défaut
sont `DEEPGRAM_EOT_THRESHOLD=0.7`, `DEEPGRAM_EAGER_EOT_THRESHOLD=0.45` et
`DEEPGRAM_EOT_TIMEOUT_MS=6000` ; elles restent configurables par environnement.

`STT_PROVIDER=voxtral` conserve l’ancien adaptateur temps réel. Dans les deux
cas, le transcript final est recalculé par l’endpoint batch Mistral/Voxtral à
partir du PCM consenti conservé en mémoire : une panne du live ne supprime donc
pas la source du débrief.

Références officielles :

- https://developers.telnyx.com/docs/voice/programmable-voice/media-streaming
- https://developers.telnyx.com/docs/voice/webrtc/auth/jwt
- https://developers.telnyx.com/docs/voice/webrtc/use-cases/outbound-dialer/
- https://developers.telnyx.com/api-reference/call-commands/dial
- https://developers.telnyx.com/docs/voice/programmable-voice/voice-api-webhooks
- https://developers.deepgram.com/docs/flux/quickstart
- https://developers.deepgram.com/docs/flux/state
- https://developers.deepgram.com/docs/flux/language-prompting
- https://developers.deepgram.com/docs/flux/close-stream
- https://developers.deepgram.com/docs/pre-recorded-audio
- https://developers.deepgram.com/docs/diarization/
- https://developers.deepgram.com/docs/utterances
- https://docs.mistral.ai/studio-api/audio/speech_to_text/realtime_transcription
- https://docs.mistral.ai/api/endpoint/audio/transcriptions
- https://developers.openai.com/api/docs/guides/structured-outputs

## Topologie Telnyx sortante implémentée

La Credential Connection WebRTC doit avoir **Park Outbound Calls** activé et
envoyer ses webhooks vers `POST /v1/telnyx/webhooks`. Le chemin est le suivant :

1. le Flutter compose l’appel avec le `client_state` Pinkall ;
2. Telnyx parque l’A-leg WebRTC et envoie `call.initiated` ;
3. le backend vérifie Ed25519 sur `timestamp|raw_body`, impose une fenêtre de
   cinq minutes et déduplique `data.id` ;
4. seuls `state=parked`, `direction=outgoing` et
   `connection_id=TELNYX_WEBRTC_CONNECTION_ID` peuvent réserver atomiquement
   la session ; les événements de la B-leg sont ignorés avant décodage ;
5. le backend vérifie `pinkall_session_id`, `correlation_id` et la destination,
   puis appelle `POST /v2/calls` avec `link_to`, `bridge_intent=true`,
   `bridge_on_answer=true`, un `command_id` idempotent et
   `stream_track=both_tracks` ;
6. Telnyx ouvre le WebSocket média de la session et relie automatiquement la
   B-leg PSTN à l’A-leg quand le prospect répond.

Le scope entrant reste explicitement hors POC. La réservation Telnyx est
incluse dans le snapshot PostgreSQL, mais la déduplication des événements et le
live restent locaux à l’unique instance : la production exigera des contraintes
relationnelles, une outbox/queue et un fan-out durable. Aucun header
`stream_auth_token` n’est supposé : le POC conserve son URL WSS à jeton opaque,
unique par session, et exige la redaction des query strings à l’infrastructure.

## Inconnues à valider par un appel réel

- La sémantique exacte inbound/outbound dépend de la topologie du call leg;
  l’API exige donc `seller_track` au lieu de la deviner.
- La corrélation `client_state` → session Pinkall → `call_control_id` est
  implémentée mais doit encore être prouvée par un appel sur le compte Telnyx
  cible et sa Credential Connection réellement configurée.
- PCMU et PCMA sont couverts. OPUS, G722 et AMR-WB nécessitent un transcodeur
  audio explicite avant production.
- Les performances, WER français, stabilité des segments et latence coach
  doivent être évaluées avec des appels consentis; aucun chiffre n’est simulé.
- Le gate d’éligibilité est conservateur et ne remplace pas une validation
  juridique ni les règles sectorielles.
