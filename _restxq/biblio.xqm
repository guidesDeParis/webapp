xquery version "3.0" ;
module namespace gdp.biblio = "gdp.biblio" ;
(:~
 : This module is a RESTXQ for the Paris' guidebooks electronic edition' blog
 :
 : @author Emmanuel Chateau (Cluster Pasts in the Present)
 : @date 2014-05-22
 : @version 0.3
 : @see https://github.com/guidesDeParis/
 : @see http://www.passes-present.eu/en/node/363
 : @todo paramétriser le rendu en adaptant le module de templating txq
 : @todo transférer le html dans une vue
 :)

import module namespace restxq = 'http://exquery.org/ns/restxq';

import module namespace G = 'synopsx.globals' at '../../synopsx/globals.xqm' ;
import module namespace synopsx.models.teiBiblio = 'synopsx.models.teiBiblio' at '../../synopsx/models/teiBiblio.xqm' ;
import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../synopsx/mappings/htmlWrapping.xqm' ; 

declare namespace db = "http://basex.org/modules/db" ;
declare default function namespace 'gdp.biblio';
declare namespace tei = 'http://www.tei-c.org/ns/1.0' ;

(:~
 : Simple description of a bibliographic module in RESTXQ
 : @author Emmanuel Chateau
 : @date 2014-04-05
 : @version 1.0
 : @see https://github.com/publicarchitectura/webappBasex
:)

(:~
 : this resource function redirects to the works list
 :)
declare %restxq:path("/gdp/bibliography")
function bibliography(){
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/gdp/bibliography/works"/>
    </http:response>
  </rest:response>
};

(:~
 : this resource function list the works
 :)
declare 
  %restxq:path("/gdp/bibliography/works")
function bibliographyList(){
  let $data    := synopsx.models.teiBiblio:listWorks()
  let $options := map {}
  let $layout  := $G:TEMPLATES || 'blogHtml5.xhtml'
  let $pattern  := $G:TEMPLATES || 'biblioListSerif.xhtml'
  return synopsx.mappings.htmlWrapping:wrapper($data, $options, $layout, $pattern)
};

(:~
 : fonction ressource qui affiche un item
 :)
declare %restxq:path('/gdp/bibliography/{$item}')
        %output:method('xhtml')
        %output:omit-xml-declaration('yes')
        %output:html-version('5.0')
        %output:encoding('UTF-8')
    function bibliographyItem($item as xs:string) as element() {
    let $title := 'Notice bibliographique'
    let $content := 
            for $reference in db:open('gdp')//tei:listBibl/tei:biblStruct[@xml:id=$item]
            return 
              <table>
                <caption>{xslt:transform($reference, '../../../../static/xsl/biblio.xsl')}</caption>
                <tr>{$reference//tei:author}</tr>
                <tr>{$reference/*[1]/tei:title}</tr>
              </table>
    return $content
 };

