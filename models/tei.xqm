xquery version "3.0" ;
module namespace gdp.models.tei = 'gdp.models.tei' ;

(:~
 : This module is a TEI models library for paris' guidebooks edition
 :
 : @author emchateau (Cluster Pasts in the Present)
 : @since 2014-11-10 
 : @version 0.2
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
 :)

import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../../../lib/commons.xqm' ;

import module 'gdp.models.tei' at 'teiContent.xqm' , 'teiBuilder.xqm' ;

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
  let $posts := synopsx.lib.commons:getDb($queryParams)//tei:TEI
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $meta := map{
    'title' : 'Home page du blog', 
    'quantity' : getQuantity($posts, 'expression', 'expressions'),
    'author' : getAuthors($posts, $lang),
    'copyright' : getCopyright($posts, $lang),
    'description' : getDescription($posts, $lang),
    'keywords' : getKeywords($posts, $lang) 
    }
  let $content := for $post in $posts return map {
    'title' : getTitle($post, $lang),
    'subtitle' : getSubtitle($post, $lang),
    'date' : getDate($post, $dateFormat),
    'author' : getAuthors($post, $lang),
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
  let $posts := synopsx.lib.commons:getDb($queryParams)//tei:TEI
  let $meta := map{
    'title' : 'Liste des articles de blog', 
    'quantity' : getQuantity($posts, 'article de blog', 'articles de blogs'),
    'author' : getAuthors($posts, $lang),
    'copyright' : getCopyright($posts, $lang),
    'description' : getDescription($posts, $lang),
    'keywords' : getKeywords($posts, $lang)
    }
  let $content := for $post in $posts return map {
    'rubrique' : 'Article de blog',
    'title' : getTitle($post, $lang),
    'subtitle' : getSubtitle($post, $lang),
    'date' : getDate($post, $dateFormat),
    'author' : getAuthors($post, $lang),
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
  let $article := synopsx.lib.commons:getDb($queryParams)/tei:TEI[//tei:sourceDesc[@xml:id=$entryId]]
  let $meta := map{
    'title' : getTitles($article, $lang),
    'author' : getAuthors($article, $lang),
    'copyright' : getCopyright($article, $lang),
    'description' : getDescription($article, $lang),
    'keywords' : getKeywords($article, $lang)
    }
  let $content := for $item in $article return map {
    'rubrique' : 'Article de blog',
    'title' : getTitle($item, $lang),
    'subtitle' : getSubtitle($item, $lang),
    'date' : getDate($item, $dateFormat),
    'author' : getAuthors($item, $lang),
    'abstract' : getAbstract($item, $lang),
    'tei' : $item,
    'itemBeforeTitle' : getTitles(getTextBefore($queryParams, $item, $lang), 'fr'),
    (: 'itemBeforeUrl' : getUrl(getTextBefore($queryParams, $item, $lang)/@xml:id, '/blog/', $lang), :)
    'itemAfterTitle' : getTitles(getTextAfter($queryParams, $item, $lang), 'fr')
    (: 'itemAfterUrl' : getUrl(getTextAfter($queryParams, $item, $lang)/@xml:id, '/blog/', $lang) :)
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
  let $article := synopsx.lib.commons:getDb($queryParams)/tei:TEI[//tei:sourceDesc[@xml:id=$entryId]]
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
  let $corpora := synopsx.lib.commons:getDb($queryParams)//tei:teiCorpus
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

(:~
 : this function get the corpus list
 :
 : @param $queryParams the request params sent by restxq 
 : @return a map with meta and content
 :)
declare function getCorpusList($queryParams as map(*)) as map(*) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $corpora := synopsx.lib.commons:getDb($queryParams)/tei:teiCorpus
  let $meta := map{
    'title' : 'Liste des corpus', 
    'quantity' : getQuantity($corpora/tei:teiCorpus, 'corpus disponible', 'corpora disponibles'), (: @todo internationalize :)
    'author' : getAuthors($corpora, $lang),
    'copyright'  : getCopyright($corpora, $lang),
    'description' : getDescription($corpora, $lang),
    'keywords' : (: getKeywords($corpora, $lang) :)
                 ('toto tata titi', 'titi, tata, toto', 'toto, titi, tata'),
    'tei' : $corpora/tei:teiHeader
    }
  let $content := for $corpus at $count in $corpora/tei:teiCorpus return map {
    'title' : getTitles($corpus, $lang),
    'date' : getEditionDates(getOtherEditions(getRef($corpus))/tei:biblStruct, $dateFormat),
    'author' : getAuthors($corpus, $lang),
    'abstract' : getAbstract($corpus, $lang),
    'editionsQuantity' : fn:count(getOtherEditions(getRef($corpus))/tei:biblStruct) || ' éditions',
    'textsQuantity' : getQuantity($corpus//tei:TEI, 'texte disponible', 'textes disponibles'),
    'url' : getUrl($corpus/tei:teiHeader//tei:sourceDesc/@xml:id, '/gdp/corpus/', $lang),
    'tei' : $corpus,
    'editions' : getOtherEditions(getRef($corpus))
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
  let $corpus := synopsx.lib.commons:getDb($queryParams)/tei:teiCorpus/tei:teiCorpus[tei:teiHeader//tei:sourceDesc[@xml:id = $corpusId]]
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
    'format' : getRef($text)//tei:dim[@type = 'format'],
    'itemsNb' : fn:string(fn:count($corpus/tei:TEI//tei:div[@type = 'item' and @xml:id])),
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
  let $texts := synopsx.lib.commons:getDb($queryParams)//tei:TEI/tei:teiHeader
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
declare function getTextById($queryParams as map(*)) as map(*) {
  let $textId := map:get($queryParams, 'textId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $text := synopsx.lib.commons:getDb($queryParams)//tei:TEI[tei:teiHeader//tei:sourceDesc[@xml:id = $textId]]
  let $meta := map{
    'title' : 'Liste des items disponibles', 
    'quantity' : getQuantity($text, 'manifestation disponibles', 'manifestations disponibles'), (: @todo internationalize :)
    'author' : getAuthors($text, $lang),
    'copyright'  : getCopyright($text, $lang),
    'description' : getDescription($text, $lang),
    'keywords' : getKeywords($text, $lang)
    }
  let $content := for $item in $text//tei:div[@type = 'item' and @xml:id] return map {
    'title' : $item/tei:head[1],
    'date' : getDate($item, $dateFormat),
    'author' : getAuthors($item, $lang),
    'abstract' : getAbstract($item, $lang),
    'tei' : $item,
    'url' : getUrl(if ($item/@xml:id) then $item/@xml:id else 'toto' , '/gdp/texts/' || $textId || '/', $lang)   
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
  let $textId := map:get($queryParams, 'textId')
  let $itemId := map:get($queryParams, 'itemId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $text := (synopsx.lib.commons:getDb($queryParams)//tei:TEI[tei:teiHeader//tei:sourceDesc[@xml:id = $textId]])[1]
  let $item := $text//tei:div[@xml:id = $itemId]
  let $meta := map{
    'title' : 'Item', 
    'quantity' : getQuantity($item, 'item disponible', 'items disponibles'), (: @todo internationalize :)
    'author' : getAuthors($item, $lang),
    'copyright'  : getCopyright($item, $lang),
    'description' : getDescription($item, $lang),
    'keywords' : getKeywords($item, $lang)
    }
  let $content := map {
    'title' : $item/tei:head[1],
    'rubrique' : 'Rubrique',
    'date' : getDate($item, $dateFormat),
    'author' : getAuthors($item, $lang),
    'abstract' : getAbstract($item, $lang),
    'tei' : $item,
    'url' : getUrl($item/@xml:id, '/gdp/texts/' || $textId || '/', $lang),
    'itemBeforeTitle' : (getItemBefore($item, $lang)/tei:head)[1],
    'itemBeforeUrl' : getUrl(getItemBefore($item, $lang)/@xml:id, '/gdp/texts/' || $textId || '/', $lang),
    'itemAfterTitle' : (getItemAfter($item, $lang)/tei:head)[1],
    'itemAfterUrl' : getUrl(getItemBefore($item, $lang)/@xml:id, '/gdp/texts/' || $textId || '/', $lang)
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
  let $model := synopsx.lib.commons:getDb($queryParams)//tei:TEI
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
  let $bibliographicalWorks := synopsx.lib.commons:getDb($queryParams)//tei:bibl[@type='work']
  let $meta := map{
    'title' : 'Liste des œuvres', 
    'quantity' : getQuantity($bibliographicalWorks, 'œuvre', 'œuvres'),
    'author' : getAuthors($bibliographicalWorks, $lang),
    'copyright' : getCopyright($bibliographicalWorks, $lang),
    'description' : getDescription($bibliographicalWorks, $lang),
    'keywords' : getKeywords($bibliographicalWorks, $lang) 
    }
  let $content := for $bibliographicalWork in $bibliographicalWorks return map {
    'title' : 'Œuvre',
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
 :)
declare function getBibliographicalWork($queryParams as map(*)) as map(*) {
  let $workId := map:get($queryParams, 'workId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $bibliographicalWork := (synopsx.lib.commons:getDb($queryParams)//tei:bibl[fn:string(@xml:id) = $workId ])[1]
  let $meta := map{
    'title' : 'Œuvre', 
    'author' : getAuthors($bibliographicalWork, $lang),
    'copyright' : getCopyright($bibliographicalWork, $lang),
    'description' : getDescription($bibliographicalWork, $lang),
    'keywords' : getKeywords($bibliographicalWork, $lang),
    'url' : getUrl($bibliographicalWork/@xml:id, '/gdp/bibliography/works/', $lang) 
    }
  let $content := map {
    'title' : 'Œuvre',
    'tei' : $bibliographicalWork,
    'url' : getUrl($bibliographicalWork/@xml:id, '/gdp/bibliography/works/', $lang),
    'expressions' : getBiblExpressions($bibliographicalWork, $lang),
    'expressionsUrl' : getBiblExpressions($bibliographicalWork, $lang),
    'manifestations' : getBiblManifestations($bibliographicalWork, $lang)
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
 :)
declare function getBibliographicalExpressionsList($queryParams) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $bibliographicalExpressions := synopsx.lib.commons:getDb($queryParams)//tei:biblStruct[@type='expression']
  let $meta := map{
    'title' : 'Liste des expressions'
    }
  let $content := for $bibliographicalExpression in $bibliographicalExpressions return map {
    'title' : getTitles($bibliographicalExpression, $lang),
    'date' : getDate($bibliographicalExpression, $dateFormat),
    'author' : getAuthors($bibliographicalExpression, $lang),
    'abstract' : getAbstract($bibliographicalExpression, $lang),
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
  let $bibliographicalExpression := synopsx.lib.commons:getDb($queryParams)//tei:biblStruct[@xml:id=$bibliographicalExpressionId]
  let $meta := map{
    'title' : 'Expression'
    }
  let $content := map {
    'title' : getTitles($bibliographicalExpression, $lang),
    'date' : getDate($bibliographicalExpression, $dateFormat),
    'author' : getAuthors($bibliographicalExpression, $lang),
    'abstract' : getAbstract($bibliographicalExpression, $lang),
    'tei' : $bibliographicalExpression,
    'url' : getUrl($bibliographicalExpression/@xml:id, '/gdp/bibliography/expressions/', $lang)
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
  let $bibliographicalItems := synopsx.lib.commons:getDb($queryParams)//tei:biblStruct
  let $meta := map{
    'title' : 'Liste des items bibliographiques', 
    'quantity' : getQuantity($bibliographicalItems, 'item', 'items'),
    'author' : getAuthors($bibliographicalItems, $lang),
    'copyright' : getCopyright($bibliographicalItems, $lang),
    'description' : getDescription($bibliographicalItems, $lang),
    'keywords' : getKeywords($bibliographicalItems, $lang) 
    }
  let $content := for $bibliographicalItem in $bibliographicalItems return map {
    'title' : getTitles($bibliographicalItem, $lang),
    'date' : getDate($bibliographicalItem, $dateFormat),
    'author' : getAuthors($bibliographicalItem, $lang),
    'abstract' : getAbstract($bibliographicalItem, $lang),
    'tei' : $bibliographicalItem,
    'url' : getUrl($bibliographicalItem/@xml:id, '/gdp/bibliography/manifestations/', $lang)
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
  let $bibliographicalItem := synopsx.lib.commons:getDb($queryParams)//tei:biblStruct[@xml:id=$bibliographicalItemId]
  let $meta := map{
    'title' : 'Item bibliographique',
    'author' : getAuthors($bibliographicalItem, $lang),
    'copyright' : getCopyright($bibliographicalItem, $lang),
    'description' : getDescription($bibliographicalItem, $lang),
    'keywords' : getKeywords($bibliographicalItem, $lang) 
    }
  let $content := map {
    'title' : getTitles($bibliographicalItem, $lang),
    'date' : getDate($bibliographicalItem, $dateFormat),
    'author' : getAuthors($bibliographicalItem, $lang),
    'abstract' : getAbstract($bibliographicalItem, $lang),
    'tei' : $bibliographicalItem,
    'url' : getUrl($bibliographicalItem/@xml:id, '/gdp/bibliography/manifestations/', $lang)
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};