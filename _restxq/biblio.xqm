xquery version "3.0" ;
module namespace gdp.biblio = "gdp.biblio" ;
(:~
 : This module is a RESTXQ for the Paris' guidebooks electronic edition' blog
 :
 : @author Emmanuel Chateau (Cluster Pasts in the Present)
 : @date 2014-05-22
 : @version 0.3
 : @see https://github.com/guidesDeParis/
 : @see http://www.passes-present.eu/en/node/363
 : @todo paramétriser le rendu en adaptant le module de templating txq
 : @todo transférer le html dans une vue
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
    let $data := synopsx.lib.commons:getQueryFunction($queryParams)
    let $outputParams := map {
      'lang' : 'fr',
      'layout' : 'page.html',
      'pattern' : 'article.xhtml'
      (: specify an xslt mode and other kind of output options :)
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
function biblWork() {
    let $queryParams := map {
     'project' : 'gdpWebapp',
     'dbName' : 'gdp',
     'model' : 'tei',
     'function' : 'getWork'
     }
    let $data := synopsx.lib.commons:getQueryFunction($queryParams)
    let $outputParams := map {
      'lang' : 'fr',
      'layout' : 'page.html',
      'pattern' : 'article.xhtml'
      (: specify an xslt mode and other kind of output options :)
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
function biblExpressions() {
    let $queryParams := map {
     'project' : 'gdpWebapp',
     'dbName' : 'gdp',
     'model' : 'tei',
     'function' : 'getBibliographicalExpressionsList'
     }
    let $data := synopsx.lib.commons:getQueryFunction($queryParams)
    let $outputParams := map {
      'lang' : 'fr',
      'layout' : 'page.html',
      'pattern' : 'article.xhtml'
      (: specify an xslt mode and other kind of output options :)
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
function biblExpression() {
    let $queryParams := map {
     'project' : 'gdpWebapp',
     'dbName' : 'gdp',
     'model' : 'tei',
     'function' : 'getBibliographicalExpression'
     }
    let $data := synopsx.lib.commons:getQueryFunction($queryParams)
    let $outputParams := map {
      'lang' : 'fr',
      'layout' : 'page.html',
      'pattern' : 'article.xhtml'
      (: specify an xslt mode and other kind of output options :)
      }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
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
    let $data := synopsx.lib.commons:getQueryFunction($queryParams)
    let $outputParams := map {
      'lang' : 'fr',
      'layout' : 'page.html',
      'pattern' : 'article.xhtml'
      (: specify an xslt mode and other kind of output options :)
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
  %restxq:path('/gdp/bibliography/item/{$itemId}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function biblItem() {
    let $queryParams := map {
     'project' : 'gdpWebapp',
     'dbName' : 'gdp',
     'model' : 'tei',
     'function' : 'getBibliographicalExpression'
     }
    let $data := synopsx.lib.commons:getQueryFunction($queryParams)
    let $outputParams := map {
      'lang' : 'fr',
      'layout' : 'page.html',
      'pattern' : 'article.xhtml'
      (: specify an xslt mode and other kind of output options :)
      }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};