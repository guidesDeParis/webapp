xquery version "3.0" ;
module namespace gdp.models.tei = 'gdp.models.tei' ;

(:~
 : This module is a TEI models library for paris' guidebooks edition
 :
 : @version 1.0
 : @date 2019-05
 : @since 2014-11-10 
 : @author emchateau (Cluster Pasts in the Present)
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
 :)

import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module 'gdp.models.tei' at 'teiContent.xqm' , 'teiBuilder.xqm' ;

import module namespace gdp.globals = 'gdp.globals' at '../globals.xqm' ;

declare namespace tei = 'http://www.tei-c.org/ns/1.0' ;

declare default function namespace 'gdp.models.tei' ;

(:~
 : ~:~:~:~:~:~:~:~:~
 : tei blog
 : ~:~:~:~:~:~:~:~:~
 :)
 
(:~
 : this function get the blog home
 :
 : @param $queryParams the request params sent by restxq
 : @return a map with meta and content
 :)
declare function getBlogPosts($queryParams as map(*)) as map(*) {
  let $posts := synopsx.models.synopsx:getDb($queryParams)//tei:TEI
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $meta := map{
    'title' : 'Page d’accueil du blog', 
    'quantity' : getQuantity($posts, 'expression', 'expressions'),
    'author' : getAuthors($posts, $lang),
    'copyright' : getCopyright($posts, $lang),
    'description' : getDescription($posts, $lang),
    'keywords' : getKeywords($posts, $lang) 
    }
  let $content := for $post in $posts 
    let $uuid := $post//tei:sourceDesc/@xml:id
    return map {
    'title' : getMainTitle($post, $lang),
    'subtitle' : getSubtitle($post, $lang),
    'date' : getDate($post, $dateFormat),
    'author' : getAuthors($post, $lang),
    'abstract' : getAbstract($post, $lang),
    'uuid' : $uuid,
    'path' : '/blog/posts/',
    'url' : $gdp.globals:root || '/blog/posts/' || $uuid
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get a blog post by ID
 :
 : @param $queryParams the request params sent by restxq
 : @param $entryId the blog post ID
 : @return a map with meta and content
 :
 : @bug le contenu de la clef tei génère un bug de la sérialisation json
 :)
declare function getBlogItem($queryParams as map(*)) {
  let $entryId := map:get($queryParams, 'entryId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $article := synopsx.models.synopsx:getDb($queryParams)/tei:teiCorpus/tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id=$entryId]]
  let $meta := map{
    'title' : getTitles($article, $lang),
    'author' : getAuthors($article, $lang),
    'copyright' : getCopyright($article, $lang),
    'description' : getDescription($article, $lang),
    'keywords' : getKeywords($article, $lang)
    }
  let $uuid := $article//tei:sourceDesc/@xml:id
  let $content := map {
    'rubrique' : 'Article de blog',
    'title' : getMainTitle($article, $lang),
    'subtitle' : getSubtitle($article, $lang),
    'date' : getDate($article, $dateFormat),
    'author' : getAuthors($article, $lang),
    'abstract' : getAbstract($article, $lang),
    'tei' : $article//tei:text/*,
    'uuid' : $uuid,
    'path' : '/blog/posts/',
    'url' : $gdp.globals:root || '/blog/posts/' || $uuid,
    'itemBeforeTitle' : getTitles(getBlogItemBefore($queryParams, $article, $lang), $lang),
    'itemBeforeUrl' : getUrl(getBlogItemBefore($queryParams, $article, $lang)//tei:sourceDesc/@xml:id, '/blog/posts/', $lang),
    'itemAfterTitle' : getTitles(getBlogItemAfter($queryParams, $article, $lang), $lang),
    'itemAfterUrl' : getUrl(getBlogItemAfter($queryParams, $article, $lang)//tei:sourceDesc/@xml:id, '/blog/posts/', $lang)
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : ~:~:~:~:~:~:~:~:~
 : tei edition
 : ~:~:~:~:~:~:~:~:~
 :)

(:~
 : this function get the about page
 :
 : @param $queryParams the request params sent by restxq 
 : @return a map with meta and content
 : @todo check url
 :)
declare function getAbout($queryParams as map(*)) as map(*) {
  let $entryId := map:get($queryParams, 'entryId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $article := synopsx.models.synopsx:getDb($queryParams)/tei:TEI[//tei:sourceDesc[@xml:id=$entryId]]
  let $meta := map{
    'title' : getTitles($article, $lang), 
    'subtitle' : getSubtitle($article, $lang), 
    'author' : getAuthors($article, $lang),
    'copyright' : getCopyright($article, $lang),
    'description' : getDescription($article, $lang),
    'keywords' : getKeywords($article, $lang)
    }
  let $content := 
    for $item in $article 
    let $uuid := $article//tei:sourceDesc/@xml:id
    return map {
    'title' : getTitles($item, $lang),
    'subtitle' : getSubtitle($item, $lang),
    'date' : getDate($item, $dateFormat),
    'author' : getAuthors($item, $lang),
    'abstract' : getAbstract($item, $lang),
    'uuid' : $uuid,
    'path' : '/about/',
    'url' : $gdp.globals:root || '/' || $uuid,
    'tei' : $item
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the corpus list
 :
 : @param $queryParams the request params sent by restxq 
 : @return a map with meta and content
 :)
declare function getHome($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $corpora := synopsx.models.synopsx:getDb($queryParams)//tei:teiCorpus
  let $meta := map{
    'title' : 'Accueil', 
    'quantity' : getQuantity($corpora, 'article', 'articles'), (: @todo internationalize :)
    'author' : getAuthors($corpora, $lang),
    'copyright'  : getCopyright($corpora, $lang),
    'description' : getDescription($corpora, $lang),
    'keywords' : getKeywords($corpora, $lang),
    'url' : $gdp.globals:root || '/home'
    }
  let $content := map {
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};
declare function getCorpusList($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $corpora := synopsx.models.synopsx:getDb($queryParams)/tei:teiCorpus
  let $meta := map{
    'title' : 'Liste des corpus', 
    'quantity' : getQuantity($corpora/tei:teiCorpus, 'corpus disponible', 'corpora disponibles'),
    'author' : getAuthors($corpora, $lang),
    'copyright'  : getCopyright($corpora, $lang),
    'description' : getDescription($corpora, $lang),
    'keywords' : getKeywords($corpora, $lang),
    'tei' : $corpora/tei:teiHeader
    }
  let $content := 
    for $corpus at $count in $corpora/tei:teiCorpus 
    let $uuid := $corpus/tei:teiHeader//tei:sourceDesc/@xml:id
    return map {
    'title' : getTitles($corpus, $lang),
    'date' : getEditionDates(getOtherEditions(getRef($corpus))/tei:biblStruct, $dateFormat),
    'author' : getAuthors($corpus, $lang),
    'abstract' : getAbstract($corpus, $lang),
    'editionsQuantity' : getQuantity(getOtherEditions(getRef($corpus))/tei:biblStruct, 'édition', ' éditions'),
    'textsQuantity' : getQuantity($corpus//tei:TEI, 'texte disponible', 'textes disponibles'),
    'uuid' : $uuid,
    'path' : '/corpus/',
    'url' : $gdp.globals:root || '/corpus/' || $uuid,
    'editions' : getOtherEditions(getRef($corpus)),
    'weight' : getStringLength($corpus)
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the corpus list
 :
 : @param $queryParams the request params sent by restxq 
 : @return a map with meta and content
 : @todo suppress @xml:id filter on div
 :)
declare function getCorpusById($queryParams as map(*)) as map(*) {
  let $corpusId := map:get($queryParams, 'corpusId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $corpus := synopsx.models.synopsx:getDb($queryParams)/tei:teiCorpus/tei:teiCorpus[tei:teiHeader//tei:sourceDesc[@xml:id = $corpusId]]
  let $meta := map{
    'title' : 'Liste des textes disponibles', 
    'quantity' : getQuantity($corpus/tei:TEI, 'texte disponible', 'textes disponibles'),
    'author' : getAuthors($corpus, $lang),
    'copyright'  : getCopyright($corpus, $lang),
    'description' : getDescription($corpus, $lang),
    'keywords' : getKeywords($corpus, $lang)
    }
  let $content := 
    for $text in $corpus/tei:TEI 
    let $uuid := $text/tei:teiHeader//tei:sourceDesc/@xml:id
    return map {
    'title' : getTitles($text, $lang),
    'date' : getEditionDates(getOtherEditions(getRef($text))/tei:biblStruct, $dateFormat),
    'author' : getAuthors($text, $lang),
    'biblio' : getRef($text),
    'abstract' : getAbstract($text, $lang),
    'format' : getRef($text)//tei:dim[@type = 'format'],
    'itemsNb' : fn:count($text//tei:*[@type = 'item' or @type = 'section']),
    'weight' : getStringLength($text),
    'uuid' : $uuid,
    'path' : '/texts/',
    'url' : $gdp.globals:root || '/texts/' || $uuid,
    'otherEditions' : fn:count(getOtherEditions(getRef($text))/tei:biblStruct)
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get text by ID
 :
 : @param $queryParams the request params sent by restxq 
 : @return a map with meta and content
 : @todo suppress the @xml:id filter on div
 : @todo check the text hierarchy
 : @todo old function to delete
 :)
declare function getTextItemsById($queryParams as map(*)) as map(*) {
  let $textId := map:get($queryParams, 'textId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $text := synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader//tei:sourceDesc[@xml:id = $textId]]
  let $meta := map{
    'title' : 'Liste des items disponibles', 
    'quantity' : getRef($text),
    'author' : getAuthors($text, $lang),
    'copyright'  : getCopyright($text, $lang),
    'description' : getDescription($text, $lang),
    'keywords' : getKeywords($text, $lang)
    }
  let $content := 
    (: for $item in $text//tei:div[(@type = 'item' and @xml:id) or (@type = 'section' and @xml:id ) or (@type = 'chapter' and @xml:id )] :)
    for $item in $text//tei:div[(@type = 'item' and @xml:id) or (@type = 'section' and @xml:id )]
    let $uuid := (if ($item/@xml:id) then $item/@xml:id else 'toto')
    return map {
    'title' : if ($item/tei:head[1]) then $item/tei:head[1]/node() else $item/tei:p/tei:label[1]/node() ,
    'date' : getDate($item, $dateFormat),
    'author' : getAuthors($item, $lang),
    'abstract' : getAbstract($item, $lang),
    'tei' : $item,
    'path' : '/items/',
    'uuid' : $uuid,
    'url' : $gdp.globals:root || '/items/' || $uuid
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get text by ID
 :
 : @param $queryParams the request params sent by restxq 
 : @return a map with meta and content
 : @todo suppress the @xml:id filter on div
 : @todo check the text hierarchy
 :)
declare function getTextById($queryParams as map(*)) as map(*) {
  let $textId := map:get($queryParams, 'textId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $text := synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader//tei:sourceDesc[@xml:id = $textId]]
  let $meta := map{
    'title' : 'Sommaire de ' || getTitles($text, $lang), 
    'quantity' : getRef($text),
    'author' : getAuthors($text, $lang),
    'copyright'  : getCopyright($text, $lang),
    'description' : getDescription($text, $lang),
    'keywords' : getKeywords($text, $lang)
    }
  let $content := 
    for $item in $text//tei:div[(@type = 'item' and @xml:id) or (@type = 'section' and @xml:id )]
    let $uuid := (if ($item/@xml:id) then $item/@xml:id else 'toto')
    return map {
    'title' : if ($item/tei:head[1]) then $item/tei:head[1]/node() else $item/tei:p/tei:label[1]/node() ,
    'date' : getDate($item, $dateFormat),
    'author' : getAuthors($item, $lang),
    'abstract' : getAbstract($item, $lang),
    'tei' : $item,
    'path' : '/items/',
    'uuid' : $uuid,
    'url' : $gdp.globals:root || '/items/' || $uuid
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get text by ID
 :
 : @param $queryParams the request params sent by restxq 
 : @return a map with meta and content
 :)
declare function getTocByTextId($queryParams as map(*)) as map(*) {
  let $textId := map:get($queryParams, 'textId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $text := synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader//tei:sourceDesc[@xml:id = $textId]]
  let $meta := map{
    'title' : 'Sommaire de ' || getTitles($text, $lang), 
    'quantity' : getRef($text),
    'author' : getAuthors($text, $lang),
    'copyright'  : getCopyright($text, $lang),
    'description' : getDescription($text, $lang),
    'keywords' : getKeywords($text, $lang)
    }
  let $content := for $text in $text//tei:text return content($text/*, $lang)
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get item by ID
 :
 : @param $queryParams the request params sent by restxq 
 : @return a map with meta and content
 :)
declare function getItemById($queryParams as map(*)) as map(*) {
  let $itemId := map:get($queryParams, 'itemId')
  let $textId := fn:tokenize($itemId, '(Front|Body|Back|T)')[1] (: map:get($queryParams, 'textId') :)
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $text := synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader//tei:sourceDesc[@xml:id = $textId]]
  let $item := $text//tei:div[@xml:id = $itemId]
  let $meta := map{
    'title' : if ($textId = 'gdpBrice1684') 
      then $item/tei:p/tei:label/node() 
      else $item/tei:head/node(),
    'quantity' : getQuantity($item, 'item disponible', 'items disponibles'), (: @todo internationalize :)
    'author' : getAuthors($text, $lang),
    'copyright'  : getCopyright($text, $lang),
    'description' : getDescription($text, $lang),
    'keywords' : getKeywords($text, $lang)
    }
  let $uuid := $item/@xml:id
  let $content := 
  map {
    'title' : if ($textId = 'gdpBrice1684') 
      then $item/tei:p/tei:label/node() 
      else $item/tei:head/node(),
    'rubrique' : 'Item',
    'date' : getDate($item, $dateFormat),
    'author' : getAuthors($item, $lang),
    'abstract' : getAbstract($item, $lang),
    'tei' : $item,
    'path' : '/items/',
    'uuid' : $uuid,
    'url' : $gdp.globals:root || '/items/' || $uuid,
    'itemBeforeTitle' : if ($textId = 'gdpBrice1684') 
      then getItemBefore($item, $lang)/tei:p/tei:label/node() 
      else getItemBefore($item, $lang)/tei:head/node(),
    'itemBeforeUrl' : getUrl(getItemBefore($item, $lang)/@xml:id, '/items/', $lang),
    'itemAfterTitle' : if ($textId = 'gdpBrice1684') 
      then getItemAfter($item, $lang)/tei:p/tei:label/node()
      else getItemAfter($item, $lang)/tei:head/node(),
    'itemAfterUrl' : getUrl(getItemAfter($item, $lang)/@xml:id, '/items/', $lang)
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the texts list
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 :)
declare function getModel($queryParams) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $model := synopsx.models.synopsx:getDb($queryParams)//tei:TEI
  let $meta := map{
    'title' : 'Schéma ODD', 
    'author' : getAuthors($model, $lang),
    'copyright' : getCopyright($model, $lang),
    'description' : getDescription($model, $lang),
    'keywords' : getKeywords($model, $lang)
    }
  let $content := map {
    'title' : getTitles($model, $lang),
    'date' : getDate($model, $dateFormat),
    'author' : getAuthors($model, $lang),
    'abstract' : getAbstract($model, $lang),
    'tei' : $model
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : ~:~:~:~:~:~:~:~:~
 : tei biblio
 : ~:~:~:~:~:~:~:~:~
 :)

(:~
 : this function get the bibliographical works list
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 :)
declare function getBibliographicalWorksList($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $bibliography := synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id='gdpBibliography']]
  let $bibliographicalWorks := $bibliography//tei:bibl[@type='work']
  let $meta := map{
    'title' : 'Liste des œuvres', 
    'quantity' : getQuantity($bibliographicalWorks, 'œuvre', 'œuvres'),
    'copyright' : getCopyright($bibliography, $lang),
    'description' : 'Liste des œuvres de la bibliographie des Guides de Paris, au sens des FRBR',
    'keywords' : getKeywords($bibliography, $lang),
    'url' : $gdp.globals:root || '/bibliography/works'
    }
  let $content := 
    for $bibliographicalWork in $bibliographicalWorks 
    let $uuid := $bibliographicalWork/@xml:id
    return map {
    'header' : 'Œuvre',
    'authors' : getBiblAuthors($bibliographicalWork, $lang),
    'titles' : getBiblTitles($bibliographicalWork, $lang),
    'tei' : $bibliographicalWork,
    'expressions' : getBiblExpressions($bibliographicalWork, $lang),
    'manifestations' : getBiblManifestations($bibliographicalWork, $lang),
    'uuid' : $uuid,
    'path' : '/bibliography/works/',
    'url' : $gdp.globals:root || '/bibliography/works/' || $uuid
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};
 
(:~
 : this function get the bibliographical work by ID
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 : @todo clean the meta
 :)
declare function getBibliographicalWork($queryParams as map(*)) as map(*) {
  let $workId := map:get($queryParams, 'workId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $bibliography := synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id='gdpBibliography']]
  let $bibliographicalWork := $bibliography//tei:bibl[@xml:id = $workId ]
  let $meta := map{
    'title' : 'Œuvre', 
    'author' : getAuthors($bibliography, $lang),
    'copyright' : getCopyright($bibliography, $lang),
    'description' : $bibliographicalWork,
    'keywords' : getKeywords($bibliography, $lang),
    'url' : getUrl($bibliographicalWork/@xml:id, '/bibliography/works/', $lang) 
    }
  let $uuid := $bibliographicalWork/@xml:id
  let $content := map {
    'header' : 'Œuvre',
    'authors' : getBiblAuthors($bibliographicalWork, $lang),
    'titles' : getBiblTitles($bibliographicalWork, $lang),
    'expressions' : getBiblExpressions($bibliographicalWork, $lang),
    'manifestations' : getBiblManifestations($bibliographicalWork, $lang),
    'tei' : $bibliographicalWork,
    'uuid' : $uuid,
    'path' : '/bibliography/works/',
    'url' : $gdp.globals:root || '/bibliography/works/' || $uuid
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the bibliographical expressions list
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 : @todo check why double title elements
 :)
declare function getBibliographicalExpressionsList($queryParams) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $bibliography := synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id='gdpBibliography']]
  let $bibliographicalExpressions := $bibliography//tei:biblStruct[@type='expression']
  let $meta := map{
    'title' : 'Liste des expressions',
    'quantity' : getQuantity($bibliographicalExpressions, 'expression', 'expressions'),
    'author' : getAuthors($bibliography, $lang),
    'copyright' : getCopyright($bibliography, $lang),
    'description' : 'Liste des expressions de la bibliographie des Guides de Paris, au sens des FRBR',
    'keywords' : getKeywords($bibliography, $lang),
    'url' : $gdp.globals:root || '/bibliography/expressions'
    }
  let $content := 
    for $bibliographicalExpression in $bibliographicalExpressions 
    let $uuid := $bibliographicalExpression/@xml:id
    return map {
    'header' : 'Expression',
    'authors' : getBiblAuthors($bibliographicalExpression, $lang),
    'titles' : getBiblTitles($bibliographicalExpression, $lang),
    'dates' : getBiblDates($bibliographicalExpression, $dateFormat),
    'manifestations' : getBiblManifestations($bibliographicalExpression, $lang),
    'tei' : $bibliographicalExpression,
    'uuid' : $uuid,
    'path' : '/bibliography/expressions/',
    'url' : $gdp.globals:root || '/bibliography/expressions/' || $uuid
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the bibliographical expression by ID
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 :)
declare function getBibliographicalExpression($queryParams) {
  let $bibliographicalExpressionId := map:get($queryParams, 'expressionId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $bibliography := synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id='gdpBibliography']]
  let $bibliographicalExpression := $bibliography//tei:biblStruct[@xml:id = $bibliographicalExpressionId]
  let $meta := map{
    'title' : 'Expression',
    'author' : getAuthors($bibliography, $lang),
    'copyright' : getCopyright($bibliography, $lang),
    'description' : $bibliographicalExpression,
    'keywords' : getKeywords($bibliography, $lang),
    'url' : getUrl($bibliographicalExpression/@xml:id, '/bibliography/expressions/', $lang) 
    }
  let $uuid := $bibliographicalExpression/@xml:id
  let $content := map {
    'header' : 'Expression',
    'authors' : getBiblAuthors($bibliographicalExpression, $lang),
    'titles' : getBiblTitles($bibliographicalExpression, $lang),
    'dates' : getDate($bibliographicalExpression, $dateFormat),
    'tei' : $bibliographicalExpression,
    'uuid' : $uuid,
    'path' : '/bibliography/expressions/',
    'url' : $gdp.globals:root || '/bibliography/expressions/' || $uuid
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the bibliographical manifestation list
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 :)
declare function getBibliographicalManifestationsList($queryParams) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $bibliography := synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id='gdpBibliography']]
  let $bibliographicalManifestations := $bibliography//tei:biblStruct[@type='manifestation']
  let $meta := map{
    'title' : 'Liste des manifestations',
    'quantity' : getQuantity($bibliographicalManifestations, 'manifestation', 'manifestations'),
    'author' : getAuthors($bibliography, $lang),
    'copyright' : getCopyright($bibliography, $lang),
    'description' : 'Liste des manifestations de la bibliographie des Guides de Paris, au sens des FRBR',
    'keywords' : getKeywords($bibliography, $lang),
    'url' : $gdp.globals:root || '/bibliography/manifestations'
    }
  let $content := 
    for $bibliographicalManifestation in $bibliographicalManifestations 
    let $uuid := $bibliographicalManifestation/@xml:id
    return map {
    'header' : 'Manifestation',
    'authors' : getBiblAuthors($bibliographicalManifestation, $lang),
    'titles' : getBiblTitles($bibliographicalManifestation, $lang),
    'dates' : getBiblDates($bibliographicalManifestation, $dateFormat),
    'tei' : $bibliographicalManifestation,
    'uuid' : $uuid,
    'path' : '/bibliography/manifestations/',
    'url' : $gdp.globals:root || '/bibliography/manifestations/' || $uuid
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the bibliographical manifestation by ID
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 : @bug doesnt bring authors, url properly
 :)
declare function getBibliographicalManifestation($queryParams) {
  let $bibliographicalManifestationId := map:get($queryParams, 'manifestationId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $bibliography := synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id='gdpBibliography']]
  let $bibliographicalManifestation := $bibliography//tei:biblStruct[@type='manifestation'][@xml:id = $bibliographicalManifestationId]
  let $meta := map{
    'title' : 'Manifestation',
    'author' : getAuthors($bibliography, $lang),
    (: 'copyright' : getCopyright($bibliography, $lang), :)
    'description' : $bibliographicalManifestation,
    'keywords' : getKeywords($bibliography, $lang),
    'url' : getUrl($bibliographicalManifestation/@xml:id, '/bibliography/manifestations/', $lang)
    }
  let $uuid := $bibliographicalManifestation/@xml:id
  let $content := map {
    'authors' : getBiblAuthors($bibliographicalManifestation, $lang),
    'titles' : getBiblTitles($bibliographicalManifestation, $lang),
    'dates' : getBiblDates($bibliographicalManifestation, $dateFormat),
    'tei' : $bibliographicalManifestation,
    'uuid' : $uuid,
    'path' : '/bibliography/manifestations/',
    'url' : $gdp.globals:root || '/bibliography/manifestations/' || $uuid
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the bibliographical item list
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 :)
declare function getBibliographicalItemsList($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $bibliography := synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id='gdpBibliography']]
  let $bibliographicalItems := $bibliography//tei:biblStruct[@type='item']
  let $meta := map{
    'title' : 'Liste des items bibliographiques', 
    'quantity' : getQuantity($bibliographicalItems, 'item', 'items'),
    'author' : getAuthors($bibliography, $lang),
    'copyright' : getCopyright($bibliography, $lang),
    'description' : getDescription($bibliography, $lang),
    'keywords' : getKeywords($bibliography, $lang),
    'url' : $gdp.globals:root || '/bibliography/items'
    }
  let $content := 
    for $bibliographicalItem in $bibliographicalItems 
    let $uuid := $bibliographicalItem/@xml:id
    return map {
    'header' : 'Item bibliographique',
    'authors' : getBiblAuthors($bibliographicalItem, $lang),
    'titles' : getBiblTitles($bibliographicalItem, $lang),
    'dates' : getBiblDates($bibliographicalItem, $dateFormat),
    'tei' : $bibliographicalItem,
    'uuid' : $uuid,
    'path' : '/bibliography/items/',
    'url' : $gdp.globals:root || '/bibliography/items/' || $uuid
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};
 
(:~
 : this function get the bibliographical item by ID
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 :)
declare function getBibliographicalItem($queryParams as map(*)) as map(*) {
  let $bibliographicalItemId := map:get($queryParams, 'itemId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $bibliography := synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id='gdpBibliography']]
  let $bibliographicalItem := $bibliography//tei:biblStruct[@type='item'][@xml:id=$bibliographicalItemId]
  let $meta := map{
    'title' : 'Item bibliographique',
    'author' : getAuthors($bibliographicalItem, $lang),
    'copyright' : getCopyright($bibliographicalItem, $lang),
    'description' : getDescription($bibliographicalItem, $lang),
    'keywords' : getKeywords($bibliographicalItem, $lang)
    }
  let $uuid := $bibliographicalItem/@xml:id
  let $content := map {
    'authors' : getBiblAuthors($bibliographicalItem, $lang),
    'titles' : getBiblTitles($bibliographicalItem, $lang),
    'dates' : getDate($bibliographicalItem, $dateFormat),   
    'tei' : $bibliographicalItem,
    'uuid' : $uuid,
    'path' : '/bibliography/items/',
    'url' : $gdp.globals:root || '/bibliography/items/' || $uuid
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the search results
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 : @todo deal with sections levels
 : @todo add a synopsx getIndexDb function
 : @todo search on head
 :)
declare function getSearch($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $referer := map:get($queryParams, 'referer')
  let $search := map:get($queryParams, 'search')
  let $start := map:get($queryParams, 'start')
  let $count := map:get($queryParams, 'count')
  let $data := db:open('gdpFtIndex')//tei:div[@type="section" or @type="item"]/tei:p
  let $results := if ($search != "") 
    then 
      for $result score $s in $data[text() contains text {$search}
        all words 
        using case insensitive
        using diacritics insensitive
        using stemming
        using fuzzy
        ordered distance at most 5 words]
      order by $s descending
      let $textId := getTextId($result)
      let $uuid := $result/parent::*/@xml:id
      let $segment := synopsx.models.synopsx:getDb($queryParams)//*[@xml:id=$uuid]
      return map {
        'title' : if ($textId = 'gdpBrice1684')
          then $segment/tei:label/node()
          else $segment/tei:head/node(),
        'extract' : ft:extract($result[text() contains text {$search}]),
        'textId' : $textId,
        'uuid' : $uuid,
        'path' : '/items/',
        'url' : $gdp.globals:root || '/items/' || $uuid
        }
    else ()
  let $meta := map{
    'title' : 'Résultats de la recherche',
    'author' : 'Guides de Paris',
    'referer' : $referer,
    'search' : $search,
    'start' : $start,
    'count' : $count,
    'quantity' : if (fn:count($results)) then getQuantity($results, 'résultat', 'résultats') else 'pas de résultats'
    }
  let $content := fn:subsequence($results, $start, $count)
    
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the index list
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 :)
declare function getIndexList($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $data := (synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc/@xml:id = 'gdpIndexNominum'], synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc/@xml:id = 'gdpIndexLocorum'], synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc/@xml:id = 'gdpIndexOperum'])
  let $meta := map{
    'title' : 'Liste des index',
    'author' : 'Guides de Paris',
    'quantity' : getQuantity($data, 'index', 'index')
    }
  let $content := 
    for $entry in $data
    let $uuid := fn:substring-after($entry//tei:fileDesc/tei:sourceDesc/@xml:id, 'gdpI')
    return map {
      'title' : $entry//tei:fileDesc/tei:titleStmt/tei:title,
      'uuid' : $uuid,
      'path' : '/index',
      'url' : $gdp.globals:root || '/index' || $uuid
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the index locorum
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 :)
declare function getIndexLocorum($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $data := synopsx.models.synopsx:getDb($queryParams)//tei:listPlace/tei:place
  let $meta := map{
    'title' : 'Index des lieux',
    'author' : 'Guides de Paris',
    'quantity' : getQuantity($data, 'entrée', 'entrées')
    }
  let $content := 
    for $entry in $data
    let $uuid := $entry/@xml:id
    return map {
      'title' : $entry/tei:placeName,
      'type' : $entry/tei:trait,
      'country' : $entry/tei:country,
      'district' : $entry/tei:district,
      'geo' : $entry/tei:location/tei:geo,
      'uuid' : $uuid,
      'path' : '/indexLocorum/',
      'url' : $gdp.globals:root || $uuid
      }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the index locorum item
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 :)
declare function getIndexLocorumItem($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $itemId := map:get($queryParams, 'itemId')
  let $entry := synopsx.models.synopsx:getDb($queryParams)//tei:place[@xml:id = $itemId]
  let $meta := map{
    'rubrique' : 'Index des lieux',
    'author' : 'Guides de Paris',
    'quantity' : getQuantity($entry, 'occurence', 'occurences')
    }
  let $uuid := $entry/@xml:id
  let $content :=
    map {
      'rubrique' : 'Index des lieux',
      'title' : $entry/tei:placeName,
      'type' : $entry/tei:trait,
      'country' : $entry/tei:country,
      'district' : $entry/tei:district,
      'geo' : $entry/tei:location/tei:geo,
      'note' : $entry/tei:note,
      'uuid' : $uuid,
      'path' : '/indexLocorum/',
      'url' : $gdp.globals:root || '/indexLocorum/' || $uuid,
      'occurences' : '@todo'
      }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the index nominum
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 :)
declare function getIndexNominum($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $search := map:get($queryParams, 'search')
  let $data := synopsx.models.synopsx:getDb($queryParams)//tei:listPerson/tei:person
  let $meta := map{
    'title' : 'Index des personnes',
    'author' : 'Guides de Paris',
    'quantity' : getQuantity($data, 'entrée', 'entrées')
    }
  let $content := 
    for $entry in $data
    let $uuid := $entry/@xml:id
    return map {
      'title' : $entry/tei:persName[1],
      'forename' : $entry/tei:persName/tei:forename,
      'surname' : $entry/tei:persName/tei:surname,
      'birth' : $entry/tei:birth/tei:date,
      'death' : $entry/tei:death/tei:date,
      'occupation' : $entry/tei:occupation,
      'uuid' : $uuid,
      'path' : '/indexNominum/',
      'url' : $gdp.globals:root || '/indexNominum/' || $uuid
      }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the index nominum item
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 : @todo deal with dates according to the serialization
 :)
declare function getIndexNominumItem($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $itemId := map:get($queryParams, 'itemId')
  let $entry := synopsx.models.synopsx:getDb($queryParams)//tei:person[@xml:id = $itemId]
  let $meta := map{
    'rubrique' : 'Index des personnes',
    'author' : 'Guides de Paris',
    'quantity' : getQuantity($entry, 'occurence', 'occurences')
    }
  let $uuid := $entry/@xml:id
  let $content :=
    map {
      'rubrique' : 'Index des personnes',
      'title' : $entry/tei:persName[1],
      'forename' : $entry/tei:persName/tei:forename,
      'surname' : $entry/tei:persName/tei:surname,
      'birthDate' : $entry/tei:birth/tei:date,
      'birthPlace' : $entry/tei:birth/tei:placeName,
      'death' : $entry/tei:death/tei:date,
      'deathPlace' : $entry/tei:death/tei:placeName,
      'occupation' : $entry/tei:occupation,
      'autBnf' : $entry/tei:idno[@type="autBnf"],
      'isni' : $entry/tei:idno[@type="isni"],
      'wikidata' : $entry/tei:idno[@type="wikidata"],
      'uuid' : $uuid,
      'path' : '/indexNominum/',
      'url' : $gdp.globals:root || '/indexNominum/' || $uuid,
      'attestedForms' : fn:distinct-values(db:open('gdp')//tei:persName[@ref=$uuid]),
      'occurences' : '@todo collection',
      'relations' : '@todo collection'
      }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the index operum
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content
 : @todo deal with dates according to the serialization
 :)
declare function getIndexOperum($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $data := synopsx.models.synopsx:getDb($queryParams)//tei:listObject/tei:object
  let $meta := map{
    'title' : 'Index des œuvres',
    'author' : 'Guides de Paris',
    'quantity' : getQuantity($data, 'entrée', 'entrées')
    }
  let $content := 
    for $entry in $data
    let $uuid := $entry/@xml:id
    return map {
      'title' : $entry/tei:objectName,
      'type' : $entry/tei:label,
      'date' : $entry/tei:date,
      'uuid' : $uuid,
      'path' : '/indexOperum/',
      'url' : $gdp.globals:root || '/indexOperum/' || $uuid
      }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the index operum item
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map for meta and content for meta and content
 : @todo deal with dates according to the serialization
 :)
declare function getIndexOperumItem($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $itemId := map:get($queryParams, 'itemId')
  let $entry := synopsx.models.synopsx:getDb($queryParams)//tei:object[@xml:id = $itemId]
  let $occurences := $entry/tei:relation[@type="locus"]
  let $meta := map{
    'rubrique' : 'Index des œuvres',
    'author' : 'Guides de Paris',
    'title' : $entry/tei:objectName,
    'type' : $entry/tei:label,
    'date' : $entry/tei:date,
    'desc' : $entry/tei:desc,
    'quantity' : getQuantity($occurences, 'occurence', 'occurences')
    }
  let $content := 
    for $occurence in $occurences 
    let $uuid := fn:substring-after($occurence/@ref, '#')
    let $text := synopsx.models.synopsx:getDb($queryParams)//*[@xml:id= $uuid]
    return map {
      'rubrique' : 'occurence',
      'title' : $text/ancestor::tei:div[1]/tei:head/node(),
      'ref' : getRef($text/ancestor::tei:TEI),
      'author' : getAuthors($text, $lang),
      'uuid' : $uuid,
      'path' : '/items/',
      'url' : $gdp.globals:root || '/items/' || $uuid
      }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};