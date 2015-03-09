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

import module 'gdp.models.teiBiblio' at 'teiBiblio.xqm' ;
import module 'gdp.models.teiBuilder' at 'teiBuilder.xqm' ;

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
declare function getBlogHome($queryParams as map(*)) {
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
 : @return a map of two map
 :)
declare function getBlogPosts($queryParams as map(*)) {
  (: let $posts := db:open(map:get($queryParams, 'dbName'))//tei:TEI :)
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
  let $content := map:merge(
    for $item in $posts
    return  map:entry( fn:generate-id($item), getHeader($item) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : This function creates a map of two maps : one for metadata, one for content data
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
