xquery version "3.1" ;
module namespace gdp.users = 'gdp.users' ;

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
import module namespace session = 'http://basex.org/modules/session';

import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module namespace gdp.models.tei = "gdp.models.tei" at '../models/tei.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;
import module namespace gdp.mappings.jsoner = 'gdp.mappings.jsoner' at '../mappings/jsoner.xqm' ;

declare default function namespace 'gdp.users' ;

(:~
 : This function 
 : @param $param content
 : @bug change of cote and dossier doesn’t work
 :)
declare
%rest:path('/users/{$user}')
%output:method('xml')
function usersList($user) {
  if (session:id() = db:open('gdpUsers')/*:users/*:user[*:id=$user]/*:sessions/*:session/*:id) then
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'users', 
    'function' : 'getUsers'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'page.xhtml',
    'pattern' : 'incUsers.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
};

      
declare
  %rest:path("logout")
function logoutAction() as element(rest:response) {
  logout(),
  redirect("/")
};
      
declare function logout() as empty-sequence() {
  session:close()
};
      
declare function redirect($page as xs:string) as element(rest:response) {
  <rest:response>
    <http:response status="302">
      <http:header name="location" value="{ $page }"/>
    </http:response>
  </rest:response>
};

declare 
  %rest:GET
  %rest:path("/users/list/{$userId}")
  %output:method("json")
function listUsers($userId as xs:string) {
  (: if(not(session:logged('ap-kp'))) 
  then error(xs:QName('err:permission')) 
  else let $users-nom := ex:get(odata:get-url( map { }) :)
  let $users-nom := 'todo cf plus ht'
  for $user in $users-nom
    return map {
      'userId' : $user/*:ID/fn:string(),
      'name' : $user/*:name
  }
};