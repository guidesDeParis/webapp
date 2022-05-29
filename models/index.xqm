xquery version "3.1" ;
module namespace gdp.models.index = 'gdp.models.index' ;

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
(: module namespace gdp.models.index = 'gdp.models.index' ; :)

declare namespace db = "http://basex.org/modules/db" ;
declare namespace file = "http://expath.org/ns/file" ;
declare namespace http = 'http://expath.org/ns/http-client';
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization" ;
declare namespace request = 'http://exquery.org/ns/request';
declare namespace rest = "http://exquery.org/ns/restxq" ;
declare namespace update = "http://basex.org/modules/update" ;
declare namespace web = "http://basex.org/modules/web" ;
declare namespace json = "http://basex.org/modules/json" ;

declare namespace perm = "http://basex.org/modules/perm" ;
declare namespace user = "http://basex.org/modules/user" ;
declare namespace session = 'http://basex.org/modules/session' ;

declare namespace tei = 'http://www.tei-c.org/ns/1.0' ;

import module namespace gdp.globals = 'gdp.globals' at '../globals.xqm' ;
import module namespace gdp.models.tei = "gdp.models.tei" at './tei.xqm' ;

declare default function namespace 'gdp.models.index' ;

import module namespace gdp.mappings.jsoner = 'gdp.mappings.jsoner' at '../mappings/jsoner.xqm' ;

(:~
 : this function create a ref for each named-entity in the corpus
 :)
declare
  %updating
function addId2IndexedEntities($indexId) {
  let $db := db:open('gdp')
  let $index := $db//tei:TEI[tei:teiHeader//tei:sourceDesc[@xml:id = $indexId]]
  for $occurence in fn:distinct-values($index//tei:listRelation/tei:relation/@passive ! fn:tokenize(., '\s+'))
    let $entries := $index//*[tei:listRelation/tei:relation[fn:contains(@passive, $occurence)]]
    let $element := $db//*[@xml:id = fn:substring-after($occurence, '#')]
    let $values := for $entry in $entries/@xml:id return fn:concat('#', $entry)
  return if ($element[fn:not(@ref)])
    then insert node attribute ref { $values } into $element
    else replace value of node $element/@ref with $values
};

(:~
 : This function
 :)
declare
  %updating
function getIndex() {
  let $db := db:open('gdp')/tei:teiCorpus
  let $gdpft := getGdpft($db)
  return db:create(
  'gdpft',
  $gdpft,
  'gdpft',
  map {
      'ftindex': fn:true(),
      'stemming': fn:true(),
      'casesens': fn:true(),
      'diacritics': fn:true(),
      'language': 'fr',
      'updindex': fn:true(),
      'autooptimize': fn:true(),
      'maxlen': 96,
      'maxcats': 100,
      'splitsize': 0,
      'chop': fn:false(),
      'textindex': fn:true(),
      'attrindex': fn:true(),
      'tokenindex': fn:true(),
      'xinclude': fn:true()
    }
  )
};


(:~
 : This function returns a deep copy of the elements and all sub-elements
 : (identity transform with typeswitch)
 : copies the input to the output without modification
 : @source http://en.wikibooks.org/wiki/XQuery/Typeswitch_Transformations
 : @todo treat the lists, labels, titles, fw, pb, etc.
 :)
declare
  %output:indent('no')
function getGdpft($items as item()*) as item()* {
  for $node in $items return typeswitch($node)
  case text() return $node[fn:normalize-space(.)!='']
  case comment() return ()
  case element(tei:persName) return $node ! getGdpft(./node())
  case element(tei:placeName) return $node ! getGdpft(./node())
  case element(tei:objectName) return $node ! getGdpft(./node())
  case element(tei:orgName) return $node ! getGdpft(./node())
  case element(tei:geogName) return $node ! getGdpft(./node())

  case element(tei:hi) return $node ! getGdpft(./node())
  case element(tei:label) return $node ! getGdpft(./node())

  case element(tei:fw) return ()
  case element(tei:pb) return ()

  case element(tei:div) return $node ! getDiv(.)

  case element(tei:item) return $node ! (' ', getGdpft(./node()))
  case element(tei:list) return $node ! getGdpft(./node())
  case element(tei:l) return $node ! getGdpft(./node())
  case element(tei:lg) return $node ! getGdpft(./node())

  case element(tei:lb) return (' ')
  case element(tei:q) return $node ! getGdpft(./node())
  case element(tei:quote) return $node ! getGdpft(./node())
  case element(tei:ref) return $node ! getGdpft(./node())
  case element(tei:rs) return $node ! getGdpft(./node())
  case element(tei:seg) return $node ! getGdpft(./node())
  case element(tei:sic) return $node ! getGdpft(./node())
  case element(tei:soCalled) return $node ! getGdpft(./node())
  case element(tei:supplied) return $node ! getGdpft(./node())
  case element(tei:title) return $node ! getGdpft(./node())
  case element(tei:unclear) return $node ! getGdpft(./node())
  case element(tei:metamark) return ()

  case element(tei:abbr) return $node ! getGdpft(./node())
  case element(tei:bibl) return $node ! getGdpft(./node())
  case element(tei:date) return $node ! getGdpft(./node())
  case element(tei:emph) return $node ! getGdpft(./node())
  case element(tei:expan) return $node ! getGdpft(./node())
  case element(tei:foreign) return $node ! getGdpft(./node())
  case element(tei:geo) return $node ! getGdpft(./node())
  case element(tei:num) return $node ! (' ', getGdpft(./node()))
  case element(tei:space) return ()
  case element(tei:cb) return ()
  case element(tei:surplus) return ()
  case element(tei:gap) return ()
  case element(tei:trailer) return ()
  (: figure cit orig reg :)

  case element() return element {fn:name($node)} {
    (:namespace {"tei"} { "http://www.tei-c.org/ns/1.0" },:)
    (: output each attribute in this element :)
    for $att in $node/@*
    return attribute {fn:name($att)} {$att},
    (: output all the sub-elements of this element recursively :)
    $node ! getGdpft(./node())
  }
  (: otherwise pass it through.  Used for text(), comments, and PIs :)
  default return $node
};

declare function getDiv($node) {
  <div>{
    for $att in $node/@*
    return attribute {fn:name($att)} {$att},
    (: output all the sub-elements of this element recursively :)
    $node ! getGdpft(./node()),
    <meta>
      <uuid>{$node/@xml:id}</uuid>
      <pages>{pages($node)}</pages>
      <size>{wordsCount($node)}</size>
      <indexes>{indexEntries($node)}</indexes>
    </meta>
  }</div>
};

(:~
 : this function get pages for an item
 :)
declare function pages($item as element()) as element()* {
  let $pageBefore := $item/preceding::tei:fw[@type = 'pageNum'][1]
  let $fw := $item//tei:fw[@type = 'pageNum']
  (:let $pages := ($pageBefore, $fw):)
  return (
    <prefix>{if ($fw) then 'pp.' else 'p.'}</prefix>,
    <range>{fn:string-join(($pageBefore, $fw[fn:last()]), '–')}</range>
  )
};

(:~
 : this function get the words count
 :
 : @param $item text item to count
 : @param $options options
 : @return a quantity and a unit
 :)
declare function wordsCount($item as element()) as xs:integer {
  fn:count(fn:tokenize($item, '\W+')[. != ''])
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
declare function indexEntries($item as element()) as item()* {
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
    return
        <persons>
          <title>{$person/tei:persName[1]}</title>
          <uuid>{$uuid}</uuid>
          <path>/indexNominum/</path>
          <url>{$gdp.globals:root || '/indexNominum/' || $uuid}</url>
        </persons>
  let $places :=
     for $placeRef in $placesRefs
     return $db//tei:place[tei:listRelation/tei:relation[fn:contains(@passive, '#' || $placeRef)]]
  let $placesMap :=
     for $place in $places
     let $uuid := $place/@xml:id
     return
        <places>
          <title>{$place/tei:placeName[1]}</title>
          <uuid>{$uuid}</uuid>
          <path>/indexLocorum/</path>
          <url>{$gdp.globals:root || '/indexLocorum/' || $uuid}</url>
        </places>
  let $objects :=
     for $objectRef in $objectsRefs
     return $db//tei:object[tei:listRelation/tei:relation[fn:contains(@passive, '#' || $objectRef)]]
  let $objectsMap :=
     for $object in $objects
       let $uuid := $object/@xml:id
       return
        <objects>
          <title>{$object/tei:objectName[1]}</title>
          <uuid>{$uuid}</uuid>
          <path>/indexOperum/</path>
          <url>{$gdp.globals:root || '/indexOperum/' || $uuid}</url>
        </objects>
  (:let $objects :=
      for $objectsRef in $objectsRefs[@ref]
      return fn:substring-after($objectsRef/@ref, '#') => fn:distinct-values()
    let $objectsMap :=
      for $object in $db//*[@xml:id = $objects]
      return map {
        'title' : $object/tei:objectName[1],
        'uuid' : $object/@xml:id
      }:)
  return (
    $personsMap,
    $placesMap,
    $objectsMap
    )
};

(:~
 : this function create a toc db
 : @bug, can’t work because it’s not possible to create a db from maps
 :)
declare
  %updating
function createTocs($queryParams, $outputParams) {
  let $db := db:open('gdp')
  let $ids := $db/tei:teiCorpus/tei:teiCorpus/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc[tei:bibl]/@xml:id
  let $tocs :=
    for $id in $ids
    let $queryParams := map:merge(($queryParams, map { 'textId' : $id }))
    return gdp.models.tei:getTocByTextId( $queryParams )
  return db:create(
    'gdpTocs',
    for $toc in $tocs
      return fn:serialize(
      gdp.mappings.jsoner:jsoner($queryParams, $toc, $outputParams), map{"method" : "json"}) => json:parse(),
    for $id in $ids return $id,
    map {
      'ftindex': fn:true(),
      'stemming': fn:true(),
      'casesens': fn:true(),
      'diacritics': fn:true(),
      'language': 'fr',
      'updindex': fn:true(),
      'autooptimize': fn:true(),
      'maxlen': 96,
      'maxcats': 100,
      'splitsize': 0,
      'chop': fn:false(),
      'textindex': fn:true(),
      'attrindex': fn:true(),
      'tokenindex': fn:true(),
      'xinclude': fn:true()
    }
  )
};
