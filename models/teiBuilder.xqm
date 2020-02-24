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

import module namespace gdp.globals = 'gdp.globals' at '../globals.xqm' ;

declare namespace tei = 'http://www.tei-c.org/ns/1.0' ;

declare default function namespace 'gdp.models.tei' ;

(:~
 : ~:~:~:~:~:~:~:~:~
 : tei builders
 : ~:~:~:~:~:~:~:~:~
 :)

(:~
 : this function get abstract
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a tei abstract
 :)
declare function getAbstract($content as element()*, $lang as xs:string) {
  $content//tei:div[@type='abstract']
};

(:~
 : this function get authors
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a distinct-values comma separated list
 :)
declare function getAuthors($content as element()*, $lang as xs:string) as xs:string {
  fn:string-join(
      for $name in $content/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author | $content/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt[tei:resp[@key='aut']]
      return getName($name, $lang),
    ', ')
};

(:~
 : this function serialize persName
 :
 : @param $named named content to process
 : @param $lang iso langcode starts
 : @return concatenate forename and surname or the element content
 :)
declare function getName($named as element()*, $lang as xs:string) as xs:string {
  switch($named)
  case ($named/tei:forename and $named/tei:surname) return fn:normalize-space(
    let $name := $named/tei:persName[1] 
      return ($name/tei:forename || ' ' || $name/tei:surname)
    )
  default return $named/tei:persName[1]
};

(:~
 : this function get the licence url
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return the @target url of licence
 :
 : @rmq if a sequence get the first one
 : @todo make it better !
 :)
declare function getCopyright($content as element()*, $lang as xs:string) as xs:string {  
  fn:distinct-values($content//tei:licence[1]/@target) => fn:string-join(', ')
};

(:~
 : this function get date
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getBlogDate($content as element()*, $dateFormat as xs:string) {
  fn:normalize-space(
    ($content//tei:publicationStmt/tei:date)[1]
  )
};

(:~
 : this function get date
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getDate($content as element()*, $dateFormat as xs:string) {
  fn:normalize-space($content//tei:imprint/tei:date)
};

(:~
 : this function get date
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getEditionDates($content as element()*, $dateFormat as xs:string) {
  let $dates := for $date in ($content//*:date/fn:substring(@when, 1, 4), $content//*:date/fn:substring(@from, 1, 4), $content//*:date/fn:substring(@to, 1, 4))
    where $date != '' 
    return xs:double($date)
  return fn:min($dates) || '-' || fn:max($dates)
};

(:~
 : this function get bibliographical authors
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of names separated by &
 :)
declare function getBiblAuthors($content as element()*, $lang as xs:string) as xs:string {
  fn:string-join(
    for $author in $content//tei:author
    return fn:string-join(
      for $namePart in $author/tei:persName/tei:* 
      return $namePart, ' '), ' &amp; '
    )
};

(:~
 : this function get date
 :
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getBiblDates($content as element()*, $dateFormat as xs:string) {
  fn:string-join(
    $content//tei:imprint/tei:date, ', '
  )
};

(:~
 : this function get bibliographical expressions
 :
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getBiblExpressions($content as element(), $dateFormat as xs:string) {
  let $id := $content/@xml:id
  return fn:distinct-values(
      db:open('gdp')//tei:biblStruct[tei:listRelation/tei:relation[@type = 'work'][@corresp = '#' || $content/@xml:id]]
    )
};

(:~
 : this function get bibliographical manifestations
 :
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getBiblManifestations($content as element(), $dateFormat as xs:string) {
  for $refId in db:open('gdp')//tei:biblStruct[tei:listRelation/tei:relation[@type = 'work'][@corresp = '#' || $content/@xml:id]]/@xml:id
  return fn:distinct-values(db:open('gdp')//tei:biblStruct[tei:listRelation/tei:relation[@type = 'expression'][@corresp = '#' || $refId]])
};

(:~
 : this function get bibliographical titles
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getBiblTitle($content as element()*, $lang as xs:string) as element()* {
  $content//tei:title[@level='m']
};

(:~
 : this function get bibliographical title
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string
 :)
declare function getBiblTitles($content as element()*, $lang as xs:string){
  fn:string-join(
    for $title in $content//tei:title
      return fn:normalize-space($title),
    ', ')
};

(:~
 : this function get description
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a comma separated list of 90 first caracters of div[@type='abstract']
 :)
declare function getDescription($content as element()*, $lang as xs:string) {
  fn:string-join(
    for $abstract in $content//tei:div[parent::tei:div[fn:starts-with(@xml:lang, $lang)]][@type='abstract']/tei:p 
      return fn:substring(fn:normalize-space($abstract), 0, 90),
    ', ')
};

(:~
 : this function get the number of editions
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a comma separated list of 90 first caracters of div[@type='abstract']
 :)
declare function getOtherEditions($ref as node()? ) as element()* {
  let $corresp := $ref//tei:relation[@type]/@corresp
  return 
    if ($ref/@type = 'expression') 
    then <tei:listBibl>{db:open('gdp')//tei:biblStruct[tei:listRelation/tei:relation[@type = 'expression'][fn:substring-after(@corresp, '#') = $ref/@xml:id]]}
      </tei:listBibl>
    else <tei:listBibl>{db:open('gdp')//tei:biblStruct[tei:listRelation/tei:relation[@type = 'expression'][@corresp = $corresp ]]}</tei:listBibl>
};

(:~
 : this function get keywords from textClass
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a sequence of keywords
 :)
declare function getKeywords($content as element()*, $lang as xs:string) {
    for $terms in fn:distinct-values($content//tei:keywords[fn:starts-with(@xml:lang, $lang)]/tei:term) 
    return fn:normalize-space($terms)
};

(:~
 : this function get the numbers of texts
 :
 : @param $corpus a corpus item
 : @return a number of texts
 :)
declare function getTextsQuantity($corpus as element(), $lang) {
  fn:count($corpus//tei:TEI)
};

(:~
 : this function get post before
 :
 : @param $queryParams the query parameters
 : @text the TEI document to process
 : @param $lang iso langcode starts
 : @return a blog post
 :)
declare function getBlogItemBefore($queryParams as map(*), $text as element(), $lang as xs:string) as element()? {
  let $entryId := map:get($queryParams, 'entryId')
  let $sequence := 
    for $text in synopsx.models.synopsx:getDb($queryParams)/tei:teiCorpus/tei:TEI
    order by $text/tei:teiHeader/tei:publicationStmt/tei:date/@when 
    return $text
  let $position := fn:index-of($sequence, $sequence[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id = $entryId]])
  return $sequence[fn:position() = $position - 1]
};

(:~
 : this function get post after
 :
 : @param 
 : @text the TEI document to process
 : @param $lang iso langcode starts
 : @return a blog post
 :)
declare function getBlogItemAfter($queryParams as map(*), $text as element(), $lang as xs:string) as element()? {
  let $entryId := map:get($queryParams, 'entryId')
  let $sequence := 
    for $text in synopsx.models.synopsx:getDb($queryParams)/tei:teiCorpus/tei:TEI
    order by $text/tei:teiHeader/tei:publicationStmt/tei:date/@when 
    return $text
  let $position := fn:index-of($sequence, $sequence[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id = $entryId]])
  return $sequence[fn:position() = $position + 1]
};

(:~
 : this function get the bibliographical reference of a text or a corpus
 :
 : @param $content a tei or teiCorpus document
 : @return a bibliographical tei element
 : @bug why does the request brings back two results ?
 : @todo suppress the explicit DB selection
 :)
declare function getRef($content as element()) {
  let $refId := fn:substring-after($content/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/@copyOf, '#')
  let $db := db:open('gdp')
  return ($db//tei:biblStruct[@xml:id = $refId] | $db//tei:bibl[@xml:id = $refId])[1]
};

(:~
 : this function get titles
 :
 : @param $content tei content to treat
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getTitles($content as element()*, $lang as xs:string){
  fn:string-join(
    for $title in $content/tei:teiHeader/tei:fileDesc/tei:titleStmt//tei:title
      return fn:normalize-space($title[fn:starts-with(@xml:lang, $lang)]),
    ', ')
};

(:~
 : this function get title
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getMainTitle($content as element()*, $lang as xs:string){
  ($content/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'main'])[1]
};

(:~
 : this function get subtitle
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getSubtitle($content as element()*, $lang as xs:string){
  ($content/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub'])[1]
};

(:~
 : this function get item after
 :
 : @param 
 : @param $lang iso langcode starts
 : @return a div
 :)
declare function getItemAfter($item as element(), $lang as xs:string) as element()? {
  $item/following-sibling::tei:div[@type = 'section' or @type = 'item' or @type = 'chapter' or @type = 'part' ][1]
};

(:~
 : this function get item before
 :
 : @param 
 : @param $lang iso langcode starts
 : @return a div
 :)
declare function getItemBefore($item as element(), $lang as xs:string) as element()? {
  $item/preceding-sibling::tei:div[@type = 'section' or @type = 'item' or @type = 'chapter' or @type = 'part' ][1]
};

(:~
 : this function built a quantity message
 :
 : @param $content texts to process
 : @param $unit a single unit label
 : @param $units a plural unit label
 : @return concatenate quantity and a message
 : @todo to internationalize
 :)
declare function getQuantity($content as item()*, $unit as xs:string, $units as xs:string){
  fn:normalize-space(
    if (fn:count($content) > 1) 
      then fn:count($content) || ' ' || $units
      else fn:count($content) || ' ' || $unit
    )
};

(:~
 : this function get tei doc by id
 :
 : @param $id documents id to retrieve
 : @return a plain xml-tei document
 :)
declare function getXmlTeiById($queryParams){
  db:open(map:get($queryParams, 'dbName'))//tei:TEI[//tei:sourceDesc[@xml-id = map:get($queryParams, 'value')]]
}; 

(:
 : this function get url
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 : @todo print the real uri
 :)
declare function getUrl($content, $path as xs:string, $lang as xs:string){
  $gdp.globals:root || $path || $content
};


(:~
 : this function get string length
 :
 : @param $content texts to process
 : @return string length
 :)
declare function getStringLength($content as element()*){
  fn:sum(
    for $text in $content//tei:body
    return fn:string-length($text)
  )
};

(:~
 : this function get text Id
 :
 : @param $extractId id of the extract to process
 : @return text Id
 :)
declare function getTextId($extract as element()) as xs:string {
  fn:normalize-space(
    $extract/ancestor::tei:TEI[1]//tei:sourceDesc/@xml:id
  )
};

(:~
 : this function get occurences of index entry
 :
 : @param $occurences refs
 : @return 
 :)
declare function getOccurences($entry as element()) as map(*)* {
  let $ids := $entry/tei:listRelation/tei:relation/@passive  ! fn:tokenize(.) ! fn:substring-after(., '#')
  return for $id in $ids 
  let $entry := getDivFromId($id) 
  return map { 
    'id' : $id,
    'title' : if ($entry/tei:head) then $entry/tei:head else $entry/*/tei:label,
    'uuid' : $entry/@xml:id
  }
};

(:~
 : this function get the ancestor div of an element by id
 :
 : @param $id
 : @return a div
 :)
declare function getDivFromId($id as xs:string) as element() {
  db:open('gdp')//*[@xml:id=$id]/ancestor::tei:div[1]
};


(:~
 : this function get the toc
 :
 : @param $node text to process
 : @param $options options
 : @return a sequence of map
 :)
declare function getToc($node, $options) {
  let $options := ''
  return typeswitch($node)
    case element(tei:front) return getTitleMap($node, $options)
    case element(tei:body) return getTitleMap($node, $options)
    case element(tei:back) return getTitleMap($node, $options)
    case element(tei:titlePage) return getTitleMap($node, $options)
    case element(tei:div) return if ($node[* except tei:div]) then getTitleMap($node, $options) else getNextDiv($node, $options)
    default return getNextDiv($node, $options)
};

(:~
 : this function builds a title map
 :
 : @param $node node to process
 : @param $options options
 : @return a map for each title in the corpora
 :)
declare function getTitleMap($nodes, $options) {
  let $options := $options
  for $node in $nodes
  return map {
      'type' : if ($node/@type) then fn:string($node/@type) else $node/fn:name(),
      'title' : getSectionTitle($node),
      'uuid' : fn:string($node/@xml:id),
      'children' : getNextDiv($node, $options)
    }
};

(:~
 : this function get next div
 :
 : @param $node node to process
 : @param $options options
 : @return a kind of apply-templates
 :)
declare function getNextDiv($nodes, $options) {
  for $node in $nodes/node()
  return getToc($node, $options)
};

(:~
 : this function get the section title
 : @param $node node to process
 : @param $options options
 :)
declare function getSectionTitle($nodes) {
  for $node in $nodes 
  return if ($node/tei:head) 
    then dispatch($node/tei:head, map{})
    else dispatch($node/*/tei:label, map{})
};

(:~
 : this function dispatches the treatment of the XML document
 :)
declare 
  %output:indent('no') 
function dispatch($node as node()*, $options as map(*)) as item()* {
  typeswitch($node)
    case text() return $node[fn:normalize-space(.)!='']
    case element(tei:label) return $node ! label(., $options)
    case element(tei:hi) return $node ! hi(., $options)
    case element(tei:emph) return $node ! hi(., $options)
    default return $node ! passthru(., $options)
};

(:~
 : This function pass through child nodes (xsl:apply-templates)
 :)
declare 
  %output:indent('no') 
function passthru($nodes as node(), $options as map(*)) as item()* {
  for $node in $nodes/node()
  return dispatch($node, $options)
};

(:~
 : ~:~:~:~:~:~:~:~:~
 : tei inline
 : ~:~:~:~:~:~:~:~:~
 :)
declare function hi($node as element(tei:hi)+, $options as map(*)) {
  switch ($node)
  case ($node[@rend='italic' or @rend='it']) return <em>{ passthru($node, $options) }</em> 
  case ($node[@rend='bold' or @rend='b']) return <strong>{ passthru($node, $options) }</strong>
  case ($node[@rend='superscript' or @rend='sup']) return <sup>{ passthru($node, $options) }</sup>
  case ($node[@rend='underscript' or @rend='sub']) return <sub>{ passthru($node, $options) }</sub>
  case ($node[@rend='underline' or @rend='u']) return <u>{ passthru($node, $options) }</u>
  case ($node[@rend='strikethrough']) return <del class="hi">{ passthru($node, $options) }</del>
  case ($node[@rend='caps' or @rend='uppercase']) return <span calss="uppercase">{ passthru($node, $options) }</span>
  case ($node[@rend='smallcaps' or @rend='sc']) return <span class="small-caps">{ passthru($node, $options) }</span>
  default return <span class="{$node/@rend}">{ passthru($node, $options) }</span>
};

declare function emph($node as element(tei:emph), $options as map(*)) {
  <em class="emph">{ passthru($node, $options) }</em>
};

declare function label($node as element(tei:label), $options as map(*)) {
  <span class="label">{ passthru($node, $options) }</span>
};