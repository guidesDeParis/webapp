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
import module namespace synopsx.models.tei = 'synopsx.models.tei' at '../../../models/tei.xqm' ;

import module 'gdp.models.tei' at 'teiContent.xqm' , 'teiBuilder.xqm' ;

declare namespace tei = 'http://www.tei-c.org/ns/1.0' ;

declare default function namespace 'gdp.models.tei' ;


(:~
 : ~:~:~:~:~:~:~:~:~
 : tei blog
 : ~:~:~:~:~:~:~:~:~
 :)
 
(:~
 : this function built the blog home
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map
 :)
declare function getBlogHome($queryParams as map(*)) as map(*) {
  let $expressions := db:open(map:get($queryParams, 'dbName'))//tei:teiCorpus
  let $lang := 'fr'
  let $meta := map{
    'title' : 'Home page du blog', 
    'quantity' : getQuantity($expressions, 'expression'),
    'author' : getAuthors($expressions),
    'copyright'  : getCopyright($expressions),
    'description' : getDescription($expressions, $lang),
    'keywords' : getKeywords($expressions, $lang)
    }
  let $content := map:merge(
    for $item in $expressions/tei:TEI
    return  map:entry( fn:generate-id($item), getHeader($item) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function lists blog posts
 :
 : @param $queryParams the request params sent by restxq
 : @return a map with meta and content
 :)
declare function getBlogPosts($queryParams as map(*)) as map(*) {
  let $posts := synopsx.lib.commons:getDb($queryParams)//tei:TEI
  let $lang := 'fr'
  let $meta := map{
    'title' : 'Liste des articles de blog', 
    'quantity' : getQuantity($posts, ' articles de blog'),
    'author' : getAuthors($posts),
    'copyright'  : getCopyright($posts),
    'description' : getDescription($posts, $lang),
    'keywords' : getKeywords($posts, $lang)
    }
  let $content := for $item in $posts return getHeader($item)
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function get a blog post
 :
 : @param $queryParams the request params sent by restxq
 : @return a map with meta and content
 :)
declare function getBlogItem($queryParams as map(*)) {
  let $entryId := map:get($queryParams, 'entryId')
  let $article := db:open(map:get($queryParams, 'dbName'))/tei:TEI[//tei:sourceDesc[@xml:id=$entryId]]
  let $lang := 'fr'
  let $meta := map{
    'title' : getTitles($article, $lang), 
    'author' : getAuthors($article),
    'copyright'  : getCopyright($article),
    'description' : getDescription($article, $lang),
    'keywords' : getKeywords($article, $lang)
    }
  let $content as map(*) := map:merge(
    for $item in $article
    return  map:entry( fn:generate-id($item), getHeader($item) )
    )
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
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getCorpusList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:teiCorpus
  let $lang := 'fr'
  let $meta := map{
    'title' : 'Liste d’articles', 
    'quantity' : getQuantity($texts, 'article'), (: @todo internationalize :)
    'author' : getAuthors($texts),
    'copyright'  : getCopyright($texts),
    'description' : getDescription($texts, $lang),
    'keywords' : getKeywords($texts, $lang)
    }
  let $content := map:merge(
    for $item in $texts/tei:teiHeader 
    order by $item//tei:publicationStmt/tei:date/@when (: sans effet :)
    return  map:entry( fn:generate-id($item), getHeader($item) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getTextsList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:TEI/tei:teiHeader
  let $lang := 'fr'
  let $meta := map{
    'title' : 'Liste des textes', 
    'author' : getAuthors($texts),
    'copyright' : getCopyright($texts),
    'description' : getDescription($texts, $lang),
    'keywords' : getKeywords($texts, $lang)
    }
  let $content as map(*) := map:merge(
    for $item in $texts
    return  map:entry( fn:generate-id($item), getHeader($item) )
    )
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
 : This function creates a map of two maps : one for metadata, one for content data
 :)
declare function getBibliographicalExpressionsList($queryParams as map(*)) {
  let $expressions := db:open(map:get($queryParams, 'dbName'))//tei:TEI
  let $lang := 'fr'
  let $meta := map{
    'title' : 'Liste des expressions', 
    'quantity' : getQuantity($expressions, 'expression'),
    'author' : getAuthors($expressions),
    'copyright'  : getCopyright($expressions),
    'description' : getDescription($expressions, $lang),
    'keywords' : getKeywords($expressions, $lang)
    }
  let $content := map:merge(
    for $item in $expressions/tei:biblStruct 
    return  map:entry( fn:generate-id($item), getHeader($item) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getBiblStructList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:listBibl
  let $lang := 'fr'
  let $meta := map{
    'title' : 'Bibliographie'
    }
  let $content as map(*) := map:merge(
    for $item in $texts/tei:biblStruct
    order by fn:number(getBiblDate($item, $lang))
    return  map:entry( fn:generate-id($item), getBiblStruct($item) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getRespList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:respStmt
  let $lang := 'fr'
  let $meta := map{
    'title' : 'Responsables de l’édition'
    }
  let $content as map(*) := map:merge(
    for $item in $texts
    return  map:entry( fn:generate-id($item), getResp($item) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};