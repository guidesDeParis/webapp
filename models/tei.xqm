xquery version '3.0' ;
module namespace gdp.models.tei = 'gdp.models.tei';
(:~
 : This module is for TEI models
 :
 :)
import module namespace db = 'http://basex.org/modules/db';

import module namespace G = 'synopsx.globals' at '../../../globals.xqm'; 

declare default function namespace 'gdp.models.tei'; 
declare namespace tei = 'http://www.tei-c.org/ns/1.0'; 


(:~
 : This function creates a map of two maps : one for metadata, one for content data
 :)
declare function listTexts() {
  let $texts := db:open($G:BLOGDB)//tei:TEI (: openning the database:)
  let $meta as map(*) := {
    'title' : <tei:head>Liste des articles</tei:head> , 
    'quantity' : <tei:label>{fn:count($texts)}</tei:label> , 
    'descriptionFr' : (
      'todo'
      ),
    'descriptionEn' : (
      fn:string-join(for $terms in fn:distinct-values($texts//tei:keywords[fn:starts-with(@xml:lang, 'en')]/tei:term) return fn:string($terms) , ', ')
      ),
    'author' : (
      fn:string-join(for $person in fn:distinct-values($texts//respStmt//tei:persName[@full='yes'])
      order by $person
      return $person, ', ')
      ),
    'keywordsFr' : (
      fn:string-join(for $terms in fn:distinct-values($texts//tei:keywords[fn:starts-with(@xml:lang, 'fr')]/tei:term) return fn:string($terms) , ', ')
      ),
    'copyright' : (
      fn:distinct-values($texts//tei:licence/@target)
      )
    }
  let $content as map(*) := map:merge(
    for $item in $texts//tei:teiHeader 
    return  map:entry( fn:generate-id($item), header($item) )
    )
  return  map{
    'meta'       : $meta,
    'content'    : $content
    }
};


(:~
 : This function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function header($item as element()) {
  let $title as element()* := (
    $item//tei:titleStmt/tei:title
    )[1]
  let $date as element()* := (
    $item//tei:teiHeader//tei:date
    )[1]
  let $author  as element()* := (
    $item//tei:titleStmt/tei:author
    )[1]
  return map {
    'title'      : $title/text() ,
    'date'       : $date/text() ,
    'principal'  : $author/text()
  }
};