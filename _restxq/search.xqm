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
%rest:path('/gdp/search')
%output:method('xml')
%rest:header-param('Referer', '{$referer}', 'none')
%rest:form-param('search', '{$search}', 'none')
%rest:POST
function xformResult($search, $referer) {
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