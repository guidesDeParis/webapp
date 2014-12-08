xquery version "3.0" ;
module namespace gdp.edition = "gdp.edition" ;
(:~
 : This module is a RESTXQ for the Paris' guidebooks electronic edition
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
 
import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace gdp.models.tei = 'gdp.models.tei' at '../models/tei.xqm' ;
import module namespace gdp.mappings.htmlWrapping = 'gdp.mappings.htmlWrapping' at '../mappings/htmlWrapping.xqm' ; 
declare default function namespace 'gdp.edition';

declare namespace tei = 'http://www.tei-c.org/ns/1.0';  (: to suppress :)



(:~
 : resource function for the home
 : 
:)
declare 
  %restxq:path('/')
function root(){
  <rest:redirect>{ '/home' }</rest:redirect>
};

(:~
 : resource function for the home
 : 
:)
declare 
  %restxq:path('/home')
function home(){
  let $data    := gdp.models.tei:homePage()
  let $options := map {'sorting' : 'descending'} (: todo :)
  let $layout  := $G:PROJECTS || 'gdpWebapp/templates/refillsHomeHtml5.xhtml'
  let $pattern  := $G:PROJECTS || 'gdpWebapp/templates/refillsBullet.xhtml'
  return gdp.mappings.htmlWrapping:wrapper($data, $options, $layout, $pattern)
};


(:~
 : resource function for the edition
 : 
:)
declare 
  %restxq:path('/gdp')
function blog(){
  <rest:redirect>{ '/gdp/corpus' }</rest:redirect>
};


(:~
 : resource function for the page list
 : 
:)
declare 
  %restxq:path('/gdp/corpus')
function corpus(){
  let $data    := gdp.models.tei:listCorpus()
  let $options := map {'sorting' : 'descending'} (: todo :)
  let $layout  := $G:PROJECTS || 'gdpWebapp/templates/refillsHtml5.xhtml'
  let $pattern  := $G:PROJECTS || 'gdpWebapp/templates/refillsCards.xhtml'
  return gdp.mappings.htmlWrapping:wrapper($data, $options, $layout, $pattern)
};

(: function corpus(){
  let $content := map { 
      "title"   := "Corpus disponibles" ,
      "items"   := 
        <section>
          {
            for $corpus in db:open('gdp')/tei:teiCorpus/tei:teiCorpus
            return 
            <article class="cards">
              <div class="card">
                <!-- 
                <div class="card-image">
                  <img src="https://raw.githubusercontent.com/thoughtbot/refills/master/source/images/mountains.png" alt=""/>
                </div>
                -->
                <div class="card-header">
                  {$corpus/tei:teiHeader//tei:titleStmt/tei:title}
                </div>
                <div class="card-copy">
                  <p>
                    <ul>
                      {
                        for $edition in $corpus//tei:TEI
                        return <li><a href="/gdp/{$edition//tei:sourceDesc/@xml:id}">{$edition//tei:titleStmt//tei:title}</a></li>
                      }
                    </ul>
                  </p>
                </div>
                <div class="card-stats">
                  <ul>
                    <li>{fn:count($corpus//tei:TEI)}<span>éditions</span></li>
                    <li>298<span>Sujets</span></li>
                  </ul>
                </div>
              </div>
            </article> :)

            (: <article>
                     <div role="heading">
                       <h2>{$corpus/tei:teiHeader//tei:titleStmt/tei:title}</h2>
                       <h3>{count($corpus//tei:TEI)} éditions</h3>
                     </div>
                     <div>
                       <ul>
                         {
                           for $edition in $corpus//tei:TEI
                           return <li><a href="/gdp/{$edition//tei:sourceDesc/@xml:id}">{$edition//tei:titleStmt//tei:title}</a></li>
                          }
                       </ul>
                     </div>
                    </article> :)
         (:   }
          </section> ,
      "url"      := "http://guidesdeparis.net/corpus" ,
      "metadata" := <meta>test de Métadonnées</meta>
    }
    
  return $content
}; :)


(: function article($entryId as xs:string){
  let $data    := gdp.models.tei:article()
  let $options := map {}
  let $layout  := $G:PROJECTS || 'gdpWebapp/templates/refillsHtml5.xhtml'
  let $pattern  := $G:PROJECTS || 'gdpWebapp/templates/refillsArticleSerif.xhtml'
  return gdp.mappings.htmlWrapping:wrapper($data, $options, $layout, $pattern)
}; :)
(:~
 : resource function for the corpus'list
 : 
:)
declare %restxq:path('/gdp/{$editionId}')
        %restxq:GET
function edition($editionId){
  let $edition := db:open('gdp')/tei:teiCorpus/tei:teiCorpus//tei:TEI[//tei:sourceDesc[@xml:id=$editionId]]
  let $referenceId  := $edition/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl/@copyOf
  (: let $reference := db:open("gdp")//tei:listBibl/tei:biblStruct[@xml:id=$referenceId] :)
  let $content := map {
      "title"  := "Sauval, édition de 1724" ,
      "items"  := 
        <section>
          {
            for $item in $edition//tei:div[@type='item']
            return
                <article class="cards">
              <div class="card">
                <!-- 
                <div class="card-image">
                  <img src="https://raw.githubusercontent.com/thoughtbot/refills/master/source/images/mountains.png" alt=""/>
                </div>
                -->
                <div class="card-header">
                  {<a href="/gdp/{$editionId}/{$item/@xml:id}">{$item//tei:head}</a>}
                </div>
                <div class="card-copy">
                  <p>
                  </p>
                </div>
                <div class="card-stats">
                  <ul>
                    <li>{fn:string-length($item)}<span>caractères</span></li>
                    <li>11<span>Pages</span></li>
                  </ul>
                </div>
              </div>
            </article>
               (: <article>
                 <div>
                   <h3><a href="/gdp/{$editionId}/{$item/@xml:id}">{$item//tei:head}</a></h3>
                 </div>
                 <div>
                   <ul></ul>
                 </div>
               </article> :)
          }
        </section>
      }
  return $content
};

(:~
 : resource function for the corpus'item
 : 
:)
declare %restxq:path('/gdp/{$editionId}/{$itemId}')
        %restxq:GET
function showitem($editionId, $itemId){
  let $title := db:open('gdp')/tei:teiCorpus/tei:teiCorpus//tei:TEI[//tei:sourceDesc[@xml:id=$editionId]]//tei:div[@xml:id=$itemId]/head
  let $content := map { 
      "title"   := "Corpus" ,
      "items"   := 
        <section>
         {
           for $item in db:open('gdp')/tei:teiCorpus/tei:teiCorpus//tei:TEI[//tei:sourceDesc[@xml:id=$editionId]]//tei:div[@xml:id=$itemId]
           return 
             <article  class="type-system-serif">
               <div>
                 <h2>{$item/tei:head}</h2>
                 <h3>[localisation du passage dans l’ouvrage (todo)]</h3>
               </div>
               <div>
                 {xslt:transform($item, 'xslt')}
               </div>
             </article>
         }
        </section>
      }
  return $content
};
