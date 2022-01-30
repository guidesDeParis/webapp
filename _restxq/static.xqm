xquery version '3.1' ;
module namespace gdp.static = 'gdp.static' ;

(:~
 : This module is a rest for Paris' guidebooks blog
 :
 : @version 1.0
 : @date 2019-05
 : @since 2015-03-02 
 : @author emchateau (Cluster Pasts in the Present)
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
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

import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;

declare default function namespace 'gdp.static' ;

(:~
: resource function for the static files
:
: @param $file file or unknown path
: @return rest response and binary file
:)
declare
%rest:path('/gdp/static/{$file=.+}')
function file($file as xs:string) as item()+ {
  let $path := $G:WORKSPACE || 'gdp/static/' ||  $file
  return (
    web:response-header(map {'media-type' : web:content-type($path) }),
    file:read-binary($path))
};

(:~
 : this function return a mime-type for a specified file
 :
 : @param  $name  file name
 : @return a mime type for the specified file
 :)
declare function mime-type(
  $name  as xs:string
) as xs:string {
  fetch:content-type($name)
};