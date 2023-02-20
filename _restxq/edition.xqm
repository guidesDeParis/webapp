xquery version "3.1" ;
module namespace gdp.edition = 'gdp.edition' ;

(:~
 : This module is a rest for Paris' guidebooks electronic edition
 :
 : @version 1.0
 : @date 2019-05
 : @since 2015-02-05 
 : @author emchateau (Cluster Pasts in the Present)
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
 : @qst give webpath by dates and pages ?
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

import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module namespace gdp.models.tei = "gdp.models.tei" at '../models/tei.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;
import module namespace gdp.mappings.jsoner = 'gdp.mappings.jsoner' at '../mappings/jsoner.xqm' ;
import module namespace gdp.mappings.tei2rdf = 'gdp.mappings.tei2rdf' at '../mappings/tei2rdf.xqm' ;

declare default function namespace 'gdp.edition' ;

(:~
 : this resource function redirect to /home
 :)
declare 
  %rest:path('/')
function index() {
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/corpus"/>
    </http:response>
  </rest:response>
};

(:~
 : resource function for corpus list
 :
 : @return a json representation of the corpus resource
 :)
declare 
  %rest:path('/corpus')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %output:json("indent=no, escape=yes")
function corpusJson() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getCorpusList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for a corpus ID
 :
 : @param $corpusId the corpus ID
 : @return a json representation of the corpus resource
 :)
declare 
  %rest:path('/corpus/{$corpusId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function corpusItemJson($corpusId as xs:string) {
  let $queryParams := map {
    'corpusId' : $corpusId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getCorpusById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for a text by ID
 :
 : @param $textId the text ID
 : @return a json representation of the text resource
 :)
declare 
  %rest:path('/texts/{$textId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function textItemsJson($textId as xs:string) {
  let $queryParams := map {
    'textId' : $textId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getTextById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for text toc by ID
 :
 : @param $textId the text ID
 : @return a json toc of the text
 :)
declare 
  %rest:path('/texts/{$textId}/toc/old')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function textItemsTocJson($textId as xs:string) {
  let $queryParams := map {
    'textId' : $textId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getTocByTextId'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};


(:~
 : resource function for text toc by ID
 :
 : @param $textId the text ID
 : @return a json toc of the text
 :)
declare
  %rest:path('/texts/{$textId}/toc')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %output:json("indent=no, escape=yes")
function getTocByDb($textId as xs:string) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'textId' : $textId
    }
  return db:open("gdpTocs", $textId)
};

(:~
 : resource function for text pagination
 :
 : @param $textId the text ID
 : @return a json toc of the text
 :)
declare
  %rest:path('/texts/{$textId}/pagination')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function textItemsPaginationJson($textId as xs:string) {
  let $queryParams := map {
    'textId' : $textId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getPaginationByTextId'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for a text item by ID
 :
 : @param $corpusId the text item ID
 : @param $depth render the content in depth true of false
 : @return a json representation of the text item
 :)
declare 
  %rest:path('/items/{$itemId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:query-param("depth", "{$depth}", 0)
function itemsJson($itemId as xs:string, $depth as xs:boolean) {
  let $queryParams := map {
    
    'itemId' : $itemId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'depth' : $depth,
    'function' : 'getItemById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for a text item by ID
 :
 : @param $corpusId the text item ID
 : @param $depth render the content in depth true of false
 : @return a json representation of the text item
 :)
declare
  %rest:path('/items/{$itemId}/indexes')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:query-param("depth", "{$depth}", 1)
function itemsIndexesJson($itemId as xs:string, $depth as xs:boolean) {
  let $queryParams := map {

    'itemId' : $itemId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getItemIndexesById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for a text item by ID
 :
 : @param $corpusId the text item ID
 : @param $depth render the content in depth true of false
 : @return a json representation of the text item
 :)
declare
  %rest:path('/texts/{$textId}/{$itemId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:query-param("depth", "{$depth}", 1)
function textItemsJson($textId as xs:string, $itemId as xs:string, $depth as xs:boolean) {
  let $queryParams := map {

    'itemId' : $itemId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'depth' : $depth,
    'function' : 'getItemById'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : this resource function is a about page
 : @return a json representation of the about content
 :)
declare
  %rest:path('/colophon')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function getEditorial() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getEditorial'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
      'xquery' : 'tei2html'
      }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : this resource function is a about page
 : @return a json representation of the about content
 :)
declare 
  %rest:path('/colophon/{$id}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function getEditorialContent($id) {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getContent',
    'itemId' : 'gdp' || fn:substring($id, 1, 1) => fn:upper-case() || fn:substring($id, 2)
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
      'xquery' : 'tei2html'
      }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : this resource function is a model documentation page
 : @return a json representation of the model documentation
 :)
declare
  %rest:path('/colophon/model')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function getModel() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getContent',
    'itemId' : 'gdpSchema'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
      'xquery' : 'tei2html'
      }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : this resource function is an application guide
 : @return a json representation of the guide content
 :)
declare
  %rest:path('/colophon/guide')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function getGuide() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getContent',
    'itemId' : 'gdpGuide'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
      'xquery' : 'tei2html'
      }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : this resource function is an application guide
 : @return a json representation of the guide content
 :)
declare
  %rest:path('/colophon/documentation')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function getDocumentation() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getContent',
    'itemId' : 'gdpAPI'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
      'xquery' : 'tei2html'
      }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for the indexLocorum
 :
 : @return a json list of indexLocorum entries
 :)
declare 
  %rest:path('/index')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function indexesJson() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : resource function for the indexLocorum
 :
 : @return a json list of indexLocorum entries
 :)
declare 
  %rest:path('/indexLocorum')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function indexLocorumJson(
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
 : resource function for the indexLocorum item
 :
 : @param $itemId the item ID
 : @return a json representation of an indexLocorum item
 :)
declare 
  %rest:path('/indexLocorum/{$itemId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function indexLocorumItemJson($itemId) {
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
 : resource function for the indexOperum
 :
 : @return a json list of indexOperum entries
 :)
declare 
  %rest:path('/indexOperum')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function indexOperumJson(
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
 : resource function for an indexOperum item
 :
 : @param $itemId the item ID
 : @return a json reprenstation of an indexOperum item
 :)
declare 
  %rest:path('/indexOperum/{$itemId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function indexOperumItemJson($itemId) {
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
 : resource function for the indexNominum
 :
 : @return a json list of indexNominum entries
 :)
declare 
  %rest:path('/indexNominum')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 100)
  %rest:query-param("text", "{$text}", 'all')
  %rest:query-param("letter", "{$letter}", 'all')
function indexNominumJson(
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
 : resource function for the indexNominum item
 :
 : @param $itemId the item ID
 : @return a json representation of an indexNominum item
 :)
declare 
  %rest:path('/indexNominum/{$itemId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function indexNominumItemJson($itemId) {
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
 : resource function for the indexNominum item
 :
 : @param $itemId the item ID
 : @return a jsonLD representation of an indexNominum item
 :)
declare 
  %rest:path('/indexNominum/{$itemId}/rdf')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function indexNominumItemRdf($itemId) {
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
    'xquery' : 'tei2rdf'
    }
    return gdp.mappings.tei2rdf:tei2rdf($queryParams, $result, $outputParams)
};

(:~
 : entrées d’index d’un texte ???
 :)
 
(:~
 : cartes et accès complexes 
 :)
