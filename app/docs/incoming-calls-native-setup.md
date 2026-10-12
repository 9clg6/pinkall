# Appels entrants en arrière-plan — socle natif

## État livré

Pinkall possède maintenant un contrat Flutter testable et deux bridges natifs :

- iOS : PushKit reçoit le push VoIP et CallKit présente l’appel système ;
- Android : FCM reçoit le data push et `ConnectionService` réserve le cycle
  de vie/audio de l’appel ;
- macOS : aucun faux push en arrière-plan. L’application doit rester ouverte et
  connectée à Telnyx.

Les deux bridges mobiles sont **désactivés par défaut**. L’interface distingue
`désactivé`, `configuration requise`, `enregistrement en cours`, `prêt` et
`erreur`. Le token APNS/FCM n’est jamais placé dans l’état UI ou dans les logs ;
quand il existe, il est transmis à la configuration du SDK Telnyx au moment de
la connexion.

Ce socle ne prétend pas encore acheminer l’audio depuis un push : le prochain
lot doit transmettre les métadonnées Telnyx au `handlePushNotification` du SDK,
obtenir un jeton SIP éphémère, puis rattacher l’action native au bon écran
d’appel Flutter.

## Activer iOS sur un appareil physique

1. Créer/configurer l’App ID `com.pinkall.pinkall` dans Apple Developer.
2. Activer **Push Notifications** et **Background Modes > Voice over IP**.
3. Générer un profil de provisioning contenant l’entitlement
   `aps-environment`. Aucun entitlement de production n’est commité dans le
   dépôt.
4. Configurer la clé/certificat APNS VoIP dans l’application push Telnyx.
5. Dans la configuration de build signée, définir
   `INFOPLIST_KEY_PinkallIncomingCallsEnabled=YES` (ou passer la clé
   `PinkallIncomingCallsEnabled` du `Info.plist` à `true`).
6. Installer sur un iPhone physique. Le simulateur reste volontairement en
   `configuration requise`.
7. Vérifier dans Pinkall que l’état passe de `enregistrement en cours` à `prêt`
   après émission du token PushKit.

Le flag ne doit être activé qu’après la configuration APNS **et** Telnyx. Le
bridge refuse d’afficher `prêt` sans entitlement, token, livraison background
et provider CallKit.

## Activer Android

1. Créer l’application Android `com.pinkall.pinkall` dans Firebase.
2. Placer le fichier non versionné
   `android/app/google-services.json`. Le plugin Google Services n’est appliqué
   que lorsque ce fichier existe ; un checkout sans credentials continue donc
   de compiler.
3. Configurer le credential FCM correspondant dans l’application push Telnyx.
4. Passer le meta-data Android
   `com.pinkall.INCOMING_CALLS_ENABLED` à `true` pour le build signé.
5. Installer sur un appareil avec Google Play Services et vérifier l’émission
   du token FCM.

Le bridge enregistre un `PhoneAccount` auto-géré et déclare
`ConnectionService`, mais il conserve volontairement
`native_call_ui_ready=false` : la notification entrante Android avec actions
plein écran n’est pas encore livrée. L’interface affiche donc
`configuration à terminer`, même lorsque FCM fonctionne. Cela évite de
présenter un socle audio comme un téléphone Android fini.

## Contrat des data pushes

Le bridge n’accepte une invitation que si `metadata.call_id` est présent. Les
seuls champs transférés à Flutter sont :

- `call_id` ;
- `caller_name` ;
- `caller_number` ;
- `voice_sdk_id`.

Les payloads complets et tokens ne sont pas envoyés dans l’état de
présentation. Les actions natives sont exposées comme
`incomingCall`, `answerRequested` et `declineRequested` afin que la couche
applicative puisse les rattacher au SDK Telnyx sans dépendre de CallKit ou FCM.

## Validation avant activation publique

- test iPhone verrouillé : push, CallKit, réponse, audio bidirectionnel ;
- test Android verrouillé : data push, notification d’appel, réponse,
  `ConnectionService`, audio bidirectionnel ;
- invalidation/rotation des tokens ;
- appel simultané sur deux appareils et arrêt de la sonnerie secondaire ;
- délai push vers sonnerie p50/p95 ;
- appel manqué, refus, expiration et push tardif ;
- consentement, rétention et masquage des numéros dans la télémétrie.
