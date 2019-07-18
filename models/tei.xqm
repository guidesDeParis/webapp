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
declare function getBlogHome($queryParams as map(*)) as map(*) {
  let $posts := synopsx.models.synopsx:getDb($queryParams)//tei:TEI
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $meta := map{
    'title' : 'Home page du blog', 
    'quantity' : getQuantity($posts, 'expression', 'expressions'),
    'author' : getBlogAuthors($posts, $lang),
    'copyright' : getCopyright($posts, $lang),
    'description' : getDescription($posts, $lang),
    'keywords' : getKeywords($posts, $lang) 
    }
  let $content := for $post in $posts return map {
    'title' : getTitle($post, $lang),
    'subtitle' : getSubtitle($post, $lang),
    'date' : getDate($post, $dateFormat),
    'author' : getBlogAuthors($post, $lang),
    'abstract' : getAbstract($post, $lang),
    'tei' : $post
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the blog posts list
 :
 : @param $queryParams the request params sent by restxq
 : @return a map with meta and content
 :)
declare function getBlogPosts($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $posts := synopsx.models.synopsx:getDb($queryParams)//tei:TEI
  let $meta := map{
    'title' : 'Liste des articles de blog', 
    'quantity' : getQuantity($posts, 'article de blog', 'articles de blogs'),
    'author' : getBlogAuthors($posts, $lang),
    'copyright' : getCopyright($posts, $lang),
    'description' : getDescription($posts, $lang),
    'keywords' : getKeywords($posts, $lang)
    }
  let $content := for $post in $posts return map {
    'rubrique' : 'Article de blog',
    'title' : getTitle($post, $lang),
    'subtitle' : getSubtitle($post, $lang),
    'date' : getDate($post, $dateFormat),
    'author' : getBlogAuthors($post, $lang),
    'abstract' : getAbstract($post, $lang),
    'url' : getUrl($post//tei:sourceDesc/@xml:id, '/blog/posts/', $lang),
    'tei' : $post
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
 :)
declare function getBlogItem($queryParams as map(*)) {
  let $entryId := map:get($queryParams, 'entryId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $article := synopsx.models.synopsx:getDb($queryParams)/tei:teiCorpus/tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id=$entryId]]
  let $meta := map{
    'title' : getTitles($article, $lang),
    'author' : getBlogAuthors($article, $lang),
    'copyright' : getCopyright($article, $lang),
    'description' : getDescription($article, $lang),
    'keywords' : getKeywords($article, $lang)
    }
  let $content := for $item in $article return map {
    'rubrique' : 'Article de blog',
    'title' : getTitles($item, $lang),
    'subtitle' : getSubtitle($item, $lang),
    'date' : getDate($item, $dateFormat),
    'author' : getBlogAuthors($item, $lang),
    'abstract' : getAbstract($item, $lang),
    'tei' : $item,
    'itemBeforeTitle' : getTitles(getBlogItemBefore($queryParams, $item, $lang), $lang),
    'itemBeforeUrl' : getUrl(getBlogItemBefore($queryParams, $item, $lang)//tei:sourceDesc/@xml:id, '/blog/posts/', $lang),
    'itemAfterTitle' : getTitles(getBlogItemAfter($queryParams, $item, $lang), $lang),
    'itemAfterUrl' : getUrl(getBlogItemAfter($queryParams, $item, $lang)//tei:sourceDesc/@xml:id, '/blog/posts/', $lang)
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
 : this function get the à propos page
 :
 : @param $queryParams the request params sent by restxq 
 : @return a map with meta and content
 :)
declare function getAbout($queryParams as map(*)) as map(*) {
  let $entryId := map:get($queryParams, 'entryId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $article := synopsx.models.synopsx:getDb($queryParams)/tei:TEI[//tei:sourceDesc[@xml:id=$entryId]]
  let $meta := map{
    'title' : getTitle($article, $lang), 
    'subtitle' : getSubtitle($article, $lang), 
    'author' : getAuthors($article, $lang),
    'copyright' : getCopyright($article, $lang),
    'description' : getDescription($article, $lang),
    'keywords' : getKeywords($article, $lang)
    }
  let $content := for $item in $article return map {
    'title' : getTitles($item, $lang),
    'subtitle' : getSubtitle($item, $lang),
    'date' : getDate($item, $dateFormat),
    'author' : getAuthors($item, $lang),
    'abstract' : getAbstract($item, $lang),
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
    'keywords' : getKeywords($corpora, $lang)
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
    'quantity' : getQuantity($corpora/tei:teiCorpus, 'corpus disponible', 'corpora disponibles'), (: @todo internationalize :)
    'author' : getAuthors($corpora, $lang),
    'copyright'  : getCopyright($corpora, $lang),
    'description' : getDescription($corpora, $lang),
    'keywords' : getKeywords($corpora, $lang),
    'tei' : $corpora/tei:teiHeader
    }
  let $content := for $corpus at $count in $corpora/tei:teiCorpus return map {
    'title' : getTitles($corpus, $lang),
    'date' : getEditionDates(getOtherEditions(getRef($corpus))/tei:biblStruct, $dateFormat),
    'author' : getAuthors($corpus, $lang),
    'abstract' : getAbstract($corpus, $lang),
    'editionsQuantity' : getQuantity(getOtherEditions(getRef($corpus))/tei:biblStruct, 'édition', ' éditions'),
    'textsQuantity' : getQuantity($corpus//tei:TEI, 'texte disponible', 'textes disponibles'),
    'url' : getUrl($corpus/tei:teiHeader//tei:sourceDesc/@xml:id, '/gdp/corpus/', $lang),
    'tei' : $corpus,
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
  let $content := for $text in $corpus/tei:TEI return map {
    'title' : getTitles($text, $lang),
    'date' : getEditionDates(getOtherEditions(getRef($text))/tei:biblStruct, $dateFormat),
    'author' : getAuthors($text, $lang),
    'biblio' : getRef($text)/tei:monogr,
    'abstract' : getAbstract($text, $lang),
    'format' : getRef($text)//tei:dim[@type = 'format'],
    'itemsNb' : fn:count($corpus/tei:TEI//tei:div[@type = 'item' and @xml:id]),
    'weight' : getStringLength($text),
    'tei' : $text,
    'url' : getUrl($text/tei:teiHeader//tei:sourceDesc/@xml:id, '/gdp/texts/', $lang),
    'otherEditions' : fn:count(getOtherEditions(getRef($text))/tei:biblStruct)
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
 : @return a map of two map
 :)
declare function getTextsList($queryParams) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $texts := synopsx.models.synopsx:getDb($queryParams)//tei:TEI/tei:teiHeader
  let $meta := map{
    'title' : 'Liste des textes', 
    'author' : getAuthors($texts, $lang),
    'copyright' : getCopyright($texts, $lang),
    'description' : getDescription($texts, $lang),
    'keywords' : getKeywords($texts, $lang)
    }
  let $content := for $text in $texts return map {
    'title' : getTitles($text, $lang),
    'date' : getDate($text, $dateFormat),
    'author' : getAuthors($text, $lang),
    'abstract' : getAbstract($text, $lang),
    'biblio' : getRef($text),
    'tei' : $text
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
  let $content := for $item in $text//tei:div[(@type = 'item' and @xml:id) or (@type = 'section' and @xml:id ) or (@type = 'chapter' and @xml:id )] return map {
    'title' : if ($item/tei:head[1]) then $item/tei:head[1] else $item/tei:p/tei:label[1] ,
    'date' : getDate($item, $dateFormat),
    'author' : getAuthors($item, $lang),
    'abstract' : getAbstract($item, $lang),
    'tei' : $item,
    'url' : getUrl(if ($item/@xml:id) then $item/@xml:id else 'toto' , '/gdp/items/', $lang)   
    }
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
  let $text := (synopsx.models.synopsx:getDb($queryParams)//tei:TEI[tei:teiHeader//tei:sourceDesc[@xml:id = $textId]])[1]
  let $item := $text//tei:div[@xml:id = $itemId]
  let $meta := map{
    'title' : if ($textId = 'gdpBrice1684') 
      then $item/tei:p[1]/tei:label 
      else $item/tei:head[1],
    'quantity' : getQuantity($item, 'item disponible', 'items disponibles'), (: @todo internationalize :)
    'author' : getAuthors($text, $lang),
    'copyright'  : getCopyright($text, $lang),
    'description' : getDescription($text, $lang),
    'keywords' : getKeywords($text, $lang)
    }
  let $content := map {
    'title' : if ($textId = 'gdpBrice1684') 
      then $item/tei:p[1]/tei:label 
      else $item/tei:head[1],
    'rubrique' : 'Item',
    'date' : getDate($item, $dateFormat),
    'author' : getAuthors($item, $lang),
    'abstract' : getAbstract($item, $lang),
    'tei' : $item,
    'url' : getUrl($item/@xml:id, '/gdp/items/', $lang),
    'itemBeforeTitle' : if ($textId = 'gdpBrice1684') 
      then getItemBefore($item, $lang)/tei:p[1]/tei:label 
      else getItemBefore($item, $lang)/tei:head[1],
    'itemBeforeUrl' : getUrl(getItemBefore($item, $lang)/@xml:id, '/gdp/items/', $lang),
    'itemAfterTitle' : if ($textId = 'gdpBrice1684') 
      then getItemAfter($item, $lang)/tei:p[1]/tei:label 
      else getItemAfter($item, $lang)/tei:head[1],
    'itemAfterUrl' : getUrl(getItemAfter($item, $lang)/@xml:id, '/gdp/items/', $lang)
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
 : @return a map of two map
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
 : @return a map of two map
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
    'url' : $gdp.globals:root || '/gdp/bibliography/works'
    }
  let $content := for $bibliographicalWork in $bibliographicalWorks return map {
    'header' : 'Œuvre',
    'authors' : getBiblAuthors($bibliographicalWork, $lang),
    'titles' : getBiblTitles($bibliographicalWork, $lang),
    'tei' : $bibliographicalWork,
    'expressions' : getBiblExpressions($bibliographicalWork, $lang),
    'manifestations' : getBiblManifestations($bibliographicalWork, $lang),
    'url' : getUrl($bibliographicalWork/@xml:id, '/gdp/bibliography/works/', $lang)
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
 : @return a map of two map
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
    'url' : getUrl($bibliographicalWork/@xml:id, '/gdp/bibliography/works/', $lang) 
    }
  let $content := map {
    'header' : 'Œuvre',
    'authors' : getBiblAuthors($bibliographicalWork, $lang),
    'titles' : getBiblTitles($bibliographicalWork, $lang),
    'expressions' : getBiblExpressions($bibliographicalWork, $lang),
    'manifestations' : getBiblManifestations($bibliographicalWork, $lang),
    'tei' : $bibliographicalWork,
    'url' : getUrl($bibliographicalWork/@xml:id, '/gdp/bibliography/works/', $lang)
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
 : @return a map of two map
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
    'url' : $gdp.globals:root || '/gdp/bibliography/expressions'
    }
  let $content := for $bibliographicalExpression in $bibliographicalExpressions return map {
    'header' : 'Expression',
    'authors' : getBiblAuthors($bibliographicalExpression, $lang),
    'titles' : getBiblTitles($bibliographicalExpression, $lang),
    'dates' : getBiblDates($bibliographicalExpression, $dateFormat),
    'manifestations' : getBiblManifestations($bibliographicalExpression, $lang),
    'tei' : $bibliographicalExpression,
    'url' : getUrl($bibliographicalExpression/@xml:id, '/gdp/bibliography/expressions/', $lang)
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
 : @return a map of two map
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
    'url' : getUrl($bibliographicalExpression/@xml:id, '/gdp/bibliography/expressions/', $lang) 
    }
  let $content := map {
    'header' : 'Expression',
    'authors' : getBiblAuthors($bibliographicalExpression, $lang),
    'titles' : getBiblTitles($bibliographicalExpression, $lang),
    'dates' : getDate($bibliographicalExpression, $dateFormat),
    'tei' : $bibliographicalExpression,
    'url' : getUrl($bibliographicalExpression/@xml:id, '/gdp/bibliography/expressions/', $lang)
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
 : @return a map of two map
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
    'url' : $gdp.globals:root || 'gdp/bibliography/manifestations'
    }
  let $content := for $bibliographicalManifestation in $bibliographicalManifestations return map {
    'header' : 'Manifestation',
    'authors' : getBiblAuthors($bibliographicalManifestation, $lang),
    'titles' : getBiblTitles($bibliographicalManifestation, $lang),
    'dates' : getBiblDates($bibliographicalManifestation, $dateFormat),
    'tei' : $bibliographicalManifestation,
    'url' : getUrl($bibliographicalManifestation/@xml:id, '/gdp/bibliography/manifestations/', $lang)
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
 : @return a map of two map
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
    'url' : getUrl($bibliographicalManifestation/@xml:id, '/gdp/bibliography/manifestations/', $lang)
    }
  let $content := map {
    'authors' : getBiblAuthors($bibliographicalManifestation, $lang),
    'titles' : getBiblTitles($bibliographicalManifestation, $lang),
    'dates' : getBiblDates($bibliographicalManifestation, $dateFormat),
    'tei' : $bibliographicalManifestation,
    'url' : getUrl($bibliographicalManifestation/@xml:id, '/gdp/bibliography/manifestations/', $lang)
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
 : @return a map of two map
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
    'url' : $gdp.globals:root || 'gdp/bibliography/items'
    }
  let $content := for $bibliographicalItem in $bibliographicalItems return map {
    'header' : 'Item bibliographique',
    'authors' : getBiblAuthors($bibliographicalItem, $lang),
    'titles' : getBiblTitles($bibliographicalItem, $lang),
    'dates' : getBiblDates($bibliographicalItem, $dateFormat),
    'tei' : $bibliographicalItem,
    'url' : getUrl($bibliographicalItem/@xml:id, '/gdp/bibliography/items/', $lang)
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
 : @return a map of two map
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
    'keywords' : getKeywords($bibliographicalItem, $lang), 
    'url' : getUrl($bibliographicalItem/@xml:id, '/gdp/bibliography/items/', $lang)
    }
  let $content := map {
    'authors' : getBiblAuthors($bibliographicalItem, $lang),
    'titles' : getBiblTitles($bibliographicalItem, $lang),
    'dates' : getDate($bibliographicalItem, $dateFormat),   
    'tei' : $bibliographicalItem,
    'url' : getUrl($bibliographicalItem/@xml:id, '/gdp/bibliography/items/', $lang)
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
 : @return a map of two map
 :)
declare function getSearch($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $search := map:get($queryParams, 'search')
  let $data := db:open('gdp')//tei:div[@type="section"]
  (: let $results := if ($search != "") 
    then (
      $data//tei:div[@type="section"]/text() contains text {$search} 
      all words 
      using case insensitive
      using diacritics insensitive
      ordered distance at most 5 words
      )
    else 'pas de résultats' :)
  let $meta := map{
    'title' : 'Résultats de la recherche',
    'author' : 'Guides de Paris',
    'quantity' : $search
    }
  let $content := 
    if ($search != "") 
    then 
      for $result in $data
      where $result[text() contains text {$search} 
        all words 
        using case insensitive
        using diacritics insensitive
        using stemming
        ordered distance at most 5 words]
      return map {
        'result' : $result
        }
    else map {
        'result' : 'pas de résultats'
      }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get the index list
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map
 :)
declare function getIndexList($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $search := map:get($queryParams, 'search')
  let $data := (db:open('gdp')//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc/@xml:id = 'gdpIndexNominum'], db:open('gdp')//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc/@xml:id = 'gdpIndexLocorum'], db:open('gdp')//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc/@xml:id = 'gdpIndexOperum'])
  let $meta := map{
    'title' : 'Liste des index',
    'author' : 'Guides de Paris',
    'quantity' : $search
    }
  let $content := for $entry in $data
    return map {
        'title' : $entry//tei:fileDesc/tei:titleStmt/tei:title,
        'url' : getUrl(fn:substring-after($entry//tei:fileDesc/tei:sourceDesc/@xml:id, 'gdpI'), '/gdp/i', $lang)
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
 : @return a map of two map
 :)
declare function getIndexLocorum($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $search := map:get($queryParams, 'search')
  let $data := db:open('gdp')//tei:listPlace/tei:place
  let $meta := map{
    'title' : 'Index locorum',
    'author' : 'Guides de Paris',
    'quantity' : $search
    }
  let $content := for $entry in $data
    return map {
        'title' : $entry/tei:placeName,
        'url' : getUrl($entry/@xml:id, '/gdp/indexLocorum/', $lang)
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
 : @return a map of two map
 :)
declare function getIndexLocorumItem($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $itemId := map:get($queryParams, 'itemId')
  let $entry := db:open('gdp')//tei:place[@xml:id = $itemId]
  let $meta := map{
    'rubrique' : 'Index locorum',
    'author' : 'Guides de Paris'
    }
  let $content :=
    map {
      'rubrique' : 'Index locorum',
      'title' : $entry/tei:placeName,
      'type' : $entry/tei:trait,
      'country' : $entry/tei:country,
      'district' : $entry/tei:district,
      'note' : $entry/tei:note,
      'url' : getUrl($entry/@xml:id, '/gdp/indexLocorum/', $lang),
      'occurences' : '' (: @todo :)
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
 : @return a map of two map
 :)
declare function getIndexNominum($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $search := map:get($queryParams, 'search')
  let $data := db:open('gdp')//tei:listPerson/tei:person
  let $meta := map{
    'title' : 'Index nominum',
    'author' : 'Guides de Paris',
    'quantity' : $search
    }
  let $content := for $entry in $data
    return map {
        'title' : $entry/tei:persName[1],
        'forename' : $entry/tei:persName/tei:forename,
        'surname' : $entry/tei:persName/tei:surname,
        'birth' : $entry/tei:birth/tei:date,
        'death' : $entry/tei:death/tei:date,
        'url' : getUrl($entry/@xml:id, '/gdp/indexNominum/', $lang)
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
 : @return a map of two map
 :)
declare function getIndexNominumItem($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $itemId := map:get($queryParams, 'itemId')
  let $entry := db:open('gdp')//tei:person[@xml:id = $itemId]
  let $meta := map{
    'rubrique' : 'Index nominum',
    'author' : 'Guides de Paris'
    }
  let $content :=
    map {
      'rubrique' : 'Index nominum',
      'title' : $entry/tei:persName[1],
      'forename' : $entry/tei:persName/tei:forename,
      'surname' : $entry/tei:persName/tei:surname,
      'birth' : $entry/tei:birth/tei:date,
      'death' : $entry/tei:death/tei:date,
      'url' : getUrl($entry/@xml:id, '/gdp/indexNominum/', $lang),
      'occurences' : '' (: @todo :)
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
 : @return a map of two map
 :)
declare function getIndexOperum($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $data := db:open('gdp')//tei:listObject/tei:object
  let $meta := map{
    'title' : 'Index operum',
    'author' : 'Guides de Paris'
    }
  let $content := for $entry in $data
    return map {
        'title' : $entry/tei:objectName,
        'url' : getUrl($entry/@xml:id, '/gdp/indexOperum/', $lang)
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
 : @return a map of two map
 :)
declare function getIndexOperumItem($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $itemId := map:get($queryParams, 'itemId')
  let $entry := db:open('gdp')//tei:object[@xml:id = $itemId]
  let $meta := map{
    'rubrique' : 'Index operum',
    'author' : 'Guides de Paris'
    }
  let $content :=
    map {
      'rubrique' : 'Index operum',
      'title' : $entry/tei:objectName,
      'type' : $entry/tei:label,
      'date' : $entry/tei:date,
      'desc' : $entry/tei:desc,
      'url' : getUrl($entry/@xml:id, '/gdp/indexOperum/', $lang),
      'occurences' : getUrl($entry/tei:relation[@type="locus"]/@ref, '/gdp/indexOperum/', $lang)
      }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};