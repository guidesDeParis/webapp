xquery version "3.1" ;
module namespace gdp.config = 'gdp.config' ;

(:~
 : This module is a rest for Paris' guidebooks electronic edition
 :
 : @version 2.0
 : @date 2022-01
 : @since 2022-01
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
import module namespace gdp.models.index = "gdp.models.index" at '../models/index.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;
import module namespace gdp.mappings.jsoner = 'gdp.mappings.jsoner' at '../mappings/jsoner.xqm' ;
import module namespace gdp.mappings.tei2rdf = 'gdp.mappings.tei2rdf' at '../mappings/tei2rdf.xqm' ;

declare default function namespace 'gdp.config' ;

(:~
 : resource function for the install
 :
 : @return an action list
 : @todo add a confirmation message
 :)
declare
  %rest:path('/install')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function editionHome() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : ''
    }
  (:let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams):)
  let $result := map{
    'meta' : map {},
    'content' : map {
      'message' : '' (: request:header-names() doesn’t work :)
    }
  }
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incConfig.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};



(:~
 : resource function for indexing
 :
 : @param $itemId the item ID
 : @return a jsonLD representation of an indexNominum item
 : @todo add operum
 :)
declare
  %rest:path('/indexing')
  %updating
function indexing() {
  let $indexId := ('gdpIndexNominum', 'gdpIndexLocorum')
  return (
    for $index in $indexId return gdp.models.index:addId2IndexedEntities($index),
    update:output(
      (
        <rest:response>
          <http:response status="302">
            <http:header name="Location" value="install"/>
            <http:header name="Content-Language" value="fr"/>
            <http:header name="Content-Type" value="text/plain; charset=utf-8"/>
          </http:response>
        </rest:response>,
        <body>
          <message>La ressource a été modifiée.</message>
          <url></url>
        </body>
        )
      )
    )
};

(:~
 : this resource function creates the full-text index
 : @return an empty element
 :)
declare
  %rest:path('/makeftindex')
  %updating
function makeFtindex() {
  gdp.models.index:getIndex()
};

(:~
 : resource function for indexing
 :
 : @param $itemId the item ID
 : @return a jsonLD representation of an indexNominum item
 : @todo add operum
 :)
declare
  %rest:path('/toc')
  %updating
function toc() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei'
  }
  let $outputParams := map {
      'xquery' : 'tei2html'
      }
  return (
    gdp.models.index:createTocs($queryParams, $outputParams),
    update:output(
      (
        <rest:response>
          <http:response status="302">
            <http:header name="Location" value="install"/>
            <http:header name="Content-Language" value="fr"/>
            <http:header name="Content-Type" value="text/plain; charset=utf-8"/>
          </http:response>
        </rest:response>,
        <body>
          <message>Les tables des matières ont été créées.</message>
          <url></url>
        </body>
        )
      )
    )
};