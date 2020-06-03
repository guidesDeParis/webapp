xquery version "3.0" ;
module namespace gdp.search = 'gdp.search' ;

(:~
 : This module is a rest for Paris' guidebooks electronic edition
 :
 : @version 1.0
 : @date 2019-05
 : @since 2019-05 
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

import module namespace rest = 'http://exquery.org/ns/restxq';

import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module namespace gdp.models.tei = "gdp.models.tei" at '../models/tei.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;
import module namespace gdp.mappings.jsoner = 'gdp.mappings.jsoner' at '../mappings/jsoner.xqm' ;

declare default function namespace 'gdp.search' ;

(:~
 : This function consumes new expertises 
 : @param $param content
 : @bug change of cote and dossier doesn’t work
 :)
declare
  %rest:path('/searchPost')
  %rest:POST
  %output:method('xml')
  %rest:header-param('Referer', '{$referer}', 'none')
  %rest:form-param('search', '{$search}', 'none')
  %rest:form-param("exact", "{$exact}")
  %rest:form-param("start", "{$start}", 1)
  %rest:form-param("count", "{$count}", 10)
function result($referer, $search as xs:string, $exact, $start as xs:int, $count as xs:int) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getSearch',
    'search' : $search
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incSearch.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : This function consumes new expertises 
 : @param $param content
 : @bug change of cote and dossier doesn’t work
 :)
declare
  %rest:path('/searchPost')
  %rest:POST
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:header-param('Referer', '{$referer}', 'none')
  %rest:form-param('search', '{$search}', 'none')
  %rest:form-param("exact", "{$exact}")
  %rest:form-param("start", "{$start}", 1)
  %rest:form-param("count", "{$count}", 10)
function resultJson($referer, $search as xs:string, $exact, $start as xs:int, $count as xs:int) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getSearch',
    'search' : $search
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : This function consumes new expertises 
 : @param $param content
 : @bug change of cote and dossier doesn’t work
 :)
declare
  %rest:path('/searche')
  %output:method('xml')
  %rest:header-param('referer', '{$referer}', 'none')
  %rest:query-param("search", "{$search}", 'none')
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 10)
function getSearch($referer, $search as xs:string, $start as xs:int?, $count as xs:int?) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getSearch',
    'search' : $search,
    'start' : $start,
    'count' : $count
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'search.xhtml',
    'pattern' : 'incSearch.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

(:~
 : This function is a simple search
 : @param $referer a referer
 : @param $search the search string
 : @param $combining the combining method ('all', 'all words', 'any', 'phrase')
 : @param $exact exact search as boolean
 : @param $start start for pagination
 : @param $start count for pagination
 :)
declare
  %rest:path('/search')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:header-param('Referer', '{$referer}', 'none')
  %rest:query-param("search", "{$search}", 'none')
  %rest:query-param("combining", "{$combining}", 'all')
  %rest:query-param("exact", "{$exact}", 0)
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 10)
function getSearchJson(
    $referer,
    $search as xs:string,
    $combining as xs:string,
    $exact,
    $start as xs:int,
    $count as xs:int
    ) {
  let $function := 'getSearch'
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : $function,
    'search' : $search,
    'combining' : $combining,
    'exact' : $exact,
    'start' : $start,
    'count' : $count
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};

(:~
 : This function consumes new expertises 
 : @param $param content
 : @bug change of cote and dossier doesn’t work
 :)
declare
  %rest:path('/searchAdvanced')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
  %rest:header-param('Referer', '{$referer}', 'none')
  %rest:query-param("search", "{$search}", 'none')
  %rest:query-param("exact", "{$exact}", 0)
  %rest:query-param("start", "{$start}", 1)
  %rest:query-param("count", "{$count}", 10)
function getAdvancedSearchJson($referer, $search as xs:string, $exact, $start as xs:int, $count as xs:int) {
  let $function := 'getSearch'
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : $function
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
};