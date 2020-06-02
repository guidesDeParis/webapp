xquery version "3.0" ;
module namespace gdp.doc = 'gdp.doc' ;

declare namespace xq="http://www.xqdoc.org/1.0";

(:~
 : This module is a rest for Paris' guidebooks blog
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

import module namespace rest = 'http://exquery.org/ns/restxq' ;

declare default function namespace 'display' ;

(:~
 : resource function for the blog's root
 :
 :)
declare
  %rest:path('/doc/{$module}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function display:doc($module) {
 let $module := $module
 return
 display:get-module-html($module, fn:false())
  (:inspect:xqdoc('edition.xqm'):)
};

(:~
 : resource function for the blog's root
 :
 :)
declare
  %rest:path('/doc/{$module}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function display:doc($module) {
 let $module := $module
 return
 display:get-module-html($module, fn:false())
  (:inspect:xqdoc('edition.xqm'):)
};

declare
  %rest:path('/xqdoc')
function display:xqdoc() {
  inspect:xqdoc('edition.xqm')
};
