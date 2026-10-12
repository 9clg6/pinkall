# Pinkall — état de préparation bêta

**Photographie au 14 juillet 2026.** Ce document distingue le code livré de ce
qui est réellement activé. Il ne constitue pas un avis juridique.

## Périmètre bêta réaliste

La première bêta doit rester **sur invitation, sortante uniquement, pour un
seul workspace et une seule instance API**. Les appels entrants natifs, le
multi-workspace métier et toute promesse de coaching « validé scientifiquement »
sont hors périmètre tant que leurs gates ci-dessous ne sont pas franchis.

## Actif dans le POC

- [x] Appels sortants Telnyx depuis Pinkall, avec jetons Voice SDK courts émis
  par l'API ; aucun secret Telnyx n'est embarqué dans Flutter.
- [x] Flux média vers STT, transcription vendeur/prospect, coaching optionnel,
  débrief et historique CRM dans le parcours POC réel.
- [x] Contacts, sessions terminées, transcriptions finales, débriefs,
  préférences et feedbacks persistés dans un snapshot PostgreSQL versionné.
- [x] Deepgram Flux est le premier adaptateur STT live ; OpenAI est le moteur
  de sélection/coaching et de débrief. Le pipeline reste remplaçable par
  fournisseur.
- [x] Brief projet/appel texte ou vocal, import CSV/JSON, Progression et Instant
  Help macOS sont présents dans l'application.
- [x] API de confidentialité protégée par rôle : export portable, aperçu et
  application d'une rétention de 90 jours, suppression des données métier du
  workspace avec confirmations fortes, réponses privées non cachables et
  barrière contre les appels/imports/débriefs encore actifs. Les mutations
  destructives exigent une session Supabase ; le bearer POC est refusé.
- [x] IDs de requête et journaux structurés sans corps, transcription, token ni
  numéro de téléphone.
- [x] La migration Supabase Auth/workspaces/memberships a été appliquée ; les
  politiques RLS et le bootstrap du workspace personnel sont en place.

Ces éléments ont passé les tests et builds locaux du 14 juillet 2026. Ils
restent soumis à la première CI distante verte, aux smoke tests Render et aux
appels réels de la version déployée.

## Compilé mais désactivé ou incomplet

- [ ] **Supabase Auth dans l'app :** login email/mot de passe invite-only,
  restauration de session et JWT dynamiques sont activés dans le build macOS
  Render. Le premier compte et son workspace existent ; il reste à valider sa
  première connexion JWT, la restauration de session et la coupure du bearer
  POC de transition.
- [ ] **Appels entrants iOS :** PushKit et CallKit compilent, mais le flag est
  `false`. Il manque les credentials APNS VoIP/Telnyx, le raccordement final au
  SDK voix et la validation sur iPhone verrouillé.
- [ ] **Appels entrants Android :** FCM et `ConnectionService` compilent, mais
  le flag est `false`. Il manque `google-services.json`, les credentials
  FCM/Telnyx, l'UI plein écran, le raccordement au SDK voix et la validation sur
  appareil verrouillé.
- [ ] **macOS entrant :** aucun réveil natif en arrière-plan n'est promis ;
  l'app doit rester ouverte et connectée.
- [ ] **CI multi-plateforme :** le workflow Android/iOS/macOS est livré, mais
  sa première exécution distante doit être verte avant ouverture. La tentative
  du 14 juillet 2026 a été refusée avant allocation des runners par GitHub pour
  cause de facturation ou de limite de dépense du compte ; aucun job n'a
  démarré.
- [ ] **Signature de distribution :** le build Android release local utilise
  encore la clé debug et le build iOS est validé sans signature. Il manque un
  keystore Android de distribution, les profils/certificats Apple et une
  validation des artefacts signés avant toute diffusion externe.

Ne pas activer les appels entrants seulement parce qu'un token APNS ou FCM est
émis. Le test de bout en bout doit couvrir sonnerie, réponse, audio
bidirectionnel, refus, expiration, appel manqué et second appareil.

## Activation exacte de l'authentification invite-only

### 1. Supabase

- [x] Dans `Authentication > Providers`, activer Email.
- [x] Désactiver toute création de compte publique (`Allow new users to sign
  up`). L'application ne contient volontairement pas de signup.
- [x] Dans `Authentication > Users`, inviter le premier utilisateur et
  confirmer son adresse via le lien à usage limité. Le mot de passe n'est
  jamais transmis par un administrateur : l'utilisateur le choisit sur la page
  d'acceptation Pinkall.
- [x] Déployer `https://www.pinkall.app/auth/invite`, configurer cette page
  comme `Site URL` et redirect autorisé, puis vérifier le parcours
  `updateUser(password)` suivi d'une déconnexion locale.
- [x] Vérifier que le trigger lui a créé exactement un workspace personnel et
  une membership `owner/default`.
- [x] Relever l'UUID de ce workspace ; c'est la valeur de
  `PINKALL_SNAPSHOT_WORKSPACE_ID`, pas l'ID texte du snapshot.
- [x] Pour un utilisateur créé avant la migration seulement, exécuter une fois
  `pinkall_private.pinkall_ensure_personal_workspace(<auth-user-uuid>)`, puis
  conserver l'UUID retourné. Non applicable au premier compte, créé après la
  migration.

Ne jamais placer le mot de passe PostgreSQL, une clé secrète Supabase ou une
clé `service_role` dans Flutter.

### 2. Render/API

Configurer les secrets/variables suivants avec les valeurs du projet :

```text
DATABASE_URL=<shared-session-pooler:5432>?sslmode=verify-full
DATABASE_SSL_ROOT_CERT=/etc/secrets/supabase-ca.crt
PINKALL_STORAGE_TENANT_ID=<identifiant-stable-du-snapshot>
PINKALL_SNAPSHOT_WORKSPACE_ID=<uuid-du-workspace>
SUPABASE_URL=https://<project-ref>.supabase.co
SUPABASE_JWT_AUDIENCE=authenticated
PINKALL_ALLOW_POC_BEARER=true
PINKALL_ALLOW_EPHEMERAL_STORE=false
STRICT_CONFIG=true
```

- [x] Monter la CA Supabase comme secret file, sans la committer.
- [x] Garder `PINKALL_STORAGE_TENANT_ID` inchangé : le modifier ouvre un
  snapshot vide, il ne migre rien.
- [x] Déployer uniquement une image immuable déjà construite :

```bash
./tool/deploy_render.sh --prebuilt \
  --image '<registry-image>@sha256:<digest>'
```

- [ ] Vérifier `GET /health`, puis `GET /v1/me` avec le JWT du premier compte :
  `auth_mode` doit être `supabase_jwt` et `workspace_id` doit être celui lié au
  snapshot. `GET /health` et le fallback POC ont passé le smoke ; le JWT reste
  à vérifier après le choix du mot de passe.
- [ ] Vérifier qu'un JWT d'un autre workspace et un autre
  `X-Pinkall-Workspace-Id` sont refusés.

### 3. Flutter iOS, Android et macOS

Compiler chaque cible avec uniquement les valeurs publiques suivantes :

```bash
../../tool/flutter.sh <run-ou-build> \
  --dart-define=PINKALL_API_BASE_URL=https://<api-host> \
  --dart-define=PINKALL_WS_BASE_URL=wss://<api-host> \
  --dart-define=PINKALL_SUPABASE_URL=https://<project-ref>.supabase.co \
  --dart-define=PINKALL_SUPABASE_PUBLISHABLE_KEY=<publishable-key>
```

- [ ] Le build macOS Release hébergé contient les quatre valeurs publiques et
  affiche l'AuthGate Supabase. Valider ensuite connexion, restauration de
  session, expiration/rafraîchissement,
  déconnexion et reconnexion HTTP/WebSocket sur les trois plateformes.
- [ ] Une fois tous les clients migrés, définir
  `PINKALL_ALLOW_POC_BEARER=false`, retirer `PINKALL_API_TOKEN`, redéployer avec
  `--prebuilt`, puis confirmer qu'un ancien bearer partagé reçoit `401`.

## Limites de données et confidentialité

- [ ] Les memberships sont relationnelles et multi-utilisateurs, mais les
  contacts, appels, transcriptions et débriefs restent dans **un snapshot
  mono-workspace par instance API**. Deux workspaces métier sur la même
  instance ne sont pas isolés au niveau ligne.
- [ ] Conserver une seule instance Render : plusieurs instances peuvent entrer
  en conflit de révision sur le même snapshot.
- [ ] Les appels live, buffers audio et déduplications temps réel ne survivent
  pas à un redémarrage ; la session devient interrompue et ne reprend pas.
- [ ] L'export, la rétention et la suppression existent côté API, mais il
  manque l'UI utilisateur, le scheduler de rétention, la suppression de
  l'identité Supabase Auth, la purge vérifiée chez les fournisseurs et un
  exercice sauvegarde/restauration. L'API ne prétend pas avoir lancé ces deux
  suppressions externes.
- [ ] Avant la bêta, tester l'export et la suppression sur un workspace jetable,
  vérifier la purge des fournisseurs, documenter le délai de traitement des
  demandes RGPD et la procédure support.

Une vraie bêta multi-workspace exige un store relationnel avec `workspace_id`
sur chaque objet métier, une migration des snapshots et des tests d'isolation
croisés. Le JWT actuel ne transforme pas le snapshot global en stockage
multi-tenant.

## Qualité du coach

- [x] Catalogue `1.1.0` : **38 sources, 38 claims et 50 cartes** ; provenance,
  versions, droits et liens sont audités automatiquement.
- [ ] **0 revue humaine** : toutes les claims et cartes restent `draft` et
  `reviews.json` est vide.
- [ ] **Shadow vide** : le harness mesure précision, faux positifs, fidélité aux
  sources, latence et coût, mais aucun jeu d'appels autorisés et annotés par des
  humains n'est disponible.
- [ ] Avant un coach public : revue contradictoire sales/scientifique/juridique,
  droits validés, jeu annoté consentant, seuils approuvés et rapport shadow
  versionné passant tous les gates.

Le mode `internal_alpha` peut servir à la recherche fermée, avec avertissement
explicite. Il ne doit pas être commercialisé comme fiable, approuvé par des
experts ou « ultime ». Le canal strict live reste fermé tant que les cartes
requises ne sont pas en état `live`.

## France et Europe — gate juridique

- [ ] Faire valider par un juriste/DPO la qualification de Pinkall, les rôles
  responsable/sous-traitant, la base légale de chaque traitement, les durées,
  les droits, les transferts hors EEE, les sous-traitants et la nécessité d'une
  AIPD.
- [ ] Afficher et faire prononcer une information claire en début d'appel avant
  enregistrement/transcription/coaching : finalités, destinataires, durée,
  droits d'opposition et d'accès, plus un lien vers l'information complète.
- [ ] Prévoir un parcours sans enregistrement quand il est requis et arrêter
  immédiatement STT/coaching lorsque le consentement ou l'autorisation manque.
- [ ] Documenter les règles de prospection B2B et B2C par pays. En France, à
  compter du **11 août 2026**, le démarchage téléphonique B2C exige en principe
  un consentement préalable, sauf notamment appel lié à un contrat en cours ;
  le B2B reste soumis à information et opposition dans son cadre professionnel.
- [ ] Interdire par défaut les listes dont la source, l'information,
  l'opposition ou, quand requis, la preuve de consentement ne sont pas
  vérifiables.
- [ ] Encadrer séparément l'usage employeur : information des salariés,
  proportionnalité du suivi, accès restreint et absence de décision RH
  automatisée à partir du coaching.

Références de départ à revalider au lancement :
[prospection téléphonique — CNIL](https://www.cnil.fr/fr/prospection-commerciale-par-telephone-hors-automate-dappel-quelles-sont-les-regles),
[information lors d'un enregistrement — CNIL](https://cnil.fr/fr/cnil-direct/question/enregistrement-ou-ecoute-des-conversations-telephoniques-faut-il-informer-ses),
[protection des données — Union européenne](https://europa.eu/youreurope/business/dealing-with-customers/data-protection/data-protection-gdpr/index_fr.htm).

## Décision go / no-go

### GO — pilote interne fermé

- [ ] CI, analyse statique, tests, builds signés et image Docker sont verts sur
  le commit déployé.
- [ ] Smoke tests Render réussis après déploiement `--prebuilt`.
- [ ] Un compte Supabase invité accède uniquement au workspace attendu ; le
  bearer POC est désactivé avant d'inviter une personne externe.
- [ ] Appel réel par plateforme incluse : audio bidirectionnel, tours de parole,
  conseil, fin d'appel, transcript final et débrief sans blocage.
- [ ] Scripts d'information/consentement et règles d'éligibilité sont validés
  juridiquement pour le pays et le segment testés.
- [ ] Export, rétention et suppression ont été exercés sur des données jetables,
  avec une procédure d'incident et de demandes RGPD documentée.
- [ ] Le coach draft est explicitement limité à la recherche interne ; aucune
  affirmation d'efficacité ou d'approbation scientifique n'est publiée.

### GO — bêta externe invite-only

Tous les critères internes, plus :

- [ ] Store relationnel multi-workspace livré **ou** une instance et un snapshot
  dédiés par workspace avec isolation opérationnelle documentée.
- [ ] Scheduler de rétention, suppression d'identité et test de restauration
  opérationnels.
- [ ] Sous-ensemble de cartes revu humainement, droits approuvés et shadow
  versionné au-dessus des seuils convenus avant toute suggestion live visible.
- [ ] Monitoring, alertes, support, budget fournisseurs et procédure de coupure
  du coach testés.

### NO-GO immédiat

- signup public ; bearer partagé accessible à des testeurs externes ; plusieurs
  workspaces dans le snapshot global ; appel entrant activé sans appareil
  physique validé ; suggestion live fondée uniquement sur les 50 cartes draft ;
  enregistrement sans information ; prospection interdite ou sans preuve ;
  secret dans un client/log ; test, build, migration ou smoke test rouge.
