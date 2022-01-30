xquery version "3.1" ;
module namespace gdp.entities = 'gdp.entities' ;

(:~
 : This module is a rest for Paris' guidebooks electronic edition
 :
 : @version 1.0
 : @date 2021-07
 : @since 2015-02-05 
 : @author emchateau (Cluster Pasts in the Present), carolinecorbieres
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
 :)

import module namespace rest = 'http://exquery.org/ns/restxq';

import module namespace gdp.models.tei = "gdp.models.tei" at '../models/tei.xqm' ;
import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;
import module namespace gdp.mappings.jsoner = 'gdp.mappings.jsoner' at '../mappings/jsoner.xqm' ;
import module namespace gdp.mappings.tei2rdf = 'gdp.mappings.tei2rdf' at '../mappings/tei2rdf.xqm' ;

declare namespace tei = 'http://www.tei-c.org/ns/1.0' ;

declare default function namespace 'gdp.entities' ;

(:~
 : resource function for the places
 :
 : @return an html list of places entries
 :)
declare 
  %rest:path('/places')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function places(
  $start as xs:integer,
  $count as xs:integer,
  $text as xs:string*,
  $letter as xs:string
  ) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexLocorum',
    'start' : $start,
    'count' : $count,
    'text' : $text,
    'letter' : $letter
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incIndex.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for the places
 :
 : @return a json list of places entries
 :)
declare 
  %rest:path('/places')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function placesJson(
  $start as xs:integer,
  $count as xs:integer,
  $text as xs:string*,
  $letter as xs:string
  ) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexLocorum',
    'start' : $start,
    'count' : $count,
    'text' : $text,
    'letter' : $letter
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for the places item
 :
 : @param $itemId the item ID
 : @return an html representation of an places item
 :)
declare 
  %rest:path('/places/{$itemId}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function placesItem($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexLocorumItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incplaces.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for the places item
 :
 : @param $itemId the item ID
 : @return a json representation of an places item
 :)
declare 
  %rest:path('/places/{$itemId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function placesItemJson($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexLocorumItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

 
(:~
 : resource function for the places item
 :
 : @param $itemId the item ID
 : @return a rdf representation of an places item
 :)
declare 
  %rest:path('/places/{$itemId}')
  %rest:produces('application/rdf+xml')
  %output:media-type('application/rdf+xml')
  %output:method('xml')
function placesItemRdf($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'itemId' : $itemId
    }
  let $result := synopsx.models.synopsx:getDb($queryParams)//(tei:place)[@xml:id = $itemId]
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.tei2rdf:tei2rdf($queryParams, $result, $outputParams)
};

(:~
 : resource function for the works
 :
 : @return an html list of works entries
 :)
declare 
  %rest:path('/works')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function works(
  $start as xs:integer,
  $count as xs:integer,
  $text as xs:string*,
  $letter as xs:string
  ) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexOperum',
    'start' : $start,
    'count' : $count,
    'text' : $text,
    'letter' : $letter
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incIndex.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for the works
 :
 : @return a json list of works entries
 :)
declare 
  %rest:path('/works')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function worksJson(
  $start as xs:integer,
  $count as xs:integer,
  $text as xs:string*,
  $letter as xs:string
  ) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexOperum',
    'start' : $start,
    'count' : $count,
    'text' : $text,
    'letter' : $letter
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for the works item
 :
 : @param $itemId the item ID
 : @return an html reprenstation of an works item
 :)
declare 
  %rest:path('/works/{$itemId}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function worksItem($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexOperumItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incworks.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for the works item
 :
 : @param $itemId the item ID
 : @return a json reprenstation of an works item
 :)
declare 
  %rest:path('/works/{$itemId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function worksItemJson($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexOperumItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

 
(:~
 : resource function for the works item
 :
 : @param $itemId the item ID
 : @return a rdf representation of an works item
 :)
declare 
  %rest:path('/works/{$itemId}')
  %rest:produces('application/rdf+xml')
  %output:media-type('application/rdf+xml')
  %output:method('xml')
function worksItemRdf($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'itemId' : $itemId
    }
  let $result := synopsx.models.synopsx:getDb($queryParams)//(tei:object)[@xml:id = $itemId]
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.tei2rdf:tei2rdf($queryParams, $result, $outputParams)
};

(:~
 : resource function for the persons
 :
 : @return a html list of persons entries
 :)
declare 
  %rest:path('/persons')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function persons(
  $start as xs:integer,
  $count as xs:integer,
  $text as xs:string*,
  $letter as xs:string
  ) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexNominum',
    'start' : $start,
    'count' : $count,
    'text' : $text,
    'letter' : $letter
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incIndex.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for the persons
 :
 : @return a json list of persons entries
 :)
declare 
  %rest:path('/persons')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function personsJson(
  $start as xs:integer,
  $count as xs:integer,
  $text as xs:string*,
  $letter as xs:string
  ) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexNominum',
    'start' : $start,
    'count' : $count,
    'text' : $text,
    'letter' : $letter
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for the persons item
 :
 : @param $itemId the item ID
 : @return an html representation of an persons item
 :)
declare 
  %rest:path('/persons/{$itemId}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function personsItem($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexNominumItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incpersons.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for the persons item
 :
 : @param $itemId the item ID
 : @return a json representation of an persons item
 :)
declare 
  %rest:path('/persons/{$itemId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function personsItemJson($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexNominumItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};
 
(:~
 : resource function for the persons item
 :
 : @param $itemId the item ID
 : @return a rdf representation of an persons item
 :)
declare 
  %rest:path('/persons/{$itemId}')
  %rest:produces('application/rdf+xml')
  %output:media-type('application/rdf+xml')
  %output:method('xml')
function personsItemRdf($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'itemId' : $itemId
    }
  let $result := synopsx.models.synopsx:getDb($queryParams)//(tei:person|tei:org)[@xml:id = $itemId]
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.tei2rdf:tei2rdf($queryParams, $result, $outputParams)
};