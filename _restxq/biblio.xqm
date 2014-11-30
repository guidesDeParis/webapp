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
 : list bibliographic entries
 :)
declare %restxq:path("/gdp/bibliography")
        %output:method("xhtml")
        %output:omit-xml-declaration("yes")
        %output:html-version("5.0")
        %output:encoding("UTF-8")
    function bibliographyList() as element() {
    let $title := "Liste des ouvrages"
    let $content := map { 
      "title"   := "Corpus" ,
      "items"   := 
        (<h2>{$title}</h2>, <br/>,
        <ul class="ui list"> 
            { 
            for $references in db:open("gdp")//tei:listBibl/tei:biblStruct
            let $referencesIds := $references/@xml:id
            return <li><a href="/gdp/bibliography/{$referencesIds}">{xslt:transform($references, "../static/xsl/biblio.xsl")}</a></li> 
            }
        </ul>)
      }
    return $content
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
                <caption>{xslt:transform($reference, '../static/xsl/biblio.xsl')}</caption>
                <tr>{$reference//tei:author}</tr>
                <tr>{$reference/*[1]/tei:title}</tr>
              </table>
    return $content
 };

