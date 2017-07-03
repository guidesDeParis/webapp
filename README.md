gdpWebapp
=========

Sous-module SynopX pour l’édition XML-TEI des Guides de Paris.

## Installation

### Prerequisites

- [BaseX](http://basex.org/) > 8 (requiert Java version 8)
- [SaxonHE](http://sourceforge.net/projects/saxon/files/) (placer le fichier .jar dans `basex/lib`)
- [SynopsX](http://synopsx.github.io/)

Télécharger les sources de `SynopsX`

````bash
git clone https://github.com/synopsx/synopsx.git
````

Dans le répertoire `webapp`, renommer le fichier restxq.xqm en restxq.old pour éviter les conflits avec le fichier de démonstration restxq distribué par BaseX. Le répertoire `synopsx` doit être disponible à l’intérieur du répertoire `webapp` de BaseX.

```bash
cd basex/webapp
mv restxq.xqm restxq.old # default restxq.xqm defines a function resource for `/`
```

Télécharger les sources de `gdpWebapp`

```bash
git clone https://github.com/guidesDeParis/gdpWebapp
```

Le répertoire `gdpWebapp` doit être disponible à l’intérieur de `synospx/workspace` et renommé `gdp`. Pour éviter d’avoir des chemins trop complexes, il est commode d’utiliser des liens symboliques.

```bash
ln -s chemin/source/synopsx chemin/basex/webapp
ln -s chemin/source/gdpWebapp chemin/source/synopsx/workspace/gdp
```

 