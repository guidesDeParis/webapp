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
import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module namespace gdp.models.tei = "gdp.models.tei" at '../models/tei.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../../synopsx/mappings/htmlWrapping.xqm' ;
import module namespace synopsx.mappings.jsoner = 'synopsx.mappings.jsoner' at '../../../../synopsx/mappings/jsoner.xqm' ;

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
declare %restxq:path("gdp/bibliography")
function bibliography(){
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/gdp/bibliography/home"/>
    </http:response>
  </rest:response>
};

(:~
 : resource function the bibliography home
 :
 : @return a collection of available bibliographical resources
 :)
declare
  %restxq:path("/gdp/bibliography/home")
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function biblHome() {
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/gdp/bibliography/expressions"/>
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
function works() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalWorksList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsBiblioWorksSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
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
function work($workId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalWork',
    'workId' : $workId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsBiblioSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
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
function expressions() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalExpressionsList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsBiblioSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
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
function expression($expressionId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalExpression',
    'expressionId' : $expressionId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsBiblioSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};

(:~
 : ressource function for a bibliographical manifestations list
 :
 : @return a collection of bibliographical manifestations
 :)
declare
  %restxq:path('/gdp/bibliography/manifestations')
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
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsBiblioSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};

(:~
 : ressource function for a bibliographical manifestation item
 :
 : @param $manifestationId the bibliographical work expression ID
 : @return a bibliographical expression by ID
 :)
declare
  %restxq:path('/gdp/bibliography/manifestations/{$manifestationId}')
  %rest:produces('text/html')
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
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsBiblioSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};

(:~
 : ressource function for a bibliographical manifestation item
 :
 : @param $manifestationId the bibliographical work expression ID
 : @return a bibliographical expression by ID
 :)
declare
  %restxq:path('/gdp/bibliography/manifestations/{$manifestationId}/json')
  %output:method("json")
  %output:json("format=jsonml")
function manifestationJson($manifestationId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalManifestation',
    'manifestationId' : $manifestationId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsBiblioSerif.xhtml',
    'xquery' : 'tei2json'
    }
  return 
    synopsx.mappings.jsoner:jsoner($queryParams, $data, $outputParams)
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
function items() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalItemsList'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsBiblioSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
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
function gdp.biblio:item($itemId) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getBibliographicalItem',
    'itemId' : $itemId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsBiblioSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};
