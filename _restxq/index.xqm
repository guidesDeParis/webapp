xquery version "3.0" ;
module namespace gdp.index = 'gdp.index' ;

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

import module namespace rest = 'http://exquery.org/ns/restxq';

import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module namespace gdp.models.tei = "gdp.models.tei" at '../models/tei.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;
import module namespace gdp.mappings.jsoner = 'gdp.mappings.jsoner' at '../mappings/jsoner.xqm' ;

declare default function namespace 'gdp.index' ;

(:~
 : this resource function redirect to /home
 :)
(:~
 : resource function for the home
 :
 : @return an html home page for the edition
 :)
declare 
  %rest:path('/gdp/index')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function index() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndex'
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
 : resource function for the indexLocorum
 :
 : @return a list of index entries
 :)
declare 
  %rest:path('/gdp/index/indexLocorum')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function indexLocorum() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexLocorum'
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
 : resource function for the indexLocorum
 :
 : @return a list of index entries
 :)
declare 
  %rest:path('/gdp/index/indexOperum')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function indexOperum() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexOperum'
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
 : resource function for the indexLocorum
 :
 : @return a list of index entries
 :)
declare 
  %rest:path('/gdp/index/indexNominum')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function indexNominum() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getIndexNominum'
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