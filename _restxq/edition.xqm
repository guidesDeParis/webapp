xquery version "3.0" ;
module namespace gdp.edition = 'gdp.edition' ;

(:~
 : This module is a RESTXQ for Paris' guidebooks electronic edition
 :
 : @author emchateau (Cluster Pasts in the Present)
 : @since 2015-02-05 
 : @version 0.5
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
 : @qst give webpath by dates and pages ?
 :)

import module namespace restxq = 'http://exquery.org/ns/restxq';

import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../../../lib/commons.xqm' ;

import module namespace gdp.models.tei = "gdp.models.tei" at '../models/tei.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;

declare default function namespace 'gdp.edition' ;

(:~
 : this resource function redirect to /home
 :)
declare 
  %restxq:path('/gdp')
function index() {
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/gdp/home"/>
    </http:response>
  </rest:response>
};

(:~
 : resource function for the home
 :
 : @return a home page for the edition
 :)
declare 
  %restxq:path('/gdp/home')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function editionHome() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getHome'
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHomeHtml5.xhtml',
    'pattern' : 'refillsBullet.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
}; 

(:~
 : resource function for corpus list
 :
 : @return an html representation of the corpus resource
 :)
declare 
  %restxq:path('/gdp/corpus')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function corpus() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getCorpusList'
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'corpusList.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};

(:~
 : resource function for a corpus ID
 :
 : @param $corpusId the corpus ID
 : @return an html representation of the corpus resource
 :)
declare 
  %restxq:path('/gdp/corpus/{$corpusId}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function corpusItem($corpusId as xs:string) {
  let $queryParams := map {
    'corpusId' : $corpusId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getCorpusById'
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsCards.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};

(:~
 : resource function for a corpus ID
 :
 : @param $corpusId the corpus ID
 : @return an html representation of the corpus resource
 :)
declare 
  %restxq:path('/gdp/texts/{$textId}')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function textItem($textId as xs:string) {
  let $queryParams := map {
    'textId' : $textId,
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getTextById'
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsCards.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};
(:~
 : this resource function is a bibliographical list for testing
 : @return an html representation of the bibliographical list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %restxq:path("/gdp/resp/list/html")
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
  %restxq:query-param("pattern", "{$pattern}")
function biblioListHtml($pattern as xs:string?) {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getRespList'
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'inc_blogListSerif.xhtml',
    'pattern' : 'inc_blogArticleSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};

(:~
 : this resource function is a corpus list for testing
 :
 : @return an html representation of the corpus list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %restxq:path("/gdp/texts")
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
  (: %restxq:query-param("pattern", "{$pattern}") :)
function texts() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getTextsList'
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'inc_blogListSerif.xhtml',
    'pattern' : 'inc_blogArticleSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};

(:~
 : this resource function is a documentation
 : @return an html representation of the bibliographical list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %restxq:path("/gdp/model")
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function model() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'path' : '/schema/gdpSchemaTEI.odd.xml',
    'model' : 'tei',
    'function' : 'getModel'
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsPageSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};

(:~
 : this resource function is a about page
 : @return an html representation of the bibliographical list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %restxq:path("/about")
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function about() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'blog',
    'model' : 'tei',
    'function' : 'getAbout',
    'entryId' : 'gdpPresentation2014'
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsPageSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};

(:~
 : this resource function is a about page
 : @return an html representation of the bibliographical list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %restxq:path("/documentation")
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function documentation() {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'path' : '/schema/gdpSchemaTEI.odd.xml',
    'model' : 'tei',
    'function' : 'getModel'
    }
  let $function := synopsx.lib.commons:getModelFunction($queryParams)
  let $data := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsPageSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
};

declare 
  %restxq:path("/gdp/html/header")
function getHtmlHeader() {
  fn:doc($G:WORKSPACE||'gdp/templates/inc_header.xhtml')
};

declare 
  %restxq:path("/gdp/html/footer")
function getHtmlFooter() {
  fn:doc($G:WORKSPACE||'gdp/templates/inc_footer.xhtml')
};