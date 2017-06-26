# Cahier des Clauses Particulières

Le Cahier des clauses particulières (CCP) est un document qui regroupe les clauses administratives et techniques spécifiques à un marché.

## Log

\- 2017-06-26 discussion avec Josselin

\- 2017-06-23 développements

\- 2017-05-26 développements

\- 2017-05-19 travail sur la description de l’application

\- 2017-05-12 structuration du cahier des charges

### Navigation

La navigation est la plus simple possible, elle met à la fois l’accent sur les contenus relatifs au projet et la consultation du corpus.

- à propos
- blog du projet
- Les guides de Paris
  - Consulter
  - Index
  - Accès cartographique
  - Bibliographie

### Consultation du corpus

L’interface du site des Guides de Paris est destiné à donner à lire les textes mais aussi à offrir des accès synoptique au corpus. Il est possible de consulter directement une édition particulière sans devoir passer par la recherche. Depuis, une édition donnée, on peut également facilement accéder aux autres éditions ainsi qu’au contenus en rapport dans les autres corpus.

L’interface de consultation, sobre et distinguée, met l’accent sur la lisibilité et le confort de lecture du texte. À cette fin, un soin particulier est accordé au traitement typographique qui doit offrir une belle régularité. Plusieurs rendus typographiques sont à prévoir pour distinguer les différents niveaux de notes, les contenus clivables et diverses interactions sur le texte.

Une liste de corpus donne en premier lieu accès à la consultation des Guides. Celle-ci donne accès aux corpus d’auteurs et aux éditions en particulier. Cette interface permet aussi de définir le périmètre d’une recherche simple ou avancée par l’intermédiaire de filtres sur le corpus.

Les textes proprement dits peuvent être consultés de diverses manières : 

- ceux-ci peuvent être lus de manière linéaire du début à la fin
- mais on peut également consulter le corpus de façon transversale, à partir d’une liste de résultats sur un monument, un artiste, etc.

#### Présentation du corpus

Le corpus fait l’objet de plusieurs présentations alternatives. On peut  :

- Lister les corpus par auteurs et par dates des corpus d’auteur
- Lister les textes par dates d’édition

Il pourrait être intéressant de pouvoir utiliser la même présentation pour les listes de résultats @quest

##### Liste des corpus par auteurs

Les corpus sont listés par auteurs avec une indication du nombre de textes disponibles pour chaque auteur. Pour chaque corpus d’auteur, un menu accordéon permet de visualiser la liste des textes.

Cette liste de corpus d’auteurs peut être triée par date ou par ordre alphabétique d’auteur.

##### Lister les textes par dates d’édition

La liste des textes peut être affichée par date d’édition afin de visualiser les phénomènes éditoriaux.

Propose-t-on des facettes dans la présentation des corpus

- éditeurs
- dates d’édition
- lieu d’édition
- pagination / étendue ?? 
- par occurences
- par nombre d’éditions

@quest La présentation de la bibliographie doit-elle être séparée ou bien utilise-t-elle la même interface ?

#### Consultation linéaire du texte

- Page de titre
- Le texte est présenté de manière linéaire en utilisant un scroll infini.
- Chargement automatique des textes suivants vers la fin du chapitre.

Plusieurs éléments sont diponibles

- Sommaire
- Titre et références,
- À tous les moments proposer le passage à la section suivante.
- pagination
- citation du passage

#### Consultation d’une liste de résultats

Liste de résultats

@quest comment passe de la liste de résultats au texte

Consultation des résultats

La consultation des résultats reprend la présentation linéaire du texte. à la fin du passage, on charge le passage suivant pour restituer une lecture linéaire et les contextes de lecture. Prévoir une bifurcation pour une lecture transversale dans le corpus. Résultat précédent, Résultat suivant.

Quels sont les modalités d’accès aux autres éléments du corpus qui évoquent le même sujet que celui consulté ?

Prévoir la possibilité de consulter les autres passages traitant de la même occurence dans les autres éditions ou dans l’ensemble du corpus.

Envisager les navigations vers les présentations synthétiques.

### Index

Plusieurs index offrent des modalités d’accès transversales au corpus.

#### **Index topographique**

L’index topographique présente une vedette et une notice détaillée qui comporte des informations d’autorité et.

#### Index patronymique

L’index patronymique

- Vedette normalisée
- Formes attestées du nom
- Nom, prénoms, particule, composantes du nom, etc.
- Titres
- Dates d’existence et lieux de naissance et de décès
- Occupations
- Relations

#### Index des œuvres

### Visualisations et traitements automatisés

L’application de consultation propose des interfaces de consultation basées sur un traitement automatisé du texte.

- collation des lieux variants
- contextes lexicaux ?
- visualisation cartographiques
- visualisations statistiques (à déterminer)

Ces visualisations sont importantes car elles sont destinée à fournir à l’utilisateur une vue synthétique sur le corpus. Il s’agit ici de faire exister le corpus en tant que corpus.

#### **Comparaison des lieux variants**

Pour la collation des lieux variants, il s’agit d’offrir au lecteur la possibilité de visualiser dans l’interface les variantes entre les différentes éditions d’un même texte. La localisation des lieux variants est réalisée à l’aide de l’algorithme XXX dont la sortie présente au format JSON une liste de positions et les chaînes de caractères concernées...

#### **Accès lexicaux**

L‘application présente plusieurs accès lexicaux basés sur l’exploitation du traitement automatique de la langue.

Les **contextes lexicaux** permettent de naviguer parmi des listes d’occurences...

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

L’application des Guides de Paris offre plusieurs modalités d’annotation pour outiller la lecture des textes et leur indexation. Les différents passages des textes peuvent faire l’objet d’annotation au format OpenAnnotation privées ou partageables. Ces annotation peuvent être catégorisées de manière à faciliter le travail d’édition des textes et notamment recueillir le signalement d’erreurs éventuelles dans la transcription. Les annotations catégorisées de la sorte sont automatiquement rendues publiques.

Plusieurs modalités d’annotation sont prévues pour l’annotation du corpus.

Enregistrement de passages intéressants pour soi-même.

Partage de passages pertinents (et citation canonique)

Utiliser l’annotation pour le signalement des erreurs, et l’indexation.

Indexation et recommandation  

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