# PRD — POC Pinkall avec appels Telnyx réels

**Projet :** Pinkall  
**Niveau BMAD :** 2  
**Statut :** Implémentation séquencée — gate d'appel réel en cours  
**Sprint cible :** 2 puis incréments 3 à 6  
**Dernière mise à jour :** 2026-07-11

## 1. Décision produit

Le POC ne valide pas Pinkall avec un appel ou un historique simulé. Il doit permettre à une personne de fournir une authentification Telnyx à l’exécution, de se connecter au réseau Telnyx et de passer un véritable appel audio WebRTC vers un numéro réel depuis Pinkall.

La preuve recherchée est simple : « je peux utiliser Pinkall comme téléphone de prospection ». Le coaching, la transcription et le débrief ne seront crédibles qu’après cette preuve de téléphonie.

La transcription cible n'est plus couplée au moteur STT de Telnyx. Telnyx transporte l'appel et duplique ses pistes via Media Streaming ; Pinkall choisit ensuite un fournisseur au travers d'un contrat `StreamingTranscriptionAdapter`. Deepgram Flux est l'adaptateur live principal pour ses frontières de tour ; Voxtral reste le fallback live et l'adaptateur batch final, sans dépendance fournisseur dans le domain.

Le coach est une capacité optionnelle et distincte de la transcription. L'utilisateur dispose d'un réglage par défaut et peut le surcharger avant chaque appel. Lorsqu'il est désactivé, aucun modèle de coaching ne reçoit le transcript et aucun coût de coaching n'est engagé.

## 1.1 Ordre de construction contraignant

Les incréments sont réalisés dans cet ordre, sans déclarer une étape terminée sur la base de données simulées :

1. terminer STORY-007 avec de vraies clés, de vrais appareils et des appels Telnyx réels ;
2. construire le backend SaaS, l'identité Pinkall, les JWT Telnyx courts et la corrélation d'appel ;
3. qualifier le contact dans le CRM et bloquer un appel non éligible selon la politique applicable ;
4. connecter Telnyx Media Streaming à `StreamingTranscriptionAdapter`, avec Deepgram Flux en live et Voxtral en fallback/batch ;
5. produire un transcript final batch et le réconcilier avec les segments live ;
6. générer le résumé, les engagements et le follow-up à partir du transcript final puis les rattacher au CRM ;
7. créer et valider les cartes de coaching sourcées ;
8. exécuter le coach en mode `shadow`, sans suggestion visible, afin de mesurer précision et latence ;
9. activer le mode `live` derrière le switch utilisateur et des seuils de haute précision ;
10. mesurer la chaîne `exposition → action → résultat`, sans confondre corrélation et causalité.

## 2. Problème à valider

Les fondateurs et commerciaux qui prospectent perdent de l’information parce qu’ils doivent écouter, argumenter et prendre des notes en même temps. Pinkall vise ensuite à transcrire, synthétiser et coacher ces appels. Avant d’évaluer cette promesse complète, le POC doit prouver que l’appel réel peut être initié et contrôlé dans l’application sur iOS, Android et macOS.

## 3. Utilisateur cible du POC

- Fondateur ou commercial B2B qui effectue lui-même des appels sortants.
- Testeur interne disposant d’un compte Telnyx, d’une Credential Connection, d’un Outbound Voice Profile et d’un numéro autorisé.
- Testeur capable de fournir au runtime un JWT Telnyx ou, uniquement pour le développement, des identifiants SIP.

## 4. Résultat mesurable

Le POC est validé lorsqu’un testeur peut, sans donnée simulée :

1. accorder l’accès au microphone ;
2. fournir une authentification Telnyx au runtime ;
3. voir l’état de connexion réel du client Telnyx ;
4. appeler un numéro E.164 réel ;
5. établir un audio bidirectionnel ;
6. couper/rétablir le micro et raccrocher ;
7. voir les états et erreurs réellement émis par le SDK ;
8. reproduire ce parcours sur iOS, Android et macOS selon les critères de compatibilité définis dans l’architecture.

## 5. Périmètre MoSCoW

### Must Have — Sprint 2

- Intégration directe du package `telnyx_webrtc` derrière la couche data définie par `ARCHITECTURE.md`.
- Authentification Telnyx fournie au runtime : JWT privilégié, SIP utilisateur/mot de passe accepté en mode développement explicite.
- Connexion et déconnexion réelles au client Telnyx.
- Appel sortant réel vers un numéro E.164.
- États d’appel issus du SDK : connexion, prêt, appel en cours de création, sonnerie, actif, terminé, erreur.
- Audio bidirectionnel réel avec permission microphone.
- Contrôles minimum : mute/unmute et fin d’appel ; haut-parleur seulement lorsqu’il est supporté par la plateforme.
- Messages d’erreur actionnables pour authentification, permission, réseau et appel.
- Aucune session, transcription, synthèse ou recommandation simulée dans le runtime.
- Comportement honnête après l’appel : si aucun backend de transcription n’est configuré, l’interface indique que la transcription n’est pas disponible au lieu d’en fabriquer une.
- Validation iOS, Android et macOS ; macOS reste soumis au gate de compatibilité explicité dans le document d’architecture.

### Should Have

- Indicateur de qualité ou de reconnexion lorsqu’une métrique fiable est fournie par Telnyx.
- Conservation en mémoire vive du dernier numéro pendant la session, sans secret persistant.
- Appel entrant lorsque l’application est active au premier plan.

### Could Have

- Sélection du périphérique audio lorsque le SDK et la plateforme l’exposent proprement.
- DTMF.
- Mise en attente.

### Won't Have — Sprint 2

- Appels ou débriefs de démonstration simulés.
- Push VoIP, APNS/PushKit, FCM, CallKit ou expérience d’appel en arrière-plan.
- Persistance d’un historique d’appels.
- Enregistrement ou transcription locale.
- Transcription affichée sans événement Telnyx réel.
- Coaching IA, score commercial, résumé, follow-up ou synchronisation CRM.
- Clé API Telnyx embarquée dans l’application.

## 6. Exigences fonctionnelles

| ID | Priorité | Exigence vérifiable |
|---|---|---|
| FR-T01 | Must | L’utilisateur peut choisir une authentification JWT ou SIP au runtime. |
| FR-T02 | Must | Les champs sensibles sont masqués et ne sont ni préremplis, ni écrits dans les sources, ni persistés. |
| FR-T03 | Must | L’application transmet la configuration runtime au client `telnyx_webrtc` et reflète son véritable état de connexion. |
| FR-T04 | Must | L’utilisateur ne peut initier un appel que lorsque le client est prêt. |
| FR-T05 | Must | La destination est validée au format E.164 avant l’envoi de l’invitation. |
| FR-T06 | Must | L’application crée une invitation Telnyx réelle et conserve l’identifiant réel de l’appel. |
| FR-T07 | Must | L’écran d’appel reflète les événements réels du cycle de vie Telnyx. |
| FR-T08 | Must | L’utilisateur peut couper et réactiver son microphone durant l’appel. |
| FR-T09 | Must | L’utilisateur peut terminer l’appel ; un second appel à la commande de fin reste sans effet indésirable. |
| FR-T10 | Must | Un refus de permission microphone empêche l’appel audio et affiche une action de correction. |
| FR-T11 | Must | Une perte de connexion ou une authentification rejetée produit un état d’erreur explicite et récupérable. |
| FR-T12 | Must | Aucune donnée du POC local simulé ne peut alimenter les écrans du parcours Telnyx. |
| FR-T13 | Must | Sans flux de transcription réel, aucun texte présenté comme propos du prospect ou de l’appelant n’est affiché. |
| FR-T14 | Must | L’utilisateur voit avant l’appel que la fonction utilise son microphone et un service de téléphonie tiers. |
| FR-T15 | Should | L'application peut recevoir une invitation réelle au premier plan et permettre de l'accepter ou la refuser. |
| FR-T16 | Should | L'application expose une action de déconnexion qui détruit la session Telnyx et efface les secrets de la mémoire applicative. |
| FR-T17 | Must — incrément suivant | Le backend corrèle chaque appel Telnyx à un `callSessionId` Pinkall et peut démarrer/arrêter Media Streaming sans exposer la clé Telnyx au client. |
| FR-T18 | Must — incrément suivant | Le backend remet chaque piste audio à un contrat `StreamingTranscriptionAdapter` indépendant du fournisseur ; Deepgram Flux est l'adaptateur live principal et Voxtral le fallback. |
| FR-T19 | Must — incrément suivant | Les segments live distinguent vendeur et prospect uniquement à partir d'une piste Telnyx vérifiable ; sinon le locuteur reste `unknown`. |
| FR-T20 | Must — incrément suivant | Après l'appel, un adaptateur batch produit un transcript final horodaté, versionné et réconcilié avec le transcript live. |
| FR-T21 | Must — incrément suivant | Le CRM permet de saisir/importer la source du numéro, le type B2B/B2C, la base d'éligibilité, la preuve de consentement éventuelle et une opposition à rappeler. |
| FR-T22 | Must — incrément suivant | Avant composition, Pinkall bloque tout contact classé inéligible et demande de qualifier un contact dont l'éligibilité est inconnue. |
| FR-T23 | Must — incrément suivant | Le coach dispose d'un réglage utilisateur par défaut `off` ou `on`, surchargé par appel avant connexion. |
| FR-T24 | Must — incrément suivant | Le runtime interne distingue `off`, `shadow` et `live`; seul `live` peut exposer une suggestion et `off` interdit tout traitement par le moteur de coaching. |
| FR-T25 | Must — incrément suivant | Une suggestion live n'est exposée que si elle est courte, contextualisée, sourcée, non expirée et au-dessus des seuils de confiance et d'actionnabilité. |
| FR-T26 | Must — incrément suivant | Pinkall journalise séparément génération, éligibilité, exposition, action déclarée et résultat CRM afin d'évaluer le coaching sans inventer de causalité. |

## 7. Exigences non fonctionnelles

| ID | Catégorie | Exigence vérifiable |
|---|---|---|
| NFR-T01 | Sécurité | Aucun API key Telnyx, JWT, utilisateur SIP ou mot de passe SIP ne figure dans Git, les assets, les logs ou les crash reports. |
| NFR-T02 | Sécurité | Les secrets runtime vivent uniquement en mémoire et sont éliminés lors de la déconnexion ou de la fermeture du processus. |
| NFR-T03 | Confidentialité | Aucun enregistrement ni transcription ne démarre sans information explicite de l’utilisateur et processus de consentement adapté aux personnes appelées. |
| NFR-T04 | Exactitude | Les états affichés proviennent d’événements Telnyx ; aucun timer ou succès artificiel ne remplace un événement réseau. |
| NFR-T05 | Performance | Une action utilisateur met à jour l’état local immédiatement, puis confirme ou corrige cet état avec l’événement SDK. |
| NFR-T06 | Résilience | Les événements tardifs reçus après la fin d’un appel ne réactivent pas la session terminée. |
| NFR-T07 | Maintenabilité | Le SDK Telnyx reste confiné à `core_data`; le domain et la présentation ne dépendent pas de ses types. |
| NFR-T08 | Testabilité | Les doubles de test sont autorisés uniquement dans les tests automatisés, jamais dans le graphe de providers runtime. |
| NFR-T09 | Accessibilité | Les états critiques sont textuels et ne dépendent pas uniquement de la couleur ou d’une animation. |
| NFR-T10 | Observabilité | Les logs techniques sont corrélables par identifiants non secrets et expurgés de numéros complets, tokens et contenu audio. |
| NFR-T11 | Remplaçabilité | Le domain ne connaît ni Mistral, ni Voxtral, ni un autre fournisseur STT ; changer d'adaptateur ne modifie pas les contrats produit. |
| NFR-T12 | Latence | Chaque segment live conserve les horodatages d'ingestion, de finalisation STT et d'exposition coach afin de mesurer p50/p95 bout en bout sur de vrais appels. |
| NFR-T13 | Exactitude | Un segment partiel n'écrase jamais un segment final ; le transcript batch est une nouvelle révision auditable, pas une mutation silencieuse. |
| NFR-T14 | Fiabilité du coach | L'absence de recommandation est le comportement attendu lorsque la confiance, les sources ou le temps restant sont insuffisants. |
| NFR-T15 | Confidentialité | Le mode coach `off` ne transmet aucun transcript au fournisseur de coaching ; le traitement STT et sa rétention restent gouvernés séparément. |
| NFR-T16 | Conformité | Les règles d'éligibilité sont datées, versionnées, explicables à l'utilisateur et configurables par juridiction ; Pinkall ne présente pas ce moteur comme un avis juridique. |

## 8. Parcours principal

1. Pinkall explique l’usage du microphone et demande la permission native.
2. Le testeur choisit JWT ou SIP et saisit ses informations Telnyx.
3. Pinkall se connecte et attend l’état « prêt » réellement émis par Telnyx.
4. Le testeur saisit un numéro E.164 autorisé puis lance l’appel.
5. Pinkall affiche les changements d’état et active les contrôles au moment approprié.
6. Le testeur échange de l’audio avec le correspondant, utilise mute/unmute puis raccroche.
7. Pinkall clôt la session d’appel réelle. Tant que le backend de transcription n’existe pas, aucun faux débrief n’est présenté.

## 9. Transcription fournisseur-agnostique

Le SDK WebRTC transporte l'appel, mais il ne constitue pas le backend sécurisé requis pour traiter le média. La chaîne cible est :

```text
App WebRTC → Telnyx → Media Streaming (pistes vérifiables)
                        → AudioGateway Pinkall
                          → StreamingTranscriptionAdapter
                            → Deepgram Flux (principal) / Voxtral (fallback)
                              → segments live versionnés

Enregistrement contrôlé → BatchTranscriptionAdapter
                           → Voxtral Mini Transcribe 2 (premier adaptateur)
                             → transcript final réconcilié
```

Obligations produit :

- Telnyx reste le fournisseur de téléphonie et de média, pas la source normative du texte ;
- la clé Telnyx et la clé du fournisseur STT restent exclusivement côté backend ;
- `StreamingTranscriptionAdapter` accepte un flux audio normalisé et émet des deltas/segments finaux sans type Mistral dans le domain ;
- Pinkall utilise exclusivement les pistes Telnyx pour attribuer les locuteurs, quel que soit l'adaptateur STT ; sans preuve de piste, la valeur reste `unknown` ;
- le transcript live est utile pour l'interface et le coach, mais le transcript batch devient la révision finale utilisée pour le débrief et le CRM ;
- toutes les versions conservent modèle, fournisseur, langue, horodatages et niveau de confiance lorsque celui-ci existe ;
- une rupture STT ne doit jamais interrompre l'appel ; elle désactive proprement le transcript et le coach ;
- jusqu'à la livraison de ce backend, Pinkall affiche « transcription non configurée » ou masque cette section.

Références officielles :

- [SDK Flutter Telnyx](https://developers.telnyx.com/docs/voice/webrtc/flutter-sdk)
- [Telnyx Media Streaming](https://developers.telnyx.com/docs/voice/programmable-voice/media-streaming)
- [Deepgram Flux](https://developers.deepgram.com/docs/flux/quickstart)
- [Machine d'états Flux](https://developers.deepgram.com/docs/flux/state)
- [Voxtral Realtime](https://docs.mistral.ai/studio-api/audio/speech_to_text/realtime_transcription)
- [Voxtral, transcription live et batch](https://docs.mistral.ai/studio-api/audio/speech_to_text)

## 10. Consentement et conformité

- L'application informe clairement le testeur que le microphone et Telnyx sont utilisés.
- L'enregistrement et la transcription restent désactivés dans ce sprint.
- Avant toute phase de transcription, le produit doit définir comment l'autre participant est informé et comment son consentement est obtenu selon les juridictions ciblées.
- Une décision produit et juridique doit définir la durée de conservation, le droit de suppression et les rôles de responsable/sous-traitant avant de stocker du contenu d'appel.
- Le POC n'affirme pas qu'un mécanisme de consentement unique couvre toutes les juridictions.
- Pour la France à compter du 11 août 2026, un contact B2C est bloqué par défaut en l'absence de consentement préalable démontrable, sauf exception documentée telle qu'un appel relatif à un contrat en cours.
- Un contact B2B peut relever d'un régime d'information et d'opposition : Pinkall exige que l'utilisateur confirme le caractère professionnel et pertinent de la sollicitation, conserve la source du numéro et respecte immédiatement toute opposition.
- Un contact `unknown` n'est jamais automatiquement requalifié B2B à partir d'un numéro, d'un nom de domaine ou d'une inférence IA.
- Le CRM conserve la version de règle ayant autorisé ou bloqué l'appel et offre une liste `do_not_call` prioritaire sur toute autre donnée.
- Pinkall fournit des garde-fous et une trace ; la responsabilité de la base légale et du contenu de l'appel reste soumise à validation juridique pour le marché ciblé.

Référence officielle : [CNIL — prospection commerciale par téléphone](https://www.cnil.fr/fr/prospection-commerciale-par-telephone-hors-automate-dappel-quelles-sont-les-regles)

## 11. Dépendances et prérequis externes

- Compte Telnyx actif et crédité.
- Credential Connection configurée.
- Outbound Voice Profile assigné.
- Numéro/caller ID Telnyx autorisé et destination de test légitime.
- JWT runtime valide, ou identifiants SIP dédiés au développement.
- Appareils physiques pour valider l’audio mobile.
- Autorisations microphone iOS, Android et macOS.

## 12. Risques et gates

| Risque | Réponse |
|---|---|
| Le package officiel `telnyx_webrtc` annonce Android, iOS et Web, mais pas macOS | Un spike de compilation et d’appel audio macOS est un gate. Aucun succès macOS ne sera déclaré sans appel réel. Si le gate échoue, la story est bloquée et une décision d’architecture explicite est requise. |
| Des identifiants de développement finissent dans le dépôt | Saisie runtime, revue de secrets et absence de valeurs par défaut. |
| L’interface affiche un appel réussi avant la réponse réseau | État piloté par le stream d’événements Telnyx. |
| La transcription est supposée disponible directement dans Flutter | Frontière backend documentée ; aucune transcription simulée. |
| La topologie WebRTC actuelle ne fournit pas encore de Media Streaming corrélable | Spike réel obligatoire avec Voice API/call control ; STORY-010 ne passe pas sans `call_session_id`, deux pistes démontrées et audio reçu par le backend. |
| Deepgram ou Voxtral est traité comme une dépendance permanente | Contrats fournisseur-agnostiques et tests de conformité d'adaptateur ; Flux, Voxtral live et Voxtral batch restent remplaçables. |
| Le coach affiche des conseils génériques ou distrayants | Mode `shadow` avant `live`, une suggestion active au maximum, expiration, seuils élevés et comportement par défaut « ne rien afficher ». |
| Un contact B2C est appelé sans preuve de consentement après le 11 août 2026 | Gate CRM bloquant, preuve horodatée ou exception documentée ; statut inconnu = appel bloqué. |
| Un test appelle un vrai prospect par erreur | Numéros de test allowlistés et confirmation avant composition pendant le POC. |

## 13. Critère de sortie du POC

Le POC est terminé seulement si des preuves de test montrent un appel réel et un audio bidirectionnel sur les plateformes acceptées. Une animation d’appel, une minuterie locale ou un enregistrement de démonstration ne constituent pas une preuve.
