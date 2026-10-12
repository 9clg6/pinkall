# Supabase pour le POC Pinkall

## Décision actuelle

Supabase héberge PostgreSQL et Auth. L'API Dart déployée sur Render est la
seule à recevoir `DATABASE_URL`; Flutter ne reçoit ni mot de passe PostgreSQL,
ni clé `service_role`. Les access tokens utilisateur sont vérifiés côté API
avec les clés publiques JWKS Supabase.

Le stockage actif est un snapshot JSONB par `PINKALL_STORAGE_TENANT_ID`. Il
permet de conserver les contacts, sessions terminées, transcripts finaux,
débriefs, préférences et feedbacks pendant le POC. Ce n'est pas encore le
modèle relationnel multi-tenant du SaaS.

La migration `202607140001_saas_auth_foundation.sql` ajoute les workspaces et
memberships relationnels. Elle ne migre pas les appels : l'API lie donc encore
chaque instance à un unique `PINKALL_SNAPSHOT_WORKSPACE_ID` et refuse un JWT
autorisé pour un autre workspace.

Le dashboard Progression ne nécessite pas de migration supplémentaire :
`GET /v1/coaching/progress` reconstruit ses fenêtres et métriques depuis les
sessions terminales, transcriptions finales et débriefs déjà présents dans ce
snapshot. Aucun agrégat, radar ou score global séparé n'est persisté. Conserver
`PINKALL_STORAGE_TENANT_ID` stable conserve donc les données sources de
l'historique, pas une table analytique multi-workspace.

## Ce qui est déjà prêt

- Migration idempotente :
  `supabase/migrations/202607130001_poc_snapshot.sql`.
- Fondation Auth/multi-tenant :
  `supabase/migrations/202607140001_saas_auth_foundation.sql` avec
  `pinkall_workspaces`, `pinkall_workspace_members`, contraintes, indexes et
  RLS de lecture.
- Bootstrap transactionnel : chaque nouvel `auth.users` reçoit un workspace
  personnel et une membership `owner/default`. Les fonctions
  `SECURITY DEFINER` vivent dans `pinkall_private`, ont un `search_path` vide
  et ne sont exécutables ni par `anon`, ni par `authenticated`.
- L'API vérifie signature, algorithme (`ES256`/`RS256`), issuer, audience,
  expiration, `sub` et rôle du JWT, puis résout la membership durable. Les
  claims `user_metadata` ne participent jamais à l'autorisation.
- Table explicitement qualifiée dans le schéma `public`.
- RLS activée sans politique client, avec privilèges retirés aux rôles
  `anon` et `authenticated`.
- Requêtes Dart en protocole simple, compatibles avec le Shared Session pooler
  Supabase/Supavisor utilisé par le serveur Render persistant.
- En `STRICT_CONFIG=true`, TLS vérifié de bout en bout est obligatoire :
  `sslmode=verify-full` et CA Supabase montée. Les modes `require`, `disable` ou
  l'absence de mode/CA sont refusés.
- Concurrence optimiste par révision : une deuxième instance obsolète échoue
  au lieu d'écraser silencieusement le snapshot.

## Création manuelle du projet

Ces opérations créent une ressource externe et doivent être réalisées par le
propriétaire du compte Supabase :

1. Créer un projet Supabase dans la région **Paris (`eu-west-3`)**. La région
   ne peut pas être changée ensuite sans migration.
2. Générer un mot de passe de base fort et le conserver dans un gestionnaire
   de secrets.
3. Ouvrir **SQL Editor**, exécuter dans l'ordre
   `supabase/migrations/202607130001_poc_snapshot.sql`, puis
   `supabase/migrations/202607140001_saas_auth_foundation.sql`.
4. Dans **Connect**, sélectionner le **Shared Session pooler** compatible IPv4,
   port `5432`, et copier l'URI PostgreSQL. Render garde un processus serveur
   persistant ; Session mode est donc le choix adapté.
5. Si le mot de passe contient des caractères réservés dans une URI, encoder
   uniquement le mot de passe (`@` devient `%40`, `:` devient `%3A`, etc.).
6. Dans **Database Settings → SSL Configuration**, activer **Enforce SSL**.
   Cette modification peut provoquer un bref redémarrage de la base.
7. Télécharger le certificat CA du projet depuis cette même section.
8. Dans **Render service → Environment → Secret Files**, créer
   `supabase-ca.crt` avec le certificat téléchargé. Render le monte dans
   `/etc/secrets/supabase-ca.crt`.
9. Ajouter l'URI à Render sous le nom secret `DATABASE_URL`, avec
   `?sslmode=verify-full`. La variable `DATABASE_SSL_ROOT_CERT`, déjà présente
   dans le Blueprint, pointe vers le fichier monté.

Alternative avec la CLI, après `supabase init` à la racine de `app/` :

```bash
supabase login
supabase link --project-ref <project-ref>
supabase db push
```

Ne jamais committer le project ref lié, le mot de passe ou les fichiers locaux
créés par la CLI.

### Backfill ciblé d'un utilisateur Auth existant

Le trigger ne s'applique qu'aux utilisateurs créés après la migration. Pour un
utilisateur préexistant, récupérer son UUID dans **Authentication → Users**,
puis exécuter une seule fois dans SQL Editor :

```sql
select pinkall_private.pinkall_ensure_personal_workspace(
  '<auth-user-uuid>'::uuid
);
```

La fonction est idempotente et retourne le workspace UUID à placer dans
`PINKALL_SNAPSHOT_WORKSPACE_ID`. Ne pas lancer un backfill global aveugle : la
liaison de chaque snapshot historique à son propriétaire doit d'abord être
confirmée.

## Variables Render nécessaires au stockage

```text
DATABASE_URL=postgresql://postgres.<project-ref>:<mot-de-passe-encode>@<session-pooler>:5432/postgres?sslmode=verify-full
DATABASE_SSL_ROOT_CERT=/etc/secrets/supabase-ca.crt
PINKALL_STORAGE_TENANT_ID=pinkall-poc
PINKALL_SNAPSHOT_WORKSPACE_ID=<uuid-retourné-par-le-bootstrap>
SUPABASE_URL=https://<project-ref>.supabase.co
SUPABASE_JWT_AUDIENCE=authenticated
# Transition seulement : true conserve le bearer POC en parallèle.
PINKALL_ALLOW_POC_BEARER=true
PINKALL_ALLOW_EPHEMERAL_STORE=false
STRICT_CONFIG=true
```

`PINKALL_STORAGE_TENANT_ID` doit rester stable. Le modifier fait démarrer un
nouveau snapshot vide ; cela ne migre pas les données précédentes.

`PINKALL_SNAPSHOT_WORKSPACE_ID` est un UUID relationnel distinct du tenant texte
du snapshot. Il borne l'accès JWT à ce seul snapshot tant que les sessions ne
sont pas normalisées. Après migration des clients, définir
`PINKALL_ALLOW_POC_BEARER=false` et retirer `PINKALL_API_TOKEN`.

Chaque JWT utilisateur est aussi relié à sa ligne active dans `auth.sessions`.
Une session absente, révoquée ou arrivée à `not_after` est refusée avant la
résolution du workspace ; la signature seule ne suffit donc pas après un
sign-out effectif.

Le pool Dart limite par défaut ce POC à trois connexions, utilise un timeout de
connexion de 10 secondes, un timeout de requête de 15 secondes et recycle les
connexions après cinq minutes.

`sslmode=require` n'est pas un compromis accepté en hébergement : il chiffre la
connexion sans valider le certificat ni le nom d'hôte. `verify-full` charge la
CA explicitement et vérifie les deux. Voir la documentation officielle
Supabase : <https://supabase.com/docs/guides/platform/ssl-enforcement>.

## Vérifications après configuration

1. Déployer l'image API préconstruite sur Render avec les secrets ci-dessus.
2. Vérifier que `GET /health` retourne uniquement `status` et `ready`, puis
   contrôler le stockage `postgres_snapshot_poc` via `GET /v1/health`
   authentifié, sans exposer l'URI.
3. Créer un contact de test, redémarrer l'API, puis vérifier que le contact est
   toujours présent.
4. Dans Supabase, vérifier que `public.pinkall_poc_snapshots` contient une
   seule ligne pour `pinkall-poc`, avec une révision croissante.
5. Vérifier qu'un appel REST avec la clé publique `anon` ne peut ni lire ni
   modifier la table.
6. Créer un utilisateur Auth de test et vérifier qu'il possède exactement une
   membership `owner/default`, puis qu'un autre utilisateur ne peut pas lire
   ce workspace via la Data API.
7. Avec son access token, appeler un endpoint métier. Vérifier que la réponse
   expose le `workspace_id` attendu et `auth_mode=supabase_jwt`; un autre
   `X-Pinkall-Workspace-Id` doit être refusé.

## Limites et blocages avant une bêta multi-utilisateur

- `PINKALL_API_TOKEN` reste une compatibilité temporaire uniquement lorsque
  `PINKALL_ALLOW_POC_BEARER=true`. Tous ses détenteurs partagent encore le
  snapshot lié à l'instance.
- Workspaces/memberships sont relationnels et protégés par RLS, mais contacts,
  sessions, transcripts, débriefs et préférences restent dans le snapshot.
- Le snapshot entier est chargé en mémoire puis réécrit après mutation durable.
  Cela convient à une instance et un petit corpus POC, pas à plusieurs équipes.
- Deux instances Render sur le même tenant produiront des conflits de révision ;
  garder une seule instance tant que l'adaptateur relationnel n'existe pas.
- Les événements live, buffers audio et déduplications temps réel restent en
  mémoire. Un redémarrage interrompt proprement l'appel, il ne le reprend pas.
- Export, dry-run/application de rétention et suppression des données métier
  existent dans l'API avec confirmations fortes et rôles. La suppression de
  l'identité Auth, la planification automatique, la sauvegarde restaurée et un
  test de restauration restent à valider avant ouverture publique.

Avant une vraie bêta multi-workspace, il reste à implémenter le store
relationnel des données d'appel, migrer les snapshots et appliquer
`workspace_id` dans chaque requête SQL. La connexion serveur propriétaire
contourne la RLS : l'actuel `AuthPrincipal` ne suffit pas à isoler des lignes
qui n'existent pas encore dans le modèle relationnel.

Références officielles : [JWT Supabase](https://supabase.com/docs/guides/auth/jwts),
[Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security)
et [sécurisation de la Data API](https://supabase.com/docs/guides/api/securing-your-api).
