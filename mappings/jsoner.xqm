xquery version '3.0' ;
module namespace gdp.mappings.jsoner = 'gdp.mappings.jsoner' ;

(:~
 : This module is an JSON mapping for templating
 :
 : @version 3.0
 : @since 2017-07-07 
 : @author synopsx's team
 :
 : This file is part of SynopsX.
 : created by AHN team (http://ahn.ens-lyon.fr)
 :
 : SynopsX is free software: you can redistribute it and/or modify
 : it under the terms of the GNU General Public License as published by
 : the Free Software Foundation, either version 3 of the License, or
 : (at your option) any later version.
 :
 : SynopsX is distributed in the hope that it will be useful,
 : but WITHOUT ANY WARRANTY; without even the implied warranty of
 : MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 : See the GNU General Public License for more details.
 : You should have received a copy of the GNU General Public License along 
 : with SynopsX. If not, see http://www.gnu.org/licenses/
 :
 :)

import module namespace G = "synopsx.globals" at '../../../globals.xqm' ;
import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ; 

import module namespace gdp.mappings.tei2json = 'gdp.mappings.tei2json' at 'tei2json.xqm' ; 

declare namespace html = 'http://www.w3.org/1999/xhtml' ;

declare default function namespace 'gdp.mappings.jsoner' ;

(:~
 : this function wrap the content in an HTML layout
 :
 : @param $queryParams the query params defined in restxq
 : @param $data the result of the query
 : @param $outputParams the serialization params
 : @return an updated HTML document and instantiate pattern
 : @todo treat in the same loop @* and text() ?
 @todo add handling of outputParams (for example {class} attribute or call to an xslt)
 :)
declare function jsoner($queryParams as map(*), $data as map(*), $outputParams as map(*)) {
  let $contents := map:get($data, 'content')
  let $meta := map:get($data, 'meta')
  return map{
    'meta' : sequence2ArrayInMap($meta),
    'content' : for $content in $contents 
      return sequence2ArrayInMap($content)
  } 
};

(:~
 : this function transforms a map into a map with arrays
 :
 : @param $map the map to convert
 : @return a map with array instead of sequences
 : @rmq deals only with right keys
 :)
declare function sequence2ArrayInMap($map as map(*) ) as map(*) {
  map:merge((
    map:for-each(
      $map,
      function($a, $b) {
        map:entry(
          $a ,
          if(fn:count($b) > 1)
          then array{$b}
          else $b
        )
      }
    )
  )) 
};