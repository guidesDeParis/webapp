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
    'quantity' : getQuantity($posts, 'expression'),
    'author' : getAuthors($posts, $lang),
    'copyright' : getCopyright($posts, $lang),
    'description' : getDescription($posts, $lang),
    'keywords' : getKeywords($posts, $lang) 
    }
  let $content := for $post in $posts return map {
    'title' : getTitles($post, $lang),
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
    'quantity' : getQuantity($posts, ' articles de blog'),
    'author' : getAuthors($posts, $lang),
    'copyright' : getCopyright($posts, $lang),
    'description' : getDescription($posts, $lang),
    'keywords' : getKeywords($posts, $lang)
    }
  let $content := for $post in $posts return map {
    'title' : getTitles($post, $lang),
    'date' : getDate($post, $dateFormat),
    'author' : getAuthors($post, $lang),
    'abstract' : getAbstract($post, $lang),
    'url' : getUrl($post, $lang),
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
    'title' : getTitles($item, $lang),
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
 : ~:~:~:~:~:~:~:~:~
 : tei edition
 : ~:~:~:~:~:~:~:~:~
 :)

(:~
 : this function get the corpus list
 :
 : @param $queryParams the request params sent by restxq 
 : @return a map with meta and content
 :)
declare function getCorpusList($queryParams) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $corpora := synopsx.lib.commons:getDb($queryParams)//tei:teiCorpus
  let $meta := map{
    'title' : 'Liste d’articles', 
    'quantity' : getQuantity($corpora, 'article'), (: @todo internationalize :)
    'author' : getAuthors($corpora, $lang),
    'copyright'  : getCopyright($corpora, $lang),
    'description' : getDescription($corpora, $lang),
    'keywords' : getKeywords($corpora, $lang)
    }
  let $content := for $corpus in $corpora return map {
    'title' : getTitles($corpus, $lang),
    'date' : getDate($corpus, $dateFormat),
    'author' : getAuthors($corpus, $lang),
    'abstract' : getAbstract($corpus, $lang),
    'tei' : $corpus
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
    'title' : getTitles($texts, $lang),
    'date' : getDate($texts, $dateFormat),
    'author' : getAuthors($texts, $lang),
    'abstract' : getAbstract($texts, $lang),
    'tei' : $texts
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
  let $bibliographicalWorks := synopsx.lib.commons:getDb($queryParams)//tei:biblStruct[@type='work']
  let $meta := map{
    'title' : 'Liste des œuvres', 
    'quantity' : getQuantity($bibliographicalWorks, 'œuvre'),
    'author' : getAuthors($bibliographicalWorks, $lang),
    'copyright' : getCopyright($bibliographicalWorks, $lang),
    'description' : getDescription($bibliographicalWorks, $lang),
    'keywords' : getKeywords($bibliographicalWorks, $lang) 
    }
  let $content := for $bibliographicalWork in $bibliographicalWorks return map {
    'title' : getTitles($bibliographicalWork, $lang),
    'date' : getDate($bibliographicalWork, $dateFormat),
    'author' : getAuthors($bibliographicalWork, $lang),
    'abstract' : getAbstract($bibliographicalWork, $lang),
    'tei' : $bibliographicalWork
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
  let $bibliographicalWorkId := map:get($queryParams, 'workId')
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $bibliographicalWork := synopsx.lib.commons:getDb($queryParams)//tei:biblStruct[@xml:id=$bibliographicalWorkId]
  let $meta := map{
    'title' : 'Œuvre',
    'author' : getAuthors($bibliographicalWork, $lang),
    'copyright' : getCopyright($bibliographicalWork, $lang),
    'description' : getDescription($bibliographicalWork, $lang),
    'keywords' : getKeywords($bibliographicalWork, $lang) 
    }
  let $content := map {
    'title' : getTitles($bibliographicalWork, $lang),
    'date' : getDate($bibliographicalWork, $dateFormat),
    'author' : getAuthors($bibliographicalWork, $lang),
    'abstract' : getAbstract($bibliographicalWork, $lang),
    'tei' : $bibliographicalWork
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
    'tei' : $bibliographicalExpression
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
    'tei' : $bibliographicalExpression
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
    'quantity' : getQuantity($bibliographicalItems, 'œuvre'),
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
    'tei' : $bibliographicalItem
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
    'tei' : $bibliographicalItem
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};