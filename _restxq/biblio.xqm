xquery version "3.1" ;
module namespace gdp.biblio = "gdp.biblio" ;

(:~
 : This module is a RESTXQ for Paris' guidebooks bibliography
 :
 : @version 1.0
 : @date 2019-05
 : @since 2015-02-22
 : @author emchateau (Cluster Pasts in the Present)
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework
 : see <https://github.com/ahn-ens-lyon/synopsx>
 : It is distributed under the GNU General Public Licence,
 : see <http://www.gnu.org/licenses/>
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

import module namespace G = 'synopsx.globals' at '../../../../synopsx/globals.xqm' ;
import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module namespace gdp.models.tei = "gdp.models.tei" at '../models/tei.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../../synopsx/mappings/htmlWrapping.xqm' ;
import module namespace gdp.mappings.jsoner = 'gdp.mappings.jsoner' at '../mappings/jsoner.xqm' ;

declare default function namespace 'gdp.biblio';

(:~
 : Simple description of a bibliographic module in RESTXQ
 : @author emchateau
 : @date 2019-04
 : @since 2014-04-05
 : @version 2.0
 : @see https://github.com/publicarchitectura/webapp
:)

(:~
 : resource function redirects to the works list
 :
 : @return redirect to the works list
 :)
declare %rest:path("/bibliography")
function bibliography(){
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/bibliography/home"/>
    </http:response>
  </rest:response>
};

(:~
 : resource function the bibliography home
 :
 : @return a collection of available bibliographical expressions
 :)
declare
  %rest:path("/bibliography/home")
function biblHome() {
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/bibliography/expressions"/>
    </http:response>
  </rest:response>
};

(:~
 : resource function for the works
 :
 : @return an html collection of works
 :)
declare
  %rest:path("/bibliography/works")
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function works() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalWorksList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incBiblioItem.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : resource function for the works
 :
 : @return a json html collection of works
 :)
declare
  %rest:path("/bibliography/works")
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function worksJson() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalWorksList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : ressource function for a bibliographical work item
 :
 : @param $workId the bibliographical work item ID
 : @return an html bibliographical work by ID
 :)
declare
  %rest:path('/bibliography/works/{$workId}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function work($workId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalWork',
    'workId' : $workId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incBiblioItem.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : ressource function for a bibliographical work item
 :
 : @param $workId the bibliographical work item ID
 : @return a json bibliographical work by ID
 :)
declare
  %rest:path('/bibliography/works/{$workId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function workJson($workId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalWork',
    'workId' : $workId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : ressource function for a bibliographical expressions list
 :
 : @return an html collection of bibliographical expressions
 :)
declare
  %rest:path('/bibliography/expressions')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function expressions() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalExpressionsList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incBiblioItem.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : ressource function for a bibliographical expressions list
 :
 : @return an html collection of bibliographical expressions
 :)
declare
  %rest:path('/bibliography/expressions')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function expressionsJson() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalExpressionsList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : ressource function for a bibliographical expression item
 :
 : @param $expressionId the bibliographical work expression ID
 : @return an html bibliographical expression by ID
 :)
declare
  %rest:path('/bibliography/expressions/{$expressionId}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version("5.0")
function expression($expressionId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalExpression',
    'expressionId' : $expressionId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incBiblioItem.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : ressource function for a bibliographical expression item
 :
 : @param $expressionId the bibliographical work expression ID
 : @return a json bibliographical expression by ID
 :)
declare
  %rest:path('/bibliography/expressions/{$expressionId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function expressionJson($expressionId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalExpression',
    'expressionId' : $expressionId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : ressource function for a bibliographical manifestations list
 :
 : @return an html collection of bibliographical manifestations
 :)
declare
  %rest:path('/bibliography/manifestations')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function manifestations() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalManifestationsList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incBiblioItem.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : ressource function for a bibliographical manifestations list
 :
 : @return a json collection of bibliographical manifestations
 :)
declare
  %rest:path('/bibliography/manifestations')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function manifestationsJson() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalManifestationsList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incBiblioItem.xhtml',
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : ressource function for a bibliographical manifestation item
 :
 : @param $manifestationId the bibliographical work expression ID
 : @return an html bibliographical expression by ID
 :
 : @ex http://localhost:8984/bibliography/manifestations/brice1684bManifestation
 :)
declare
  %rest:path('/bibliography/manifestations/{$manifestationId}')
  %rest:produces('*/*', 'text/html')
  %output:method("html")
  %output:html-version("5.0")
function manifestation($manifestationId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalManifestation',
    'manifestationId' : $manifestationId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incBiblioItem.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : ressource function for a bibliographical manifestation item
 :
 : @param $manifestationId the bibliographical work expression ID
 : @return a json bibliographical expression by ID
 :)
declare
  %rest:path('/bibliography/manifestations/{$manifestationId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function manifestationJson($manifestationId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalManifestation',
    'manifestationId' : $manifestationId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)  
};

(:~
 : ressource function for a bibliographical item list
 :
 : @return an html collection of bibliographical items
 : @rmq none defined as 2019
 :)
declare
  %rest:path('/bibliography/items')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function items() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalItemsList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incBiblioItem.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : ressource function for a bibliographical item list
 :
 : @return a json collection of bibliographical items
 : @rmq none defined as 2019
 :)
declare
  %rest:path('/bibliography/items')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function itemsJson() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalItemsList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incBiblioItem.xhtml',
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : ressource function for a bibliographical item
 :
 : @param $itemId the bibliographical item ID
 : @return an html bibliographical item by ID
 : @rmq none defined as 2019
 :)
declare
  %rest:path('/bibliography/items/{$itemId}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function gdp.biblio:item($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incBiblioItem.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : ressource function for a bibliographical item
 :
 : @param $itemId the bibliographical item ID
 : @return a json bibliographical item by ID
 : @rmq none defined as 2019
 :)
declare
  %rest:path('/bibliography/items/{$itemId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function gdp.biblio:itemJson($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incBiblioItem.xhtml',
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)  
};