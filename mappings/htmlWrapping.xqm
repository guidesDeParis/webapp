xquery version "3.0" ;
module namespace gdp.mappings.htmlWrapping = 'gdp.mappings.htmlWrapping';
(:~
 : This module is an HTML mapping for templating
 : @version 0.2 (Constantia edition)
 : @date 2014-11-10 
 : @author synopsx team
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
 : with SynopsX. If not, see <http://www.gnu.org/licenses/>
 :
 : @todo give xslt's path with a function
 :)

import module namespace G = "synopsx.globals" at '../../../globals.xqm';

declare default function namespace 'gdp.mappings.htmlWrapping'; 

declare namespace html = 'http://www.w3.org/1999/xhtml'; 
declare variable $gdp.mappings.htmlWrapping:xslt := '../xsl2/tei2html.xsl' ;

(:~
 : this function can eventually call an innerWrapper to perform intermediate wrappings 
 : @data brought by the model (is a map of meta data and content data)
 : @options are the rendering options (not used yet)
 : @layout is the global layout
 : @pattern is the fragment layout 
 :
 : This function wrap the content in an html layout
 :
 : @data a map built by the model with meta values
 : @options options for rendering (not in use yet)
 : @layout path to the global wrapper html file
 : @pattern path to the html fragment layout 
 : 
 : @rmq prof:dump($data,'data : ') to debug, messages appears in the basexhttp console
 : @change add flexibility to retrieve meta values and changes in variables names EC2014-11-15
 : @toto modify to replace text nodes like "{quantity} éléments" EC2014-11-15
 :)
declare function wrapper($data, $options, $layout, $pattern){
  let $meta := map:get($data, 'meta')
  let $contents := map:get($data,'content')
  let $wrap := fn:doc($layout)
  return $wrap update (
    for $text in .//@*
      where fn:starts-with($text, '{') and fn:ends-with($text, '}')
      let $key := fn:replace($text, '\{|\}', '')
      let $value := map:get($meta, $key)
      return replace value of node $text with fn:string($value) ,
    for $text in .//text()
      where fn:starts-with($text, '{') and fn:ends-with($text, '}')
      let $key := fn:replace($text, '\{|\}', '')
      let $value := map:get($meta,$key)
      return if ($key = 'content') 
        then replace node $text with pattern($meta, $contents, $options, $pattern)
        else replace node $text with $value 
    )
};

(: replace node $text with (xslt:transform($value, '../../../../static/xslt2/tei2html5.xsl')) :)
  
(: 
  let $content := map:get($data,'content')
  let $tmpl := fn:doc($layout) 
  return $tmpl update (
    replace node .//*:title/text() with map:get($meta, 'title'),
      if(map:get($options, 'middle') = 'list.xhtml')
      then insert node innerWrapper($meta, $content, $options, $pattern) into .//html:div[@title='main']
      else 
        if(map:get($options, 'middle') = 'table.xhtml')
        then insert node innerWrapper($meta, $content, $options, $pattern) into .//html:div[@title='main']
        else insert node to-html($content, $pattern, $options) into .//html:div[@title='main'],
    replace node .//html:ul[@title='contextual-nav'] with map:get($meta, 'title') 
:)


(:~
 : This function wrap the content in an html layout
 :
 : @data a map built by the model with meta values
 : @options options for rendering (not in use yet)
 : @layout path to the global wrapper html file
 : @pattern path to the html fragment layout 
 : 
 : @rmq prof:dump($data,'data : ') to debug, messages appears in the basexhttp console
 : @change add flexibility to retrieve meta values and changes in variables names EC2014-11-15
 : @toto modify to replace text nodes like "{quantity} éléments" EC2014-11-15
 :
 : This function should be called by a global wrapper and wraps a sequence of items according to the pattern
 : @content brought by the model 
 : @options are the rendering options (not used yet)
 : @pattern is the fragment layout 
 :)
declare function innerWrapper($meta, $content, $options, $pattern){
  let $tmpl := fn:doc('../templates/'||map:get($options, 'middle'))
  return $tmpl update (
    replace node /*/text() with  pattern($meta, $content, $pattern, $options)
  )
};


(:~
 : This function iterates the pattern template with contents
 :
 : @meta meta values built by the model as a map
 : @contents contents values built by the model as a map
 : @options options for rendering (not in use yet)
 : @pattern path to the html fragment layout 
 :
 : @toto modify to replace text nodes like "{quantity} éléments" EC2014-11-15
 :)
declare function pattern($meta as map(*), $contents  as map(*), $options, $pattern  as xs:string) as document-node()* {
  map:for-each($contents, function($key, $content) {
    fn:doc($pattern) update (
      for $text in .//@*
        where fn:starts-with($text, '{') and fn:ends-with($text, '}')
        let $key := fn:replace($text, '\{|\}', '')
        let $value := map:get($content, $key) 
        return replace value of node $text with fn:string($value) ,
      for $text in .//text()
        where fn:starts-with($text, '{') and fn:ends-with($text, '}')
        let $key := fn:replace($text, '\{|\}', '')
        let $value := map:get($content, $key) 
        return if ($key = 'tei') 
          then replace node $text with xslt:transform($value, $gdp.mappings.htmlWrapping:xslt)
          else replace node $text with $value
        
      )
  })
};
