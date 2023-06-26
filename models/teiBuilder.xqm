xquery version "3.1" ;
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

declare namespace db = "http://basex.org/modules/db" ;
declare namespace file = "http://expath.org/ns/file" ;
declare namespace http = 'http://expath.org/ns/http-client';
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization" ;
declare namespace request = 'http://exquery.org/ns/request';
declare namespace rest = "http://exquery.org/ns/restxq" ;
declare namespace update = "http://basex.org/modules/update" ;
declare namespace web = "http://basex.org/modules/web" ;

declare namespace perm = "http://basex.org/modules/perm" ;
declare namespace user = "http://basex.org/modules/user" ;
declare namespace session = 'http://basex.org/modules/session' ;

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
 : this function get metadata
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a tei metadata
 :)
declare function getMetadata($content as element()*, $lang as xs:string) as map(*)* {
  map{
    "name" : "DC.type",
    "content" : "text"
  },
  map{
    "name" : "DC.title",
    "scheme" : "URI",
    "content" : getTitles($content, $lang)
  },
  map{
      "name" : "DC.author",
      "scheme" : "URI",
      "content" : getAuthors($content, $lang)
    },
  map{
    "name" : "keywords",
    "content" : ("architecture", "18e siècle"),
    "lang" : "fr"
  }
};

(:~
 : this function get abstract
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a tei abstract
 :)
declare function getAbstract($content as element()*, $lang as xs:string) as element()? {
  $content//tei:div[@type='abstract']
};

(:~
 : this function get authors
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a distinct-values comma separated list
 : @todo change to a sequence of string (2020-06)
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
  default return fn:normalize-space($named/tei:persName[1])
};

(:~
 : this function get the licence url
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return the @target url of licence
 :
 : @rmq if a sequence get the first one
 : @todo make it better ! distinct various licences with a map ? (2020-06)
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
declare function getBlogDate($content as element()*, $dateFormat as xs:string) as xs:string {
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
declare function getDate($content as element()*, $dateFormat as xs:string) as xs:string {
  fn:normalize-space($content//tei:imprint/tei:date)
};

(:~
 : this function get date
 : @param $content texts to process
 : @param $dateFormat a normalized date format code
 : @return a date string in the specified format
 : @todo formats
 :)
declare function getEditionDates($content as element()*, $dateFormat as xs:string) as xs:string? {
  let $dates :=
    for $date in (
      $content//tei:date/fn:substring(@when, 1, 4),
      $content//tei:date/fn:substring(@from, 1, 4),
      $content//tei:date/fn:substring(@to, 1, 4)
      )
    where $date != ''
    return xs:double($date)
  return if ($dates > 1) then fn:min($dates) || '-' || fn:max($dates) else $dates
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
declare function getBiblManifestations($content as element(), $dateFormat as xs:string) as map(*)* {
  for $ref in db:open('gdp')//tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc[@xml:id='gdpBibliography']]//tei:biblStruct
  [tei:listRelation/tei:relation[@type = 'expression'][@corresp = '#' || $content/@xml:id]]
  group by $manifestation := $ref/@xml:id
  let $path := '/bibliography/manifestation/'
  return map{
    'uuid' : $manifestation => xs:string(),
    'path' : $path,
    'url' : $gdp.globals:root || $path || $manifestation,
    'tei' : $ref
  }
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
 : this function get edition from manifestation
 :
 : @param $content manifestation
 : @param $lang iso langcode starts
 : @return a string
 :)
declare function getEdition($content as element()*) as map(*)? {
  let $text := db:open('gdp')/tei:teiCorpus/tei:teiCorpus/tei:TEI[tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/@copyOf = '#' || $content/@xml:id]
  let $uuid := $text/tei:teiHeader/tei:fileDesc/tei:sourceDesc/@xml:id
  return if ($uuid) then map {
    'uuid' : $uuid,
    'title' : getTitles($text, 'fr'),
    'path' : '/texts/',
    'url' : $gdp.globals:root || '/texts/' || $uuid
  }
};

(:~
 : this function get description
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a comma separated list of 90 first caracters of div[@type='abstract']
 :)
declare function getBlogDescription($content as element()*, $lang as xs:string) as xs:string {
  fn:string-join(
    for $abstract in $content//tei:div[parent::tei:div[fn:starts-with(@xml:lang, $lang)]][@type='abstract']/tei:p 
      return fn:normalize-space($abstract),
    ', ') => fn:substring( 0, 400)
};

(:~
 : this function get description
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a comma separated list of 90 first caracters of div[@type='abstract']
 :)
declare function getDescription($content as element()*, $lang as xs:string) as xs:string {
  fn:string-join(
    for $abstract in $content/tei:teiHeader/tei:fileDesc/tei:notesStmt/tei:note[@type='abstract'][fn:starts-with(@xml:lang, $lang)]
      return fn:normalize-space($abstract),
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
declare function getKeywords($content as element()*, $lang as xs:string) as xs:string* {
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
declare function getRef($content as element()) as element()? {
  let $refId := fn:substring-after($content/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/@copyOf, '#')
  let $db := db:open('gdp')
  return ($db//tei:biblStruct[@xml:id = $refId] | $db//tei:bibl[@xml:id = $refId])[1]
};

(:~
 : this function get the bibliographical reference id of a text or a corpus
 :
 : @param $content a tei or teiCorpus document
 : @return a bibliographical tei element
 : @bug why does the request brings back two results ?
 :)
declare function getRefId($content as element()) as xs:string? {
  fn:substring-after($content/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/@copyOf, '#')
};

(:~
 : this function get titles
 :
 : @param $content tei content to treat
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 : @todo deal with labels
 :)
declare function getTitles($content as element()*, $lang as xs:string) as xs:string {
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
declare function getMainTitle($content as element()*, $lang as xs:string) as element() {
  ($content/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'main'])[1]
};

(:~
 : this function get subtitle
 :
 : @param $content texts to process
 : @param $lang iso langcode starts
 : @return a string of comma separated titles
 :)
declare function getSubtitle($content as element()*, $lang as xs:string) as element()? {
  ($content/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'sub'])[1]
};

(:~
 : this function get item after
 :
 : @param 
 : @param $lang iso langcode starts
 : @return a div
 : @todo retirer * et utiliser toc
 :)
declare function getItemAfter($item as element()*, $lang as xs:string) as element()? {
  $item/following::tei:div[1]
};

(:~
 : this function get item before
 :
 : @param 
 : @param $lang iso langcode starts
 : @return a div
 : @todo retirer * et utiliser toc
 :)
declare function getItemBefore($item as element()*, $lang as xs:string) as element()? {
  $item/preceding::tei:div[1]
  (:$item/preceding::tei:div[@type = 'section' or @type = 'item' or @type = 'chapter' or @type = 'part' ][1]:)
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

(:declare function getQuantity($content as item()*, $unit as xs:string, $units as xs:string) as xs:string {
  let $nb := fn:count($content)
  return switch ($nb)
    case ($nb = 0) return fn:normalize-space('pas de ' ||  $units)
    case ($nb = 1) return fn:normalize-space($nb || ' ' || $unit)
    default return fn:normalize-space($nb || ' ' || $units)
};:)
declare function getQuantity($content as item()*, $unit as xs:string, $units as xs:string) as map(*) {
  let $nb := if ($content instance of xs:integer)
    then xs:integer($content)
    else fn:count($content)
  return if ($nb eq 0) then map{'quantity' : 0, 'unit' : fn:normalize-space('pas de ' ||  $unit)}
         else if ($nb eq 1)  then map{'quantity' : $nb, 'unit' : $unit}
         else map{'quantity' : $nb, 'unit' : $units}
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
declare function getUrl($content, $path as xs:string, $lang as xs:string) as xs:string {
  $gdp.globals:root || $path || $content
};


(:~
 : this function get string length
 :
 : @param $content texts to process
 : @return string length
 : @todo to replace by a fixed value from teiHeader (2020-06) for documents, but a more generic metrics in other cases
 :)
declare function getStringLength($content as element()*){
  fn:sum(
    for $text in $content//tei:body
    return fn:string-length($text)
  )
};

(:~
 : this function get words
 :
 : @param $content texts to process
 : @return string length
 : @todo to replace by a fixed value from teiHeader (2020-06) for documents, but a more generic metrics in other cases
 :)
declare function getExtent($content as element()) as xs:integer? {
  $content/tei:teiHeader/tei:fileDesc/tei:extent/tei:measure[@unit="words"]/@quantity
};

(:~
 : this function get text Id
 :
 : @param $extractId id of the extract to process
 : @return text Id
 : @todo replace with getTextIdWithRegex (more effective)
 :)
declare function getTextId($extract as element()) as xs:string {
  fn:normalize-space(
    $extract/ancestor::tei:TEI[1]//tei:sourceDesc/@xml:id
  )
};

(:~
 : this function get text Id with a regex
 :
 : @param $extractId id of the extract to process
 : @return text Id
 :)
declare function getTextIdWithRegex($extract as element()) as xs:string {
  let $extractId := $extract/ancestor::tei:*[@xml:id][1]/@xml:id
  let $parse := fn:analyze-string($extractId, '^gdp.*[1-9]{4}')
  return fn:string($parse/fn:match)
};

(:
 : this function get the upperPart of a div
 :)
declare function remove-elements-deep($nodes as node()*, $names as xs:string*) {
  for $node at $i in $nodes except $nodes[(self::tei:pb|self::tei:fw|self::tei:metamark)[preceding-sibling::tei:div]]
  return if ($node instance of element())
    then if (fn:name($node) = $names and $i != 1)
      then ()
    else element { fn:node-name($node)} {
        $node/@*, remove-elements-deep($node/node(),
        $names)
        }
    else if ($node instance of document-node())
      then remove-elements-deep($node/node(), $names)
      else $node
};

declare function deepCopy($node, $options) {
  switch($node)
  case ($node/fn:local-name() = 'div' ) return ()
  case ($node instance of element())
    return
      element {fn:name($node)} {
        $node/@*,
        for $i in $node/(* | text())
        return deepCopy($i, $options)
      }
      default return $node
};

(:~
 : this function get a refactorated item when pagination is before the div
 :)
declare function getItemRefactorated($node as element()) as element() {
  let $pagination := $node/preceding-sibling::tei:pb[1] union $node/preceding-sibling::tei:fw[1]
  return if ($pagination)
    then element {fn:node-name($node)} {
      $node/@*,
      $pagination,
      $node/node()
    }
    else $node
};

(:~
 : this function get occurences of index entry
 :
 : @param $occurences refs
 : @return
 :)(:
declare function getOccurences($entry as element()) as map(*)* {
  let $ids := $entry/tei:listRelation/tei:relation/@passive  ! fn:tokenize(., ' ') ! fn:substring-after(., '#')
  return for $id in $ids
  let $entry := getDivFromId($id)
  let $uuid := $entry/@xml:id
  return map {
    'id' : $id,
    'title' : getSectionTitle($entry),
    'uuid' : $uuid,
    'path' : '/item/',
    'url' : $gdp.globals:root || '/items/' || $uuid
  }
};:)

(:~
 : this function get all attested forms of an index entry
 : @param $entry index entry
 : @return maps for each attested form with its occurences
 :)
 declare function getAttestedForms($entry as element(), $options as map(*)) {
   for $name in db:open('gdp')//tei:persName[@xml:id = $entry/tei:listRelation/tei:relation/@passive  ! fn:tokenize(., ' ') ! fn:substring-after(., '#')]
   group by $distinctNames := fn:distinct-values($name)
   return map{
     'title' : $name[1] ! <tei:persName>{ dispatch(.,map{}) }</tei:persName>,
     'quantity' : fn:count($name),
     'id' : array{ $name/@xml:id ! xs:string(.) },
     'uuid' : array{ $name/@xml:id ! getDivFromId(.)/@xml:id ! xs:string(.)}
   }
};

(:~
 : this function get occurences of index entry
 :
 : @param $occurences refs
 : @return a sequence of maps containing all the index entries for each text
 : @todo optimize by supressing getRef
 :)
declare function getOccurences($entry as element(), $options as map(*)) as map(*)* {
  for $item in $entry/tei:listRelation/tei:relation
  group by $texts := $item/@type
  return map{
    'item' : fn:normalize-space($texts),
    'biblio' : getRef($options?db//tei:TEI[tei:teiHeader//tei:sourceDesc[@xml:id = $texts]]),
    'occurences' : array{
      let $ids := $item/@passive  ! fn:tokenize(., ' ') ! fn:substring-after(., '#')
      let $lookup :=
        for $id in $ids
        return map{
          'id' : $id,
          'entry' : getDivFromId($id)/@xml:id
          }
      for $item in fn:distinct-values($lookup?entry)
      return map{
        'title' : getSectionTitle(db:open('gdp')//tei:div[@xml:id=$item]),
        'uuid' : xs:string($item),
        'path' : '/item/',
        'url' : $gdp.globals:root || '/items/' || $item,
        'ids' : array{ $lookup[?entry = $item]?id }
       }
    }
  }
};

(:~
 : this function filters distinct maps in a sequence

 : @param $maps a sequence of maps to filter
 : @options $options
 : @return a filtered list of maps
 :)
declare function getDistinctMaps($maps as map(*)*, $options) as map(*)* {
  fn:fold-left(
    $maps,
    (),
    function($distinct-maps, $new-map) {
      if (some $map in $distinct-maps satisfies fn:deep-equal($map, $new-map))
      then $distinct-maps else ($distinct-maps, $new-map)
    }
  )
};

(:~
 : this function get distinct filters

 : @param $maps a sequence of maps to filter
 : @options $options
 : @return a filtered list of maps
 :)
declare function getDistinctFilters($ids as xs:string*, $options) as map(*)* {
  let $db := db:open('gdp')
  for $id in $ids
  group by $distinctId := $id
  let $path := if ($options?filter = 'persons') then '/indexNominum/'
      else if ($options?filter = 'places') then '/indexLocorum/'
      else if ($options?filter = 'objects') then '/indexObjects/'
      else if ($options?filter = 'texts') then '/items/'
      else ()
  let $title := if ($options?filter = 'persons') then $db//*[@xml:id = $id]/tei:persName[1]
    else if ($options?filter = 'places') then $db//*[@xml:id = $id]/tei:placeName[1]
    else if ($options?filter = 'objects') then $db//*[@xml:id = $id]/tei:objectName[1]
    else if ($options?filter = 'texts') then getShortRef($distinctId, map{})
  return map{
      'title' : $title,
      'uuid' : $distinctId,
      'quantity' : fn:count($id),
      'path' : $path,
      'url' : $gdp.globals:root || $path || $distinctId
  }
};

(:~
 : this function get distinct filters

 : @param $maps a sequence of maps to filter
 : @options $options
 : @return a filtered list of maps
 :)
declare function getDistinctFiltersFromIndex($ids as xs:string*, $options) as map(*)* {
  let $db := db:open('gdpFtIndex')
  let $segs := $db//*[@xml:id = $ids]
  return if ($options?filter = 'objects') then
    let $path := '/indexOperum/'
    for $object in $segs/tei:metadata/tei:indexes/tei:objects/tei:object
    group by $id := $object/tei:objectId
    return map{
      'title' : fn:distinct-values($object/tei:objectName) => fn:normalize-space(),
      'uuid' : $id => fn:normalize-space(),
      'quantity' : fn:count($object),
      'path' : '/indexOperum/',
      'url' : $gdp.globals:root || fn:distinct-values($path) || $id
    }
  else if ($options?filter = 'persons') then
      let $path := '/indexNominum/'
      for $person in $segs/tei:metadata/tei:indexes/tei:persons/tei:person
      group by $id := $person/tei:personId
      return map{
        'title' : fn:distinct-values($person/tei:persName) => fn:normalize-space(),
        'uuid' : $id => fn:normalize-space(),
        'quantity' : fn:count($person),
        'path' : '/indexNominum/',
        'url' : $gdp.globals:root || fn:distinct-values($path) || $id
      }
   else if ($options?filter = 'places') then
         let $path := '/indexLocorum/'
         for $place in $segs/tei:metadata/tei:indexes/tei:places/tei:place
         group by $id := $place/tei:placeId
         return map{
           'title' : fn:distinct-values($place/tei:placeName) => fn:normalize-space(),
           'uuid' : $id => fn:normalize-space(),
           'quantity' : fn:count($place),
           'path' : '/indexNominum/',
           'url' : $gdp.globals:root || fn:distinct-values($path) || $id
         }
};

(:~
 : this function generate a short ref from text id
 :)
declare function getShortRef($ids as xs:string*, $options as map(*)) {
  for $id in $ids
  return if ($id = 'gdpBrice1684') then 'Brice 1684'
    else if ($id = 'gdpSauval1724') then 'Sauval 1724'
    else if ($id = 'gdpLeMaire1685') then 'Le Maire 1685'
    else if ($id = 'gdpPiganiol1742') then 'Piganiol 1742'

};

(:~
 : this function get index values of an item
 :
 : @param $occurences refs
 : @return
 : @todo restreindre les fichiers parcourus
 : @todo tokenize ref if multiple values
 : @todo add objects
 : @todo add orgName for titles in persons
 :)
declare function getIndexEntries($item as element()) as map(*)* {
  let $db := db:open('gdp')
  let $personsRefs := $item//tei:persName/@xml:id union $item//tei:orgName/@xml:id
  let $placesRefs := $item//tei:placeName/@xml:id union $item//tei:geogName/@xml:id
  let $objectsRefs := $item//tei:objectName/@xml:id
  let $persons :=
    for $personRef in $personsRefs
    return $db//tei:person[tei:listRelation/tei:relation[fn:contains(@passive, '#' || $personRef)]]
  let $personsMap :=
    for $person in $persons
    let $uuid := $person/@xml:id
    return map {
      'title' : $person/tei:persName[1],
      'uuid' : $uuid,
      'path' : '/indexNominum/',
      'url' : $gdp.globals:root || '/indexNominum/' || $uuid
    }
  let $places :=
     for $placeRef in $placesRefs
     return $db//tei:place[tei:listRelation/tei:relation[fn:contains(@passive, '#' || $placeRef)]]
  let $placesMap :=
     for $place in $places
     let $uuid := $place/@xml:id
     return map {
       'title' : $place/tei:placeName[1],
       'uuid' : $uuid,
       'path' : '/indexLocorum/',
       'url' : $gdp.globals:root || '/indexLocorum/' || $uuid
     }
  let $objects :=
     for $objectRef in $objectsRefs
     return $db//tei:object[tei:listRelation/tei:relation[fn:contains(@passive, '#' || $objectRef)]]
  let $objectsMap :=
     for $object in $objects
       let $uuid := $object/@xml:id
       return map {
         'title' : $object/tei:objectName[1],
         'uuid' : $uuid,
         'path' : '/indexOperum/',
         'url' : $gdp.globals:root || '/indexOperum/' || $uuid
       }
  (:let $objects :=
      for $objectsRef in $objectsRefs[@ref]
      return fn:substring-after($objectsRef/@ref, '#') => fn:distinct-values()
    let $objectsMap :=
      for $object in $db//*[@xml:id = $objects]
      return map {
        'title' : $object/tei:objectName[1],
        'uuid' : $object/@xml:id
      }:)
  return map {
    'persons' : $personsMap,
    'places' : $placesMap,
    'objects' : $objectsMap
  }
};

(:~
 : this function get index values of an item
 :
 : @param $occurences refs
 : @return
 : @todo tokenize ref if multiple values
 : @todo add orgName for titles in persons
 :)
declare function getIndexEntriesFromIndex($item as element()) as map(*)* {
  let $item := if ($item/tei:metadata)
    then $item
    else db:open('gdpFtIndex')//*[@xml:id=$item/@xml:id]
  let $personsMap :=
    for $person in $item/tei:metadata/tei:indexes/tei:persons/*
    let $uuid := $person/tei:personId
    return map {
       'title' : $person/tei:persName,
       'uuid' : $uuid,
       'path' : '/indexNominum/',
       'url' : $gdp.globals:root || '/indexNominum/' || $uuid
    }
  let $placesMap :=
      for $place in $item/tei:metadata/tei:indexes/tei:places/*
      let $uuid := $place/tei:placeId
      return map {
         'title' : $place/tei:placeName,
         'uuid' : $uuid,
         'path' : '/indexLocorum/',
         'url' : $gdp.globals:root || '/indexLocorum/' || $uuid
      }
  let $objectsMap :=
        for $object in $item/tei:metadata/tei:indexes/tei:objects/*
        let $uuid := $object/tei:objectId
        return map {
           'title' : $object/tei:objectName,
           'uuid' : $uuid,
           'path' : '/indexOperum/',
           'url' : $gdp.globals:root || '/indexOperum/' || $uuid
        }
  return map {
    'persons' : $personsMap,
    'places' : $placesMap,
    'objects' : $objectsMap
  }
 };

(:~
 : this function get the ancestor div of an element by id
 :
 : @param $id
 : @return a div
 :)
declare function getDivFromId($id as xs:string) as element() {
  (db:open('gdp')//*[@xml:id=$id]/ancestor::tei:div[1])[1]
};

(:~
 : this function get item from pages
 :)
declare function getItemFromPage($text as element(), $options as map(*)) {
  let $lang := 'fr'
  let $item := $text//tei:fw[1][@type = 'pageNum'][. = $options?page]/ancestor::tei:div[1]
  let $uuid := $item/@xml:id
  let $itemBefore := getItemBefore($item, $lang)
  let $itemAfter := getItemAfter($item, $lang)
  return map{
    'type' : if ($item/@type) then fn:string($item/@type) else $item/fn:name(),
    'title' : getSectionTitle($item),
    'pages' : getPages($item, $options),
    'uuid' : $uuid,
    'path' : '/items/',
    'url' : $gdp.globals:root || '/items/' || $uuid,
    'tei' : $item,
    'itemBeforeTitle' : getSectionTitle($itemBefore), (: is a sequence :)
    'itemBeforeUrl' : getUrl($itemBefore/@xml:id, '/items/', $lang),
    'itemBeforeUuid' : $itemBefore/@xml:id,
    'itemAfterTitle' : getSectionTitle($itemAfter), (: is a sequence :)
    'itemAfterUrl' : getUrl($itemAfter/@xml:id, '/items/', $lang),
    'itemAfterUuid' : $itemAfter/@xml:id,
    'indexes' : array{getIndexEntries($item)}
    }
};

(:~
 : this function get pages for an item
 :)
declare function getPagesOld($item as element(), $options as map(*)) {
  let $uuid := $item/@xml:id
  let $pageBefore := (getItemBefore($item, 'fr')//tei:fw[@type = 'pageNum'])[fn:last()]
  let $fw := $item//tei:fw[@type = 'pageNum']
  let $pages := ($pageBefore, $fw)
  return map{
    'prefix' : if ($fw) then 'pp.' else 'p.',
    'range' : fn:string-join(($pageBefore, $fw[fn:last()]), '–')
  }
};

(:~
 : this function get pages for an item
 :)
declare function getPages($item as element(), $options as map(*)) {
  let $uuid := $item/@xml:id
  let $segFt := db:open('gdpFtIndex')//*[@xml:id=$uuid]
  return map{
    'prefix' : $segFt/tei:metadata/tei:pages/tei:prefix,
    'range' : $segFt/tei:metadata/tei:pages/tei:range
  }
};

(:~
 : this function get the words count
 :
 : @param $item text item to count
 : @param $options options
 : @return a quantity and a unit
 :)
declare function getWordsCount($item as element(), $options as map(*)) {
  let $uuid := $item/@xml:id
  let $segFt := db:open('gdpFtIndex')//*[@xml:id=$uuid]
  return map{ 'unit' : $item/tei:metadata/tei:size/tei:unit,
    'quantity' : $item/tei:metadata/tei:size/tei:quantity
   }
  (: fn:count(fn:tokenize($item, '\W+')[. != '']) :)
};

(:~
 : this function get the toc
 :
 : @param $node text to process
 : @param $options options
 : @return a sequence of map
 : @todo add group
 :)
declare function getToc($node, $options as map(*)) {
  typeswitch($node)
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
declare function getTitleMap($nodes, $options as map(*)) {
  let $options := $options
  for $node in $nodes except $nodes[tei:div[@type='notesCritical']]
  let $uuid := fn:string($node/@xml:id)
  return map {
      'type' : if ($node/@type) then fn:string($node/@type) else $node/fn:name(),
      'title' : getSectionTitle($node),
      'uuid' : $uuid,
      'pages' : getPages($node, map{}),
      'size' : getWordsCount($node, map{}),
      'path' : '/items/',
      'url' : $gdp.globals:root || '/items/' || $uuid,
      'indexes' : array{ getIndexesWithFt($node, map{}) },
      'children' : array{ getNextDiv($node, $options) }
    }
};

declare function getIndexesWithFt($node as element(), $options as map(*)) as map(*)* {
  let $uuid := $node/@xml:id
  let $metadata := db:open('gdpFtIndex')//*[@xml:id=$uuid]/tei:metadata
  let $persons := for $person in $metadata/tei:indexes/tei:persons/tei:person return map{
    'uuid' : $person/tei:personId,
    'title' : $person/tei:persName,
    'quantity' : $person/tei:quantity,
    'refs' : array{
      for $item in $node//(tei:placeName|tei:persName|tei:orgName|tei:objectName|tei:geogName)[@ref = '#' || $person/tei:personId ]
      return $item/@xml:id
      }
    }
  let $places := for $place in $metadata/tei:indexes/tei:places/tei:place return map{
    'uuid' : $place/tei:placeId,
    'title' : $place/tei:placeName,
    'quantity' : $place/tei:quantity,
    'refs' : array{
      for $item in $node//(tei:placeName|tei:persName|tei:orgName|tei:objectName|tei:geogName)[@ref = '#' || $place/tei:placeId ]
      return $item/@xml:id
      }
    }
  let $objects := for $object in $metadata/tei:indexes/tei:objects/tei:object return map{
    'uuid' : $object/tei:objectId,
    'title' : $object/tei:objectName,
    'quantity' : $object/tei:quantity,
    'refs' : array{
      for $item in $node//(tei:placeName|tei:persName|tei:orgName|tei:objectName|tei:geogName)[@ref = '#' || $object/tei:objectId ]
      return $item/@xml:id
      }
    }
  return map{
    'persons' : array{ $persons },
    'places' : array{ $places },
    'objects' : array{ $objects }
  }
};

(:~
 : this function get next div
 :
 : @param $node node to process
 : @param $options options
 : @return a kind of apply-templates
 :)
declare function getNextDiv($nodes, $options as map(*)) {
  for $node in $nodes/node()
  return getToc($node, $options)
};

(:~
 : this function get the section title
 : @param $node node to process
 : @param $options options
 : @todo genericise to deal with textitem ?
 :)
declare function getTextIdFromIndex($item as element(), $options as map(*)) as element()* {
  $item/tei:metadata/tei:textId
};

(:~
 : this function get the section title
 : @param $node node to process
 : @param $options options
 : @todo genericise to deal with textitem ?
 :)
declare function getSectionTitleFromIndex($item as element(), $options as map(*)) as element()* {
  getSectionTitle($item/tei:metadata/tei:title)
};

(:~
 : this function get the section title
 : @param $node node to process
 : @param $options options
 : @todo deals with suplied or use the ft index (upper)
 : @todo gdpPiganiol1742T01BodyFr02.004.013 titres label de p
 :)
declare function getSectionTitle($nodes) as element()* {
  for $node in $nodes return
  switch ($node)
    case ($node[tei:head]) return for $head in $node/tei:head return dispatch($head, map{})
    case ($node[tei:label]) return for $label in $node/tei:label return dispatch($label, map{})
    case ($node[*/tei:label]) return dispatch(($node/*/tei:label)[1], map{})
    default return ()
};


(:~
 : this function dispatches the treatment of the XML document
 : @bug there is no reason to serialize tei from there
 :)
declare
  %output:indent('no')
function dispatch($nodes as node()*, $options as map(*)) as item()* {
  for $node in $nodes
  return typeswitch($node)
    case text() return $node[fn:normalize-space(.)!='']
    case element(tei:head) return element tei:head { passthru($node, map{})}
    case element(tei:label) return element tei:head { passthru($node, map{})}
    case element(tei:supplied) return ("[", passthru($node, $options), "]")
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
 : this function get the pagination
 :
 : @param $text text to process
 : @param $options options
 : @return a sequence of map
 :)
declare function getPagination($node, $options as map(*)) {
  for $text in $node//tei:text
  return map{
    'uuid' : $text/@xml:id,
    'vol' : getVolume($text, map{ 'label' : $text/@n }),
    'pages' : getPagesByBook($text//tei:pb, map{})
  }
};

declare function getVolume($text, $options as map(*)) as map(*) {
  if ($options?label = 1) then map {
     'label' : <p>Tome 1<hi rend="superscript">er</hi></p>,
     'n' : $options?label,
     'unit' : 'T.'
     }
  else map {
     'label' :  element p {
        ('Tome ' || $options?label),
        element hi {
          attribute rend {'superscript'},
          'e'
        }
     },
     'n' : $options?label,
     'unit' : 'T.'
   }
};

(: @todo deal with sic in fw :)
declare function getPagesByBook($nodes, $options as map(*)) {
  for $page in $nodes
  return map{
    'pageNum' :
      if ($page/following-sibling::tei:fw[@type='pageNum'][1]/tei:sic)
      then '[' || ($page/following-sibling::tei:fw[@type='pageNum'][1] => fn:normalize-space()) || ']'
      else if ($page/following-sibling::tei:fw[@type='pageNum'][1] => fn:normalize-space() = '') then '[s.p.]'
      else $page/following-sibling::tei:fw[@type='pageNum'][1] => fn:normalize-space(),
    'pageBreak' : $page/@xml:id,
    'uuid' : $page/ancestor::tei:div[1]/@xml:id
  }
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
  case ($node[@rend='caps' or @rend='uppercase']) return <span class="uppercase">{ passthru($node, $options) }</span>
  case ($node[@rend='smallcaps' or @rend='sc']) return <span class="small-caps">{ passthru($node, $options) }</span>
  default return <span class="{$node/@rend}">{ passthru($node, $options) }</span>
};

declare function emph($node as element(tei:emph), $options as map(*)) {
  <em class="emph">{ passthru($node, $options) }</em>
};

declare function label($node as element(tei:label), $options as map(*)) {
  <span class="label">{ passthru($node, $options) }</span>
};