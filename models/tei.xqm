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
 : this function built the blog home
 :
 : @param $queryParams the request params sent by restxq
 : @return a map of two map
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
 : this function lists blog posts
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
    'tei' : $post
    }
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
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $entryId := map:get($queryParams, 'entryId')
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
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getCorpusList($queryParams) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $texts := synopsx.lib.commons:getDb($queryParams)//tei:teiCorpus
  let $meta := map{
    'title' : 'Liste d’articles', 
    'quantity' : getQuantity($texts, 'article'), (: @todo internationalize :)
    'author' : getAuthors($texts, $lang),
    'copyright'  : getCopyright($texts, $lang),
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
 : this function creates a map of two maps : one for metadata, one for content data
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
 : ~:~:~:~:~:~:~:~:~
 : tei biblio
 : ~:~:~:~:~:~:~:~:~
 :)
 
(:~
 : This function creates a map of two maps : one for metadata, one for content data
 :)
declare function getBibliographicalExpressionsList($queryParams as map(*)) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $expressions := synopsx.lib.commons:getDb($queryParams)//tei:biblStruct
  let $meta := map{
    'title' : 'Liste des expressions', 
    'quantity' : getQuantity($expressions, 'expression'),
    'author' : getAuthors($expressions, $lang),
    'copyright'  : getCopyright($expressions, $lang),
    'description' : getDescription($expressions, $lang),
    'keywords' : getKeywords($expressions, $lang)
    }
  let $content := for $expression in $expressions return map {
    'title' : getTitles($expression, $lang),
    'date' : getDate($expression, $dateFormat),
    'author' : getAuthors($expression, $lang),
    'tei' : $expression
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getBiblStructList($queryParams) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $texts := synopsx.lib.commons:getDb($queryParams)//tei:biblStruct
  let $meta := map{
    'title' : 'Bibliographie'
    }
  let $content := for $text in $texts return map {
    'title' : getTitles($text, $lang),
    'date' : getDate($text, $dateFormat),
    'author' : getAuthors($text, $lang),
    'abstract' : getAbstract($text, $lang),
    'tei' : $text
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};

(:~
 : this function creates a map of two maps : one for metadata, one for content data
 :)
declare function getRespList($queryParams) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  let $texts := synopsx.lib.commons:getDb($queryParams)//tei:respStmt
  let $meta := map{
    'title' : 'Responsables de l’édition'
    }
  let $content := for $text in $texts return map {
    'title' : getTitles($text, $lang),
    'date' : getDate($text, $dateFormat),
    'author' : getAuthors($text, $lang),
    'abstract' : getAbstract($text, $lang),
    'tei' : $text
    }
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};