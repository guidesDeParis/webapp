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
  let $texts := db:open($G:BLOGDB)//tei:TEI
  let $meta := {
    'title' : 'Liste d’articles', 
    'quantity' : fn:count($texts) , 
    'descriptionFr' : getDescription($texts, 'fr'),
    'descriptionEn' : getDescription($texts, 'en'),
    'author' : getAuthors($texts),
    'keywordsFr' : getKeywords($texts, 'fr'),
    'keywordsEn' : getKeywords($texts, 'en'),
    'copyright' : getCopyright($texts)
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

(:~
 : this function get authors
 : @param $content texts to process
 : @return a distinct-values comma separated list
 :)
declare function getAuthors($content as element()*){
  fn:string-join(
    fn:distinct-values(
      for $name in $content//tei:respStmt[tei:resp/@key='aut'] | $content//tei:principal
      return getName($name)
      ), 
    ', ')
};

(:~
 : this function serialize tei:persName
 : @param $named named content to process
 : @return concatenate forename and surname
 :)
declare function getName($named as element()*){
  for $person in $named/tei:persName 
  return ($person/tei:forename || ' ' || $person/tei:surname)
};

(:~
 : this function get keywords
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a comma separated list of values
 :)
declare function getKeywords($content as element()*, $lang as xs:string){
  fn:string-join(
    for $terms in fn:distinct-values($content//tei:keywords[fn:starts-with(@xml:lang, $lang)]/tei:term) 
    return fn:string($terms), 
    ', ')
};

(:~
 : this function get description
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a comma separated list of 90 first caracters of div[@type='abstract']
 :)
declare function getDescription($content as element()*, $lang as xs:string){
  fn:string-join(
    for $abstract in $content//tei:div[parent::tei:div[fn:starts-with(@xml:lang, $lang)]][@type='abstract']/tei:p 
    return fn:substring($abstract, 0, 90),
    ', ')
};

(:~
 : this function get the licence url
 : @param $content texts to process
 : @return the @target url of licence
 :
 : @rmq if a sequence get the first one
 :)
declare function getCopyright($content){
  ($content//tei:licence/@target)[1]
};
