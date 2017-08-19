

# Cahier des Clauses Particulières

[Le Cahier des clauses particulières (CCP) est un document qui regroupe les clauses administratives et techniques spécifiques à un marché. La rédaction de ce document utilise le format ISO]

# 1. Présentation générale du problème

## 1.1 Projet

Le projet des « Guides de Paris (les historiens des arts et les corpus numériques) » consiste à produire une édition critique électronique d’un corpus de guides de Paris du XVIIe et XVIIIe siècle. La publication s’appuie sur un encodage des textes en XML-TEI et une indexation qui utilise les standards du web sémantique d’après les principes du linked open data.

Au-delà de l’apport du projet à la connaissance de l’émergence d’une conscience patrimoniale et à une réflexion sur les apports de l’édition numérique à l’histoire de l’art, il s’agit d’offrir aux chercheurs des points d’accès multipliés qui facilitent le maniement de ces sources incontournables pour l’histoire de l’art moderne en France (accès chronologiques, topographiques, toponymiques, patronymiques, etc.).

http://www.passes-present.eu/fr/node/363

Les sources du projet font l’objet d’une édition structurée et sont publiées par l’intermédiaire d’une application REST qui utilise une base de données XML native. L’objet de cet appel d’offre concerne la réalisation d’une interface de consultation de ces sources historiques à destination des chercheurs et d’un public d’amateur.

### 1.1.1 Finalités

Au terme du contrat, il s’agira de disposer d’une interface publique enrichie qui facilite le travail scientifique sur le corpus des Guides de Paris. Plusieurs priorités ont été identifiées pour la réalisation du projet :

- le confort de lecture et de travail (ergonomie)
- la mise en œuvre d’interrogations pertinentes dans corpus (recherches, rebonds, visualisations diverses)
- les fonctionnalités d’indexation collaborative (collaboratif)

### 1.1.2 Espérance de retour sur investissement

La réalisation de l’interface de consultation est destinée à faciliter le travail des chercheurs sur le corpus et à intéresser un public d’amateur. Celle-ci est destinée à valoriser l’important effort de structuration des sources déjà effectué et dont la publication a été réalisée en interne afin de dégager un budget confortable pour la production d’une interface de consultation innovante aux riches fonctionnalités. L’application web constituant la principale concrétisation publique du projet, le design de l’interface et des interactions graphiques doivent être particulièrement soignées. Celle-ci doit également être pérenne et accessible afin de permettre l’accueil du travail des chercheurs dans les meilleures conditions.

## 1.2 Contexte

### 1.2.1 Situation du projet par rapport aux autres projets du Labex

Le projet des Guides de Paris est conduit dans le cadre du labex Les passés dans le présent sous la direction de Marianne Cojannot-Le Blanc au sein de l’équipe d’accueil HAR en collaboration avec le laboratoire Modyco, la Bibliothèque nationale de France.

#### Le Labex les Passés dans le présent : histoire, patrimoine, mémoire

Le laboratoire d’excellence (labex) Les passés dans le présent : histoire, patrimoine, mémoire (http://www.passes-present.eu/) porte sur la présence du passé dans la société contemporaine. Il s’attache plus spécifiquement à comprendre les médiations de l’histoire à l’ère du numérique, les politiques de la mémoire, les appropriations sociales du passé en amont et en aval des politiques patrimoniales. La réflexion commune et interdisciplinaire est organisée en deux thèmes interdépendants.

Le premier, « Relations au passé : représentations et évaluations », se propose de conduire une analyse globale des représentations du passé à toutes les époques. Le second, « Connaissance active du passé : pratiques et outils de transmission », vise à mettre à disposition de plusieurs catégories de publics de nouveaux corpus numériques, qui portent sur des pans d’histoire antique, médiévale, de la période classique, du début du XXe siècle ou du temps présent.

Inscrit dans une réflexion sur les humanités numériques, le labex Les passés dans le présent entend travailler sur l’interopérabilité des ces corpus entre partenaires mais aussi avec d’autres bases de données, afin de mieux les inscrire dans l’écosystème du Web de données (données liées). Cela implique un travail de modélisation des catalogues et inventaires, s’appuyant sur les standards internationaux de représentation des données et d’enrichissement des métadonnées d’indexation.

Enfin, le labex Les passés dans le présent développe un réseau dynamique de formations, ordonnées autour des métiers du patrimoine, de la culture et du texte, de l’histoire et de la sociologie de la mémoire, de l’histoire de l’art.

Depuis un peu plus de quatre ans, le programme scientifique du labex mobilise la richesse et la pluralité des sciences humaines et sociales autour de ces questions de recherches qui font l’objet d’études au long cours, d’enquêtes d’ampleur, de croisements inédits entre disciplines, et d’investigations d’un nouveau genre à l’ère du numérique. Celles-ci conduisent à de nouvelles méthodes et de nouveaux dispositifs de recherche.

#### Partenaires au sein du labex

##### L’équipe d’accueil HAR Histoire des arts et des représentations (EA4414)

Ce projet est porté par l’[équipe d’accueil HAR, Histoire des arts et des représentations (EA 4414)](https://har.u-paris10.fr), un laboratoire de recherche interdisciplinaire qui opère sur l’ensemble de l’histoire de l’art et de l’histoire des figurations, performances et représentations du XVe siècle à nos jours, et sur l’étude et l’emploi de l’image filmique dans la perspective de l’histoire et des sciences humaines. HAR est une unité qui rassemble, au sein de l’Université Paris Nanterre, 40 enseignants chercheurs titulaires et plus de 200 doctorants. Plusieurs projets de recherche collaboratifs sont portés au sein de l’Équipe d’accueil en partenariat avec le [labex Les passés dans le présent](http://passes-present.eu) et le [labex Arts-H2H](http://www.labex-arts-h2h.fr). Notamment, un [projet sur les registres de la Comédie française](http://cfregisters.org/fr/) conduit en collaboration avec le MIT, ainsi qu’un projet intitulé [Images dialectiques, musées imaginaires, musées virtuels](http://passes-present.eu/fr/node/4415).

##### Le laboratoire MoDyCo Modèles, Dynamiques, Corpus (UMR 7114)

L’[Unité mixte de recherche MoDyCo, Modèles, Dynamiques, Corpus (UMR 7114)](http://www.modyco.fr/fr/) s’inscrit dans la continuité thématique et méthodologique de la recherche linguistique menée à l’Université Paris Nanterre. Le laboratoire a trois perspectives de recherche prioritaires : La modélisation qui concerne les recherches phonologiques, morphologiques, syntaxiques et sémantiques, ainsi que les travaux de formalisation en traitement automatique des langues. La dynamique qui renvoie aux recherches menées en acquisition (développement et pathologie ; langue maternelle ou langue seconde), en sociolinguistique et en didactique. Les corpus, que ce soit dans la recherche en linguistique textuelle, diachronique ou discursive, en linguistique de l’écrit, en linguistique de l’oral, les corpus traversent, en tant que méthodologie d’appui, toutes les recherches du laboratoire.

##### La Bibliothèque nationale de France (BnF)

Le projet est conduit en partenariat avec la section d’histoire du département département Philosophie, histoire, sciences de l’homme de la [Bibliothèque nationale de France (Bnf)](http://www.bnf.fr) qui met en particulier à disposition la numérisation des ouvrages imprimés à partir de ses riches collections.

### 1.2.2 Études déjà effectuées

#### Structuration des données

La structuration des données du projet a déjà fait l’objet d’une modélisation en XML-TEI. La [Text Encoding Initiative (TEI)](http://www.tei-c.org/) offre un cadre de travail pour l’édition structurée de textes littéraires ou historiques. Tout à la fois modèle conceptuel, infrastructure technique, et communauté, la TEI s’est largement imposée, au niveau international, comme standard de fait pour la production d’éditions critiques numériques.

Dans le cadre de l’édition des Guides de Paris, les sources ont fait l’objet d’une modélisation et d’une documentation exprimée au moyen du langage ODD qui permet de déclarer de manière formelle son utilisation de la TEI. Plusieurs fichiers sont dérivés de ce modèle tels que des schémas RelaxNG pour la production des fichiers TEI et une documentation au format HTML ou pdf.

Ce modèle peut être consulté à l’adresse http://guidesdeparis.net/documentation

#### Modèle sémantique du Labex

Le labex Les passés dans le présent a mis sur pied un groupe de travail sur la modélisation et les référentiels destiné à travailler sur la définition d’un modèle de données commun à l’échelle du labex en vue du partage et de l’exposition des données produites à l’échelle du labex à travers un SPARQL end point. Une preuve de concept a été mise en œuvre dans le cadre de la rétro conversion de grands jeux de données. Le modèle de données repose pour l’essentiel sur une utilisation de l’ontologie de l’Organisation internationale des musée, CIDOC-CRM.

Tchienehom Pascaline, « ModRef Project: from Creation to Exploitation of CIDOC-CRM Triplestores», *The Fifth International Conference on Building and Exploring Web Based Environments (WEB 2017)*,  Barcelona, Spain 2017. http://inforsid.fr/actes/2017/INFORSID_2017_paper_33.pdf

Tchienehom Pascaline, « Humanités Numériques et Web Sémantique : du langage naturel à une représentation computationnelle structurée et sémantique des données », *Digital Humanities - Alliance of Digital Humanities Organizations (ADHO)*, 2017, Montréal, Canada. https://dh2017.adho.org/abstracts/187/187.pdf

#### Mise en œuvre d’une application de publication des sources

Les premiers textes édités en XML-TEI en utilisant la modélisation ci-dessus ont fait l’objet d’une première publication à travers une application web conçue avec la base de données XML native [BaseX](http://basex.org) et du cadre léger de publication de corpus XML [SynopsX](http://synopsx.github.io). Il s’agit d’une application REST conforme aux standards du web sémantique qui définit un scheme d’URI pour les différentes ressources du projet qui disposent toutes d’une représentation  HTML. Cette application est entièrement personnalisable par nos soins pour les besoins du projet selon des modalités à convenir avec le prestataire. **C’est à partir de cette première publication que doit être conçue l’interface de publication finale qui fait l’objet du présent appel d’offre. Il n’est pas attendu de compétence particulière du prestataire dans le domaine des technologies XML.**

#### Mémoire de fin d’étude sur l’annotation collaborative du corpus

Dans le cadre d’un stage sur le projet en 2014, Johanna Daniel a publié un mémoire de fin d’étude du Master de l’École nationale des chartes « Technologies numériques appliquées à l’histoire » concernant l’évaluation de plusieurs solutions logicielles pour l’annotation collaborative du corpus.

Johanna Daniel. *Les outils d’annotation et l’édition scientifique de corpus textuels pour la recherche.*
*L’exemple du projet « Guides de Paris (les historiens des arts et les corpus numériques) »*, Mémoire de stage, M2 professionnalisant « Technologies numériques appliquées à l’Histoire » de l’École des Chartes, septembre 2014. http://johannadaniel.fr/isidoreganesh/memoire/

### 1.2.3 Études menées sur des sujets voisins

néant

### 1.2.4 Suites prévues

Aucune phase ultérieure est actuellement prévue pour le projet.

### 1.2.5 Nature des prestations demandées

- Design d’interface
- Intégration web (CSS, JavaScript)
- Implémentation avec BaseX (si on joint le lot)

### 1.2.6 Parties concernées par le déroulement du projet et ses résultats (demandeurs, utilisateurs)

#### Direction scientifique du projet : Marianne Cojannot-Le Blanc,

Marianne Cojannot-Le Blanc est professeure d’histoire de l’art à l’Université Paris X-Nanterre et directrice de l’UFR Sciences sociales, elle est spécialiste de la période moderne et plus particulièrement du XVIIe siècle. Le projet des Guides de Paris, les historiens de l’art et les corpus numérique découle directement de sa fréquentation des sources dans le cadre de ses recherches.

mleblanc@u-paris10.fr

#### Conception numérique : Emmanuel Château-Dutier

Emmanuel Château-Dutier est professeur adjoint en muséologie numérique à l’Université de Montréal. Historien de l’architecture et digital humanist, ses recherches portent sur l’administration de l’architecture publique en France au XIXe siècle. Ses travaux concernent par ailleurs la muséologie et l’histoire de l’art numérique. Il a notamment assuré la direction numérique de l’édition critique des Cours d’Antoine Desgodets (ANR Desgodets) puis a occupé les fonctions d’ingénieur d’étude pour le projet des Guides de Paris dans sa phase initiale.

emmanuel.chateau.dutier@umontreal.ca

skype: emchateau

#### Suivi de réalisation : Josselin Morvan

Josselin Morvan est ingénieur d’étude au Labex les passés dans le présent pour le projet des Guides de Paris. Formé aux technologies numériques appliquées à l’histoire à l’École nationale des chartes, il est historien de l’art et spécialiste de la Text Encoding Initiative. Outre l’encodage des sources XML, il a largement participé à la conception technique du projet et la rédaction du cahier des charges. C’est lui qui assurera le suivi de réalisation du projet.

morvan.josselin@gmail.com

#### Utilisateurs

Plusieurs utilisateurs test peuvent être mobilisés au sein de l’équipe de recherche pour les besoins de la réalisation du projet.

#### Administration du labex Les passés dans le présent

##### Coordination du labex : Ghislaine Glasson Deschaumes

Ghislaine Glasson Deschaumes coordonne le labex Les passés dans le présent en tant que chef de projet.

ghislaine.glasson-deschaumes@u-paris10.fr

#####   Chargée de communication : Hélène de Foucaud

hdefouca@u-paris10.fr

##### Chargé d’appui aux projets scientifiques : Quentin Roblin

quentin.roblin@u-paris10.fr

##### Coordonnées du Labex

Université Paris Nanterre
Maison Max Weber (bureau 108)
200, avenue de la République
92001 Nanterre Cedex
tél : +33 (0)1 40 97 41 83
mob : +33 (0)7 63 30 31 91

www.passes-present.eu

### 1.2.7 Caractère confidentiel s’il y a lieu

Si le projet ne présente pas de caractère de confidentialité particulier, toute communication publique concernant le projet devra être effectuée en accord avec le client.

## 1.3 Énoncé du besoin (finalités du produit pour le futur utilisateur tel que prévu par le demandeur)

## 1.4 Environnement du produit recherché

### 1.4.1 Listes exhaustives des éléments (personnes, équipements, matières…) et contraintes (environnement)

- BaseX + SynopsX
- Navigateurs cibles
- Accessibilité (conformité ARIA, choix de police, raccourcis clavier, etc.)
- Référentiel d’accessibilité

### 1.4.2 Caractéristiques pour chaque élément de l’environnement



# 2. Expression fonctionnelle du besoin

## 2.1 Fonctions de service et de contrainte

### 2.1.1 Fonctions de service principales (qui sont la raison d’être du produit)

### 2.1.2 Fonctions de service complémentaires (qui améliorent, facilitent ou complètent le service rendu)

### 2.1.3 Contraintes (limitations à la liberté du concepteur-réalisateur)

## 2.2 Critères d’appréciation (en soulignant ceux qui sont déterminants pour l’évaluation des réponses)

## 2.3 Niveaux des critères d’appréciation et ce qui les caractérise

### 2.3.1 Niveaux dont l’obtention est imposée

### 2.3.2 Niveaux souhaités mais révisables

# 3. Cadre de réponse

## 3.1 Pour chaque fonction

### 3.1.1 Solution proposée

### 3.1.2 Niveau atteint pour chaque critère d’appréciation de cette fonction et modalités de contrôle

### 3.1.3 Part du prix attribué à chaque fonction

## 3.2 Pour l’ensemble du produit

### 3.2.1 Prix de la réalisation de la version de base

### 3.2.2 Options et variantes proposées non retenues au cahier des charges

### 3.2.3 Mesures prises pour respecter les contraintes et leurs conséquences économiques

### 3.2.4 Outils d’installation, de maintenance … à prévoir

### 3.2.5 Décomposition en modules, sous-ensembles

### 3.2.6 Prévisions de fiabilité

### 3.2.7 Perspectives d’évolution technologique



### Navigation

La navigation du site privilégie la simplicité, elle met en avant la consultation du corpus et comporte des liens vers la présentation générale du projet.

- Consulter

- Index(s)

- Accès cartographique

- Bibliographie

- blog du projet

  ​

- à propos (pied de page ?)

- CGU, etc.

### Consultation du corpus

Le corpus des Guides de Paris se compose de plusieurs corpus d’auteurs qui comportent chacun plusieurs éditions. L’interface du site des Guides de Paris est destinée à donner à lire les textes mais aussi à proposer des accès synoptiques sur le corpus. Il est possible de consulter directement une édition particulière sans devoir passer par la recherche. Depuis, une édition donnée, on peut également aisément accéder aux autres éditions ainsi qu’au contenus en rapport dans les autres corpus.

L’interface de consultation, sobre et distinguée, met l’accent sur la lisibilité et le confort de lecture du texte. À cette fin, un soin particulier est accordé au traitement typographique qui doit offrir une belle régularité. Plusieurs rendus typographiques sont à prévoir pour distinguer les différents niveaux de notes, les contenus cliquables et diverses interactions sur le texte.

Une liste de corpus donne en premier lieu accès à la consultation des Guides. Celle-ci donne accès aux corpus d’auteurs et aux éditions en particulier. Cette interface permet aussi de définir le périmètre d’une recherche simple ou avancée par l’intermédiaire de filtres sur le corpus.

Les textes proprement dits peuvent être consultés de diverses manières : 

- ceux-ci peuvent être lus de manière linéaire du début à la fin
- mais on peut également consulter le corpus de façon transversale, à partir d’une liste de résultats sur un monument, un artiste, etc.

#### Présentation du corpus

Le corpus fait l’objet de plusieurs présentations alternatives. On peut  :

- Lister les corpus par auteurs et par dates des corpus d’auteur
- Lister les textes par dates d’édition

Il pourrait être intéressant de pouvoir utiliser la même présentation pour les listes de résultats @quest

@quest mettre en avant la recherche par objets, ne pas exclure que des personnes moins habituées puissent faire directement des recherche sur des objets. Voire dans quelle mesure il n’est pas possible de rendre dès la première page les deux types d’usage. Croiser un usage savant centré sur les textes, et un usage pour les curieux.

@quest désigner autrement les index, penser au public étudiant qui cherche des informations sur un édifice. Sébastien Bontemps, indexation d’un ensemble topographique Marot, Pérelle, Silvestre. Juliette Jestaz lui a également écrit, elle est très intéressée par le projet pour la BHVP.

##### Liste des corpus par auteurs

Les corpus sont listés par auteurs avec une indication du nombre de textes disponibles pour chaque auteur. Pour chaque corpus d’auteur, un menu accordéon permet de visualiser la liste des textes.

Cette liste de corpus d’auteurs peut être triée par date ou par ordre alphabétique d’auteur.

##### Lister les textes par dates d’édition

La liste des textes peut être affichée par date d’édition afin de visualiser les phénomènes éditoriaux.

Propose-t-on des facettes dans la présentation des corpus

- auteur

- nombre d’édition

  ​


- dates d’édition
- éditeurs
- lieu d’édition
- pagination / étendue ?? 
- par occurrences

@quest La présentation de la bibliographie doit-elle être séparée ou bien utilise-t-elle la même interface ?

@todo proposer le tri par occurrences dans la liste des résultats

#### Consultation linéaire du texte

Chacun des textes est consultable en lecture linéaire, du début à la fin de l’ouvrage. Cette lecture linéaire comporte les éléments suivants :

- une page de titre de l’édition critique
- une page de titre de l’édition originale
- une présentation linéaire qui utilise un défilement infini.
- lors de l’affichage du texte depuis une liste de résultat proposer les résultats suivants et précédents mais aussi la suite du texte proprement dit ou le passage précédent
- @quest que faire de l’affichage des volumes et chapitres
- @quest naviguer parmi les illustrations d’un texte (distinguer plans de quartiers, représentation d’édifices, détails, et rendre compte de leur localisation)

Plusieurs éléments sont facilement accessibles dans la page sans pour autant surcharger l’interface

- une page de titre de l’édition critique
- une référence pour la citation (distincte ou non)
- un sommaire
- un accès facilité aux sections suivantes/précédentes ou aux résultats suivants et précédents
- la pagination originale du volume
- l’activation de la collation des lieux variants
- la possibilité de citer un passage du texte (cf. ci-dessous)
- localisation géographique rapide de l’entité décrite
- localisation physique du passage dans le volume (visualisation tomaison, dimension du passage, taille relative, autres occurrences dans le texte) @quest faut-il donner une indication sur le type de section, sachant que normalement cette indication est déjà rendue typographiquement ?
- liste des entités mentionnées et illustrations

#### Liens et renvois

Plusieurs mécanismes de liens et renvois sont prévus au sein de l’application afin de pouvoir naviguer au sein d’un texte donné, au sein d’un corpus d’auteur, et au sein du corpus en général.

Plusieurs types de liens sont à traiter distinctement

- liens internes présents dans l’édition originale
- liens internes générés grâces aux index (dans l’édition, parmi les autres éditions du corpus d’auteur)
- liens externes établis graces aux index (dans l’ensemble du corpus des Guides de Paris)

Dans l’idéal, lors de la consultation du texte, le lecteur peut suivre un lien présent dans l’édition originale, visualiser une liste de passages qui mentionnent le même édifice dans le texte ou les autres éditions générée à partir de l’index, et les autres mentions dans l’ensemble du corpus.

L’historique du navigateur doit permettre de revenir aux contenus précédemment consultées facilement, si possible en conservant la position dans la page.

#### Citabilité

Afin de faciliter la citabilité des ressources publiées chacune d’entre elle est assortie d’une URI pérenne facilement accessible sur la page.

Les portions de texte d’une édition peuvent être facilement référencées au moyen d’un pointeur par l’intermédiaire d’un bouton accessible lors de la sélection d’une portion de texte.

Le copier-coller sur une sélection de texte, copie dans le presse-papier le texte, suivi d’une référence bibliographique mise en forme et d’un pointeur.

La génération des pointeurs utilise ici le même mécanisme que celui utilisé pour la gestion des annotations. Le bouton pour copier l’URI doit être coordonné avec les interactions pour l’annotation du corpus et l’indexation.

#### Consultation d’une liste de résultats

Une recherche dans le corpus affiche une liste de résultats. Cette liste de résultat présente un certain nombre de filtres afin de restreindre le nombre de résultats ou affiner la recherche, elle est également triable selon plusieurs critères.

@todo préciser les filtres : corpus d’auteur, éditions, intervalle chronologique, entrées d’index de lieux, entrées d’index d’œuvres, entrées d’index de personne

@todo déterminer les tris : date, corpus, éditions, taille du passage

La consultation des résultats se fait dans le module de consultation linéaire des textes en proposant la possibilité de consulter les résultats suivants et précédents tout en permettant la lecture continue du texte. Il y a donc deux modes de lecture : une lecture linéaire qui restitue le contexte des passages et une lecture transversale en fonction des listes de résultats.

Depuis le module de lecture, il est possible de consulter l’ensemble de la liste de résultats pour la parcourir rapidement. Il est également possible de revenir à la liste de résultats proprement dit pour utiliser des filtres, affiner sa recherche, etc.

@quest depuis la liste de résultats comment rendre compte des autres mentions dans le corpus ? (visualisation en grisée avec sélecteur, etc.) Prévoir la possibilité de consulter les autres passages traitant de la même occurence dans les autres éditions ou dans l’ensemble du corpus.

@todo Envisager les navigations vers les présentations synthétiques (index pondérés, cartes géoréférencées)

La liste de résultats peut être affichée de différente manière

- liste
- visualisation géographique
- visualisation des entités
- ...

### Index

Plusieurs index offrent des modalités d’accès transversales au corpus.

Toutes les pages d’index et de références présentent des filtres qui permettent de restreindre dynamiquement la liste des résultats.

Pour les index topographiques, patronymiques et les listes d’œuvres une option permet de visualiser les entrées absentes dans la sélection filtrée. 

Filtres biblio

- auteur 
- date d’édition 
- formats 
- exemplaires numérisés
- rechercher parmi ces résultats (la recherche simple) 

Filtres topographiques

- quartier 
- paroisse (Alpage ?)
- type de lieu

@quest une des critiques d’Alpage défaut de traitement des paroisses

Filtres œuvres

- auteur d’œuvre
- date de création
- catégorie (peinture de chevalet, sculpture, monuments funéraires, fresques)
- matériaux ?
- sujets ?
- commanditaire ?

#### Base bibliographique

Outre le corpus édité, une bibliographie générale des Guides de Paris a été réalisée dans le cadre du projet. Cette base de données permet de restituer les textes édités dans leur contexte éditorial et de mettre en lumière des phénomènes de concurrence éditoriale.

La page présente une liste de références bibliographiques classées par œuvre avec le détail des manifestations, des expressions.

Les références présentées dans un format bibliographique peuvent être déployées pour accéder à des informations détaillées sur les dimensions et les exemplaires identifiés dans les collections publiques. Les exemplaires numérisés accessibles en ligne doivent pouvoir être facilement identifiables.

Les textes édités dans le cadre du projet sont facilement repérables par l’utilisateur qui peut y accéder directement depuis cette liste.

Un lien donne accès à la notice de référence de chaque entité qui présente toutes ces informations de manière structurée.

La page comporte également une présentation chronologique interactive des entités bibliographiques. L’utilisateur peut sélectionner une place chronologique ce qui met à jour dynamiquement la liste de résultats.

Un champ de recherche simple permet également de filtrer dynamiquement la liste des références et de mettre à jour la chronologie.

Les références bibliographiques sont exposées pour l’importation automatique dans un logiciel de références bibliographiques. 

Pour la commodité des utilisateurs, les références bibliographiques sont présentées dans différents formats de citation : Bibtex, RIS, ...

Présenter dans la fiche détaillée des liens vers les fichiers dans les formats du web sémantique (bibframe ?, schema ?) et afficher ces données à la demande.

- [http://bibframe.org](http://bibframe.org/)
- [http://schema.org/Book](http://schema.org/Book)
- [http://www.sparontologies.net](http://www.sparontologies.net/) (FRBR et Cidoc-CRM)

#### Index topographique

L’index topographique présente une vedette et une notice détaillée qui comporte des informations d’autorité et des renseignements historiques.

- Vedette normalisée
- Formes attestées du nom typées par date
- Désignation
- Type de lieu (paroisse, quartier, monument, place, rue, pont, quai, pays, ville, région, etc.)
- Relations géographiques typées par date (appartenance, notices en rapport...) 
- Informations de géolocalisation

Des informations chronologiques précisent chaque champs. 

@todo voir quelle utilisation possible des données Alpage 

#### Index patronymique

L’index patronymique

- Vedette normalisée
- Formes attestées du nom
- Nom, prénoms, particule, composantes du nom, etc.
- Titres ?
- Occupations ?
- Dates d’existence
- Lieux de naissance et de décès ??
- Relations ??

#### Index des œuvres

- Vedette normalisée
- formes attestées du nom
- créateur de l’œuvre
- localisation
- commanditaires
- catégorie de l’œuvre (peinture de chevalet, décors peints et sculptés, sculpture et monument, édifices architecturaux (ponts, hôtels, édifices religieux) )
- dates
- lieu de conservation

Comment récupérer les désignations du nom de lieu et éviter la répétition de la saisie

Comment gérer les informations concernant les localisation actuelles ? en travaillant sur l’automatisation le plus possible mais en laissant subsidiairement la possibilité de renseigner manuellement ces informations.

### Visualisations et traitements automatisés

L’application de consultation propose des interfaces de consultation basées sur un traitement automatisé du texte.

- collation des lieux variants
- contextes lexicaux (listes d’occurrences et de co-occurrences) ?
- visualisation cartographiques
- visualisations statistiques (à déterminer, tenir compte du ratio)

Ces visualisations sont importantes car elles sont destinées à fournir à l’utilisateur des vues synthétiques sur le corpus. Il s’agit ici de faire exister le corpus en tant que corpus.

#### Comparaison des lieux variants

La collation des lieux variants permet de visualiser dans l’interface les différences d’un même passage parmi plusieurs éditions. Cette collation est réalisée au moyen de l’algorithme [CollateX](https://collatex.net) qui présente une liste de positions et des chaînes de caractères concernées au format JSON. Les lieux variants sont affichés sous la forme d’une carte de points chauds (heat map) en surlignage transparent du texte. Des filtres de sélection permettent le choix des éditions et il est possible de lire les variantes au survol.

@todo vérifier l’algorithme, cibler les visualisations http://www.juxtasoftware.org/about/

#### Accès lexicaux

L’application présente plusieurs accès lexicaux basés sur l’exploitation du traitement automatique de la langue. Ces accès présentent des listes d’occurrences et de co-occurences qui restituent leurs contextes lexicaux.

@todo préciser le traitement, demande-t-on seulement au webdesigner de concevoir un affichage de listes d’occurrences et de contextes que l’on pourra implémenter par la suite

http://voyant-tools.org

#### Accès cartographiques

L’**accès cartographique** repose sur une géolocalisation des entrées d’index des œuvres. La localisation des parcelles repose sur les entrées documentées par le projet Alpage. Compte tenu de la nature des ouvrages publiés, l’accès topographique est une dimension importante de la consultation des guides. Un des enjeux de la visualisation est de parvenir à faire apparaître les présences et les absences à travers le corpus. L‘interface doit permettre la sélection des textes et des éditions afin de déterminer les points de visualisation.

Les données d’Alpage sont toutes disponibles en téléchargement sous [licence ODbL]([http://alpage.huma-num.fr/documents/0_Licence_ODbL.pdf)](http://alpage.huma-num.fr/documents/0_Licence_ODbL.pdf)). Plusieurs jeux de données topographiques sont particulièrement susceptibles de nous intéresser parce qu’ils présentent des rapports directs avec les noms de lieux ou les œuvres mentionnés dans les Guides cf. la [liste des données libres]([http://alpage.huma-num.fr/fr/ressources/donnees-sig)](http://alpage.huma-num.fr/fr/ressources/donnees-sig)). Par exemple, les quais de 1312 à 1789 (France Bourbon), les Établissements ecclésiastiques  (Etienne Lallau et al.), les Hôtels aristocratiques vers 1400 (Boris Bove), Hôtels aristocratiques vers 1300 (Boris Bove), marchés, foires, fontaines, paroisses et censives. Pour les hôtels aristocratiques et les autres édifices, les données issues du plan Vasserot (1810-1836) concernant les Parcelles et le Bâti, permettent de localiser la plupart des édifices de l’époque moderne.

Un "ShapeFile" ou "Fichier de Forme" est le format de stockage des données vectorielles utilisé par ArcGIS. Il est constitué des fichiers suivants :

- ***.shp** : stocke les entités géographiques. Il s'agit du shapefile proprement-dit.
- ***.dbf **(DataBaseFile) : stocke les données attributaires (consultable sous Excel).
- ***.shx** : stocke les index des enregistrements du fichier ".shp".
- ***.prj**  (recommandé) : stocke la projection associée.
- ***.sbn**, ***.sbx** (faculatatifs) : stocke des index n'existant qu'après une requête ou une jointure.
- ***.xml** (facultatif) : stocke les métadonnées relative au shape.

cf. [http://www.portailsig.org](http://www.portailsig.org/)

voir : [http://www.esri.com/library/whitepapers/pdfs/shapefile.pdf](http://www.esri.com/library/whitepapers/pdfs/shapefile.pdf)

Le prestataire doit rechercher, évaluer et proposer une solution de visualisation des données géographiques enregistrées dans la base en faisant référence aux objets géographiques décrits dans ALPAGE.

Dans l’idéal le module géographique permet de générer dynamiquement des cartes en faisant apparaître les différents fonds de carte (îlots, réseaux viaires et parcellaires) ainsi que les objets sélectionnés par l’intermédiaire de filtres à facettes.

La fenêtre de visualisation cartographique présente un zoom.

Quel système de repérage des lieux ? points, parcelles ? les deux ?

Comment permettre de relancer la recherche dans la même interface ?

Comment établir le lien entre la cartographie et les passages du texte ? Modalités d’accès à partir du repère sur la carte, listes de résultats sous la carte.

Prévoir listes de résultats dynamique sous la carte qui offrira l’avantage de présenter des informations supplémentaire que l’on ne souhaite pas forcément voir apparaître sur la carte.

@todo Comment restituer l‘affichage de ces données dans une interface web ?

La visualisation cartographique repose sur l’utilisation de facettes : 

- par auteurs
- par texte
- par chronologie ?
- par typologie ?

Facettes

- rues
- édifices
- œuvres
- artistes ?

Sélecteur chronologique

Sur chacun des filtres, prévoir un indicateur d’occurrences.

Envisager des listes déroulantes pour éviter de se perdre dans des listes. Lorsque les listes sont trop importantes, prévoir des requêtes asynchrones pour dérouler la liste.

Permettre la déselection de certains critères.

Prévoir un module de restriction de l’étendue des résultats.

@todo développer

exemple de filtres

- [http://catalogue.bnf.fr/affiner.do?motRecherche=sauval&trouveDansFiltre=NRI&pageEnCours=1&afficheRegroup=false&triResultParPage=0&critereRecherche=0](http://catalogue.bnf.fr/affiner.do?motRecherche=sauval&trouveDansFiltre=NRI&pageEnCours=1&afficheRegroup=false&triResultParPage=0&critereRecherche=0)

exemples de référence :

- [https://www.google.ca/maps/search/restaurant+japonais/@45.4982409,-73.6414698,13z/data=!3m1!4b1](https://www.google.ca/maps/search/restaurant+japonais/@45.4982409,-73.6414698,13z/data=!3m1!4b1)
- [https://www.pagesjaunes.ca/search/si/1/restaurant%20mile%20end/Montréal](https://www.pagesjaunes.ca/search/si/1/restaurant%20mile%20end/Montr%C3%A9al) 
- [https://www.pagesjaunes.ca/search/si/1/restaurant%20mile%20end/Montréal?expandMap=list&trGeo=45.52956107124846,-73.58376502990721&blGeo=45.5145872236384,-73.61449241638184](https://www.pagesjaunes.ca/search/si/1/restaurant%20mile%20end/Montr%C3%A9al?expandMap=list&trGeo=45.52956107124846,-73.58376502990721&blGeo=45.5145872236384,-73.61449241638184)
- [http://gallica.bnf.fr/services/engine/search/sru?operation=searchRetrieve&version=1.2&query=%28gallica%20all%20%22Piganiol%22%29&suggest=0](http://gallica.bnf.fr/services/engine/search/sru?operation=searchRetrieve&version=1.2&query=%28gallica%20all%20%22Piganiol%22%29&suggest=0)
- [http://mapoflondon.uvic.ca](http://mapoflondon.uvic.ca/)

#### Visualisations statistiques

(à déterminer)

étendue du texte par édition / auteur

fréquence de l’occurrence par édition / auteur

choix des mots ?

dates des édifices/œuvres traités

étendue du texte par catégorie (à déterminer)

@todo y réfléchir

### Implémentation du module d’annotation et d’indexation

L’application des Guides de Paris offre plusieurs modalités d’annotation pour outiller la lecture des textes et leur indexation. 

#### Gestion des utilisateurs

The Guides de Paris web application requires a customized users facility which doesn’t relay on the default BaseX users module. 

This feature uses the delegated authentication providers protocol OpenAuth 2.0.

[https://oauth.net](https://oauth.net/)

[http://openid.net/specs/openid-authentication-2_0.html](http://openid.net/specs/openid-authentication-2_0.html)

It should

- allow identification from the following delegated authentification providers : Google, Dropbox, Yahoo, Twitter, Facebook, LinkedIn
- creation and editing profile in the application
- fine admin rights controls (see below)
- public profiles with a list of contributions

#### Voting process and review states

Each Registered user submission is subjected to a reviewing using a voting process. These submissions could be "Under review", "Accepted", "Reverted" or marked as "Vandalism".

1. An item *Under review* shall be accepted to become the available version if it receives a minimum number of favorable votes. It would be reverted with a minimum number of unfavorable votes.
2. When an item is *Accepted* it will not change no matter how many favorable votes it receives. If it receives a minimum number of un-favorable votes, it will become *Reverted* and the previous *Accepted* revision will become the latest version.
3. If an item is *Reverted*, it could be accepted again and become the latest version if it receives the minimum number of faborable votes and there are no later Accepted of Under review edits for the item. Nothing changes if it receives an un-favorable vote. 
4. An item in any state, can be marked as "Vandalism". It requires a Platform editor to mark the purported Vandalism as not vandalism. In this case, the revision is marked as reverted and can be moved to Accepted if the conditions in item 3 above are met.

#### Roles and nomination

Users can have one of the following roles : *Super Admin*, *Admin*, *Editor*, *Registered user*

*Super admin* have all the rights.

*Admins* can directly accept, revert or mark as vandalism an item under review. Admins can promote a Registered user to Editor. The Admin contributions are directly Accepted without going thought the normal reviewing process. But they still can be subjected to the voting process and the other review states.

*Editors* are registered user who can votes and review the contributions of all the users.

A *Registred user* can be promoted to Editor through a nomination process. With 5 contributions marked as accepted, a Registred is automatically proposed in the nomination process to become an editor.

### Dashboard and admin pages

Each users can access to a dashboard page with various content against its rights.

This dashboard presents

- a list of Under review contributions (editors)
- recent editings (admins)
- recent editings in the following items (editors)
- my contributions (automatically marked as followed) (editors + admins + Registered users)
- my followed items (editors + admins + Registered users) with status information on the contributions

### Annotation

Les différents passages des textes peuvent faire l’objet d’annotation au format OpenAnnotation, ces annotations sont soient privées soit publiques. Elles peuvent être catégorisées de manière à faciliter le travail d’édition des textes et notamment recueillir le signalement d’erreurs éventuelles dans la transcription. Les annotations catégorisées de la sorte sont automatiquement rendues publiques.

Type d’annotation

- mot-clef personnalisé


- signalement d’une erreur


- statut de l’annotation (privé/public)

Plusieurs modalités d’annotation sont prévues pour l’annotation du corpus.

Enregistrement de passages intéressants pour soi-même.

Partage de passages pertinents (et citation canonique)

Utiliser l’annotation pour le signalement des erreurs, et l’indexation.

### Indexation et recommandation

Each named entity that have been marked up in the corpus can be indexed in the public interface. There are three kind of entities : Persons or Corporate bodies, Places, Works of arts. Each entity is described in a standalone file conforming to the *Names, dates, people and places* module of the TEI. (see[www.tei-c.org/release/doc/tei-p5-doc/en/html/ND.html)](http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ND.html))

\- Distinguish the indexed entities from the non-indexed in the interface

\- UX interaction to index one entity

\- XQuery Update of the authority file

\- resolve the entity with an index entries (certainty ?)

\- fill or edit a standardized form based on the entity type (ask reviewing)

\- report missing type

Entity resolution

Assist the user suggesting a list of index entries based on the context and the syntax of the entity.

Use Linked Data to enhance the indexing process proposing existing entities and auto-fill the form.

\- ISNI + DataBnf

\- Onoma

\- Mérimée

\- Wikipédia + Wikidata (résumés)

[https://www.inha.fr/fr/agenda/parcourir-par-annee/en-2017/juin-2017/onoma-un-referentiel-d-acteurs-du-ministere-de-la-culture-ancre-dans-le-web-semantique.html](https://www.inha.fr/fr/agenda/parcourir-par-annee/en-2017/juin-2017/onoma-un-referentiel-d-acteurs-du-ministere-de-la-culture-ancre-dans-le-web-semantique.html)

Travailler sur la journalisation des fichiers d’autorité et le statut.

Prévoir export documents valides dans GitHub. (priority low)

Toutes les entités marquées dans le corpus (personnes, œuvres, lieux) peuvent être indexées de manière collaborative.

Création d’un compte utilisateur et gestion de droits

Statut de l’indexation

Flux

Prévoir des possibilités d’indexation de corpus. Gestion du flux éditorial et des révisions.

### Implémentation du module d’annotation et d’indexation

L’application des Guides de Paris offre plusieurs modalités d’annotation pour outiller la lecture des textes et leur indexation. 

#### Annotation

Les différents passages des textes peuvent faire l’objet d’annotation au format OpenAnnotation, ces annotations sont soient privées soit publiques. Elles peuvent être catégorisées de manière à faciliter le travail d’édition des textes et notamment recueillir le signalement d’erreurs éventuelles dans la transcription. Les annotations catégorisées de la sorte sont automatiquement rendues publiques.

Type d’annotation

- mot-clef personnalisé
- signalement d’une erreur
- statut de l’annotation (privé/public)

Plusieurs modalités d’annotation sont prévues pour l’annotation du corpus.

Enregistrement de passages intéressants pour soi-même.

Partage de passages pertinents (et citation canonique)

Utiliser l’annotation pour le signalement des erreurs, et l’indexation.

#### Indexation et recommandation

Toutes les entités marquées dans le corpus (personnes, œuvres, lieux) peuvent être indexées de manière collaborative.

Création d’un compte utilisateur et gestion de droits

Statut de l’indexation

Flux

Prévoir des possibilités d’indexation de corpus. Gestion du flux éditorial et des révisions. 

### Développements informatiques qui peuvent nécessiter une prestation distincte

#### Moteur de recherche lexical

L’ensemble des contenus textuels du site sont susceptibles d’être interrogés en plein texte par l’intermédiaire d’un moteur de recherche lexical. Les sources étant en XML et l’application étant publiée avec BaseX, le moteur de recherche est construit avec XQuery Full-text et BaseX afin de réduire la complexité de l’application.

Plusieurs filtres lexicaux doivent être mis en place afin de faciliter la recherche de résultats

\- utilisation d’une liste de mots vides

\- utilisation d’un lemmatiseur (si possible adapté aux textes du 17e)

#### Gestion des comptes utilisateurs

Module d’annotation et d’indexation

Dépendance avec Hypothesis

## Discuter des points d’entrée de l’application et de l’architecture de l’API

## Envisager les conséquences sur le traitement des textes

## Réponse à Anthony Masure et Sophie Fétro