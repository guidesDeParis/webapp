xquery version "3.0" ;
module namespace gdp.biblio = "gdp.biblio" ;

(:~
 : This module is a RESTXQ for Paris' guidebooks bibliography
 :
 : @author emchateau (Cluster Pasts in the Present)
 : @since 2015-02-22 
 : @version 0.3
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see <https://github.com/ahn-ens-lyon/synopsx> 
 : It is distributed under the GNU General Public Licence, 
 : see <http://www.gnu.org/licenses/>
 :
 : @qst give webpath by dates and pages ?
 :)

import module namespace restxq = 'http://exquery.org/ns/restxq';

import module namespace G = 'synopsx.globals' at '../../../../synopsx/globals.xqm' ;
import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../../../lib/commons.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../../synopsx/mappings/htmlWrapping.xqm' ;

declare default function namespace 'gdp.biblio';

(:~
 : Simple description of a bibliographic module in RESTXQ
 : @author Emmanuel Chateau
 : @date 2014-04-05
 : @version 1.0
 : @see https://github.com/publicarchitectura/webappBasex
:)

(:~
 : resource function redirects to the works list
 :
 : @return redirect to the works list
 :)
declare %restxq:path("/gdp/bibliography")
function bibliography(){
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/gdp/bibliography/works"/>
    </http:response>
  </rest:response>
};

(:~
 : resource function for the works
 :
 : @return a collection of works
 :)
declare 
  %restxq:path("/gdp/bibliography/works")
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function biblWorks() {
  let $queryParams := map { 
    'project' : 'gdpWebapp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getWorksList'
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsArticleSerif.xhtml',
    'xquery' : 'tei2html'
    (: specify an xslt mode and other kind of output options :)
    }
  return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $data, $outputParams)
};

(:~
 : ressource function for a bibliographical work item
 : 
 : @param $workId the bibliographical work item ID
 : @return a bibliographical work by ID
 :)
declare 
  %restxq:path('/gdp/bibliography/works/{$workId}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function biblWork($workId) {
  let $queryParams := map {
    'project' : 'gdpWebapp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getWork',
    'workId' : $workId
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsArticleSerif.xhtml',
    'xquery' : 'tei2html'
    (: specify an xslt mode and other kind of output options :)
    }
  return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $data, $outputParams)
};

(:~
 : ressource function for a bibliographical expressions list
 : 
 : @return a collection of bibliographical expressions
 :)
declare 
  %restxq:path('/gdp/bibliography/expressions')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function biblExpressions() {
  let $queryParams := map {
    'project' : 'gdpWebapp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalExpressionsList'
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsArticleSerif.xhtml',
    'xquery' : 'tei2html'
    (: specify an xslt mode and other kind of output options :)
    }
  return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $data, $outputParams)
};

(:~
 : ressource function for a bibliographical expression item
 : 
 : @param $expressionId the bibliographical work expression ID
 : @return a bibliographical expression by ID
 :)
declare 
  %restxq:path('/gdp/bibliography/expressions/{$expressionId}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function biblExpression($expressionId) {
  let $queryParams := map {
    'project' : 'gdpWebapp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalExpression',
    'expressionId' : $expressionId
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsArticleSerif.xhtml',
    'xquery' : 'tei2html'
    (: specify an xslt mode and other kind of output options :)
    }
  return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $data, $outputParams)
};

(:~
 : ressource function for a bibliographical item list
 : 
 : @return a collection of bibliographical items
 :)
declare 
  %restxq:path('/gdp/bibliography/items')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function biblItems() {
  let $queryParams := map {
    'project' : 'gdpWebapp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalItemsList'
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsArticleSerif.xhtml',
    'xquery' : 'tei2html'
    (: specify an xslt mode and other kind of output options :)
    }
  return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $data, $outputParams)
};

(:~
 : ressource function for a bibliographical item
 : 
 : @param $itemId the bibliographical item ID
 : @return a bibliographical item by ID
 :)
declare 
  %restxq:path('/gdp/bibliography/items/{$itemId}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function biblItem($itemId) {
  let $queryParams := map {
    'project' : 'gdpWebapp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalItem',
    'itemId' : $itemId
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsArticleSerif.xhtml',
    'xquery' : 'tei2html'
    (: specify an xslt mode and other kind of output options :)
    }
  return synopsx.mappings.htmlWrapping:wrapperNew($queryParams, $data, $outputParams)
};