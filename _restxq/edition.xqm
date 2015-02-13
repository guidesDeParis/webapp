xquery version "3.0" ;
module namespace gdp.webapp = 'gdp.edition' ;

(:~
 : This module is a RESTXQ for Paris' guidebooks electronic edition
 :
 : @author emchateau (Cluster Pasts in the Present)
 : @since 2015-02-05 
 : @version 0.5
 : @see http://guidesdeparis.net
 : @see https://github.com/guidesDeParis/
 :
 : This module uses SynopsX publication framework see <https://github.com/ahn-ens-lyon/synopsx> 
 : It is distributed under the GNU General Public Licence, see <http://www.gnu.org/licenses/>
 :
 : @rmq treated as a project with SynopsX
 : @qst give webpath by dates and pages ?
 :)

import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../../../lib/commons.xqm' ;

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
 : this resource function is the html representation of the corpus resource
 : @return an html representation of the corpus resource with a bibliographical list
 : the HTML serialization also shows a bibliographical list
 :)
declare 
  %restxq:path('/gdp/home')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function editionHome() {
  let $queryParams := map {
    'project' : 'gdpWebapp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getTextsList'
    }
  let $data := synopsx.lib.commons:getQueryFunction($queryParams)
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'page.xhtml',
    'pattern' : ()
    (: specify an xslt mode and other kind of output options :)
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams) (: give $data instead of $queryParams:)
}; 

(:~
 : this resource function is the html representation of the corpus resource
 : @return an html representation of the corpus resource with a bibliographical list
 : the HTML serialization also shows a bibliographical list
 :)
declare 
  %restxq:path('/gdp/texts')
  %rest:produces('text/html')
  %output:method("html")
  %output:html-version("5.0")
function editionTexts() {
    let $queryParams := map {
     'project' : 'gdpWebapp',
     'dbName' : 'gdp',
     'model' : 'tei',
     'function' : 'getTextsList'
     }
    let $data := synopsx.lib.commons:getQueryFunction($queryParams)
    let $outputParams := map {
      'lang' : 'fr',
      'layout' : 'home.xhtml',
      'pattern' : 'article.xhtml'
      (: specify an xslt mode and other kind of output options :)
      }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams) (: give $data instead of $queryParams:)
};

(:~
 : this resource function is a corpus list for testing
 : @return an html representation of the corpus list
 : @param $pattern a GET param giving the name of the calling HTML tag
 : @todo use this tag !
 :)
declare 
  %restxq:path("/gdp/texts/list/html")
(: %restxq:query-param("pattern", "{$pattern}") :)
function corpusListHtml() {
  let $queryParams := map {
    'project' :'gdpWebapp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getTextsList'
    }
  let $data := synopsx.lib.commons:getQueryFunction($queryParams)
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'inc_blogListSerif.xhtml',
    'pattern' : 'inc_blogArticleSerif.xhtml'
    (: specify an xslt mode and other kind of output options :)
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
  %restxq:query-param("pattern", "{$pattern}")
function biblioListHtml($pattern as xs:string?) {
  let $queryParams := map {
    'project' :'gdp',
    'dbName' : 'gdp',
    'model' : 'tei',
    'function' : 'getRespList'
    }
  let $data := synopsx.lib.commons:getQueryFunction($queryParams)
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'inc_blogListSerif.xhtml',
    'pattern' : 'inc_blogArticleSerif.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
  };

declare 
  %restxq:path("/gdp/html/header")
function getHtmlHeader() {
  fn:doc($G:PROJECTS||'gdp/templates/inc_header.xhtml')
  };

declare 
  %restxq:path("/gdp/html/footer")
function getHtmlFooter() {
  fn:doc($G:PROJECTS||'gdp/templates/inc_footer.xhtml')
  };