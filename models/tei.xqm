xquery version "3.0" ;
module namespace synopsx.models.tei = 'gdp.models.tei' ;
(:~
 : This module is a TEI models' library for Guides de Paris
 : @version 0.1
 : @since 2014-11-10 
 : @author emchateau
 : @see http://guidesdeparis.net
 :
 :)

declare namespace tei = 'http://www.tei-c.org/ns/1.0' ;

declare default function namespace 'gdp.models.tei' ;

(:~
 : This function creates a map of two maps : one for metadata, one for content data
 :)
declare function getArticlesList($queryParams as map(*)) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:TEI
  let $lang := 'fr'
  let $meta := {
    'title' : 'Liste d’articles', 
    'quantity' : getQuantity($texts, 'article'), (: @todo internationalize :)
    'author' : synopsx.models.tei:getAuthors($texts),
    'copyright'  : synopsx.models.tei:getCopyright($texts),
    'description' : synopsx.models.tei:getDescription($texts, $lang),
    'keywords' : synopsx.models.tei:getKeywords($texts, $lang)
    }
  let $content := map:merge(
    for $item in $texts/tei:teiHeader 
    order by ($item//tei:publicationStmt/tei:date/@when) descending (: sans effet :)
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
declare function getArticle($queryParams as map(*)) {
  let $itemId := map:get($queryParams, 'itemId')
  let $texts := db:open(map:get($queryParams, 'dbName'))/tei:TEI[//tei:sourceDesc[@xml:id=$itemId]]
  let $lang := 'fr'
  let $meta := {
    'title' : synopsx.models.tei:getTitles($itemId, $lang), 
    'author' : synopsx.models.tei:getAuthors($itemId),
    'copyright'  : synopsx.models.tei:getCopyright($itemId),
    'description' : synopsx.models.tei:getDescription($itemId, $lang),
    'keywords' : synopsx.models.tei:getKeywords($itemId, $lang)
    }
  let $content as map(*) := map:merge(
    map:entry( fn:generate-id($itemId), getHeader($itemId) )
    )
  return  map{
    'meta'    : $meta,
    'content' : $content
    }
};


(:~
 : This function creates a map of two maps : one for metadata, one for content data
 :)
declare function getCorpusList($queryParams) {
  let $texts := db:open(map:get($queryParams, 'dbName'))//tei:teiCorpus
  let $lang := 'fr'
  let $meta := {
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

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getHeader($item as element()) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  return map {
    'title' : getTitles($item, $lang),
    'date' : getDate($item, $dateFormat),
    'author' : getAuthors($item),
    'abstract' : getAbstract($item, $lang)
    (: ', teiAbstract' : getAbstract($item, $lang) :)
  }
};

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getBiblStruct($item as element()) {
  let $lang := 'fr'
  let $dateFormat := 'jjmmaaa'
  return map {
    'title' : getBiblTitles($item, $lang),
    'date' : getBiblDate($item, $dateFormat),
    'author' : getBiblAuthors($item),
    'tei' : $item
  }
};

(:~
 : this function creates a map for a corpus item with teiHeader 
 :
 : @param $item a corpus item
 : @return a map with content for each item
 : @rmq subdivised with let to construct complex queries (EC2014-11-10)
 :)
declare function getResp($item as element()) {
  let $lang := 'fr'
  return map {
    'name' : getName($item),
    'resp' : $item//tei:resp/text()
  }
};

(:~
 : ~:~:~:~:~:~:~:~:~
 : tei builders
 : ~:~:~:~:~:~:~:~:~
 :)

(:~
 : this function get abstract
 : @param $content texts to process
 : @return a tei abstract
 :)
declare function getAbstract($content as element()*, $lang as xs:string){
  $content//tei:projectDesc//text()
};

(:~
 : this function get authors
 : @param $content texts to process
 : @return a distinct-values comma separated list
 :)
declare function getAuthors($content as element()*){
  fn:string-join(
    fn:distinct-values(
      for $name in $content//tei:titleStmt//tei:name//text()
        return fn:string-join($name, ' - ')
      ), 
    ', ')
};

(:~
 : this function get authors
 : @param $content texts to process
 : @return a distinct-values comma separated list
 :)
declare function getBiblAuthors($content as element()*){
  fn:string-join(
    fn:distinct-values(
      for $name in $content//tei:name//text()
        return fn:string-join($name, ' - ')
      ), 
    ', ')
};

(:~
 : this function get the licence url
 : @param $content texts to process
 : @return the @target url of licence
 :
 : @rmq if a sequence get the first one
 : @todo make it better !
 :)
declare function getCopyright($content){
  ($content//tei:licence/@target)[1]
};

(:~
 : this function get date
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getDate($content as element()*, $dateFormat as xs:string){
  fn:normalize-space(
    $content//tei:publicationStmt/tei:date
  )
};

(:~
 : this function get date
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getBiblDate($content as element()*, $dateFormat as xs:string){
  fn:normalize-space(
    $content//tei:imprint/tei:date
  )
};

(:~
 : this function get bibliographical titles
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getBiblTitles($content as element()*, $lang as xs:string){
  fn:string-join(
    for $title in $content//tei:title
    return fn:normalize-space($title),
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
    return fn:substring(fn:normalize-space($abstract), 0, 90),
    ', ')
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
    return fn:normalize-space($terms), 
    ', ')
};

(:~
 : this function serialize persName
 : @param $named named content to process
 : @return concatenate forename and surname
 :)
declare function getName($named as element()*){
  fn:normalize-space(
    for $person in $named/tei:persName 
    return ($person/tei:forename || ' ' || $person/tei:surname)
    )
};

(:~
 : this function get titles
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getTitles($content as element()*, $lang as xs:string){
  fn:string-join(
    for $title in $content//tei:titleStmt//tei:title
    return fn:normalize-space($title[fn:starts-with(@xml:lang, $lang)]),
    ', ')
};

(:~
 : this function built a quantity message
 : @param $content texts to process
 : @return concatenate quantity and a message
 : @toto to internationalize
 :)
declare function getQuantity($content as element()*, $unit as xs:string){
  fn:normalize-space(
    if (fn:count($content)>1) 
      then fn:count($content) || ' ' || $unit || 's disponibles'
      else fn:count($content) || $unit || ' disponible'
    )
};

(:~
 : this function get tei doc by id
 : @param $id documents id to retrieve
 : @return a plain xml-tei document
 :)
declare function getXmlTeiById($queryParams){
  db:open(map:get($queryParams, 'dbName'))//tei:TEI[//tei:sourceDesc[@xml-id = map:get($queryParams, 'value')]]
}; 

(: (:~
 : this function get url
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 : @todo print the real uri
 :)
declare function getUrl($content as element()*, $lang as xs:string){
  $G:PROJECTBLOGROOT || $content//tei:sourceDesc/@xml:id
}; :)