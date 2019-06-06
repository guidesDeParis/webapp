# Installation

## Installation de BaseX

BaseX est un processeur de base de données XML libre et open source. Le logiciel implémente les standards XQuery 3.1 et plusieurs extensions telles que XQuery Update Facilite et XQuery Full-text ou encore RESTXQ.
L’application peut être exécutée de plusieurs manières

- comme application standalone
- sous la forme d’un client graphique (Graphical User Interface GUI)
- comme client en ligne de commande
- comme server HTTP pour des applications web

Le logiciel est publié sous la clause 3 de BSD.

### Télécharger BaseX

Plusieurs distributions sont proposées, il faut installer la distribution complète sous la forme d’une archive ZIP ou d’un installateur Windows qui contient des composants pour les applications RESTXQ, des scripts de démarrage, ainsi qu’un client web de gestion de base de données DBA.

http://basex.org/download/, Sélectionner le ZIP Package puis extraire l’archive. Les répertoires suivants devraient être disponibles :

- `bin/` scripts de démarrage pour Windows et Linux
- `data/` fichiers de données
- `etc/` données d’exemples
- `lib/` librairies supplémentaires (Jetty, Tagsoup, etc.)
- `lib/custom/` répertoire dans lequel placer les fichiers JAR supplémentaires comme la bibliothèque Saxon
- `repo/` modules externes XQuery
- `src/` scripts XQuery
- `webapp/` répertoire de l’application web : home de l’application RESTXQ 

Les sources du logiciel sont disponibles sur GitHub https://github.com/BaseXdb/basex

### Installation du JRE

BaseX est une application Java qui nécessite Java 8 pour fonctionner (depuis BaseX version 9). L’environnement d’implémentation doit disposer d’un [Java Runtime Environment (JRE)](http://www.java.com).

Nota, la documentation annonce JRE, mais précédemment il fallait une JDK :

- Télécharger la JDK depuis la page d’Oracle <http://www.objis.com/formation-java/tutoriel-java-installation-jdk.html>. Avant de télécharger, sélectionner la version appropriée (system + processor: i.e. Mac OSX x64)
- Allez dans le répertoire de Téléchargement et double-cliquer sur le fichier d’installation : i.e.: jdk-8u60-macosx-x64.dmg or jdk-8u60-macosx-x64.exe
- Suivre les étapes du processus d’installation
- Ouvrir un terminal pour vérifier la version de JDK avec la commande suivante : `java -version`

### Démarrer BaseX

L’application BaseX est démarrée en exécutant l’un des scripts contenus dans le répertoire `bin/` qui ajoutent toutes les classes java contenues dans le répertoire `lib/` dans le classpath. Sur Windows, des lanceurs ont été créés lors de l’installation.

Il est souvent commode d’ajouter le répertoire `bin/` de la distribution ZIP dans le PATH avec une variable d’environnement.

- Le client HTTP s’exécute avec `bin/basexhttp`, il peut être arrêté avec `bin/basexstop`
- Le client graphique s’exécute avec `bin/basexgui`

### Installation de SynopsX

Télécharger le fork des Guides de Paris des sources de [SynopsX](http://synopsx.github.io/)

```bash
git clone https://github.com/guidesDeParis/synopsx.git # cloner SynopsX
```

Dans le répertoire `webapp/`, renommer le fichier `restxq.xqm` en `restxq.old` afin d’éviter les conflits avec le fichier de démonstration de RESTXQ distribué par BaseX. 

Le répertoire `synopsx/` doit être disponible à l’intérieur du répertoire `webapp/` de BaseX.

```bash
cd basex/webapp/
mv restxq.xqm restxq.old # restxq.xqm définit par défaut une fonction resource pour `/`
```

Télécharger les sources de [gdpWebapp](https://github.com/guidesDeParis/gdpWebapp) 

Le répertoire `webapp/` doit être disponible à l’intérieur de `synospx/workspace/` et être renommé `gdp`. 

```bash
git clone https://github.com/guidesDeParis/webapp # clone gdpWebapp
```

Pour éviter d’avoir des chemins trop complexes, il est peut être commode d’utiliser des liens symboliques :

```bash
ln -s chemin/sources/synopsx chemin/basex/webapp # rendre disponible synopsx dans webapp
ln -s chemin/sources/webapp chemin/sources/synopsx/workspace/gdp # rendre disponible gdpWebapp dans workspace sous le nom gdp
```

Lancer BaseX en mode HTTP :

```bash
cd basex/bin/ # aller dans le répertoire BaseX
sh ./basexhttp # exécuter le script de démarrage de BaseX en mode HTTP
```

### Téléchargement des sources et création de la base de données

Les sources du projet doivent être téléchargées depuis le répertoire Github des Guides de Paris

```bash
git clone https://github.com/guidesDeParis/webappPrep # clone gdpWebapp
```

Aller dans l’administration de la base `admin DB` et créer une base de données nommée `gdp` avec les sources XML-TEI du projet des Guides de Paris.

### Configuration de SynopsX

Dans un navigateur, se rendre sur http://localhost:8984 que sert BaseX par défaut en mode HTTP.

Dans le panneau de configuration de SynopsX, accéder au menu `Config`, créer un projet nommé `gdp` puis changer le projet par défaut pour `gdp`.

### Installation du processeur Saxon

Le logiciel SynopsX peut faire appel à des transformations XSLT. Les transformations XSLT dans les versions XSLT 2.0 et 3.0 nécessitent le processeur Saxon. En son absence, l’application démarrée en mode HTTP renvoie un message d’erreur du type :

Le processeur saxon peut être installé de la manière suivante

- Télécharger le fichier zip depuis <http://sourceforge.net/projects/saxon/files/>
- Décompresser l’archive téléchargée
- Placer le contenu dans `basex/lib/custom`

Redémarrer Basex HTTP.



