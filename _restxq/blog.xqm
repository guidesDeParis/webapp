xquery version "3.0" ;
module namespace gdp.blog = "gdp.blog" ;
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
declare default function namespace 'gdp.blog';
declare namespace tei = 'http://www.tei-c.org/ns/1.0' ;

(:~
 : Simple blog in RESTXQ
 : @author Emmanuel Chateau
 : @date 2014-07
 : @version 1.0
 : @see https://github.com/publicarchitectura/webappBasex
:)

(:~
 : resource function for the page list
 : 
:)
declare %restxq:path('/gdp/blog')
        %restxq:GET
function blog(){
  let $content := map { 
      "title"   := "Corpus" ,
      "items"   := 
        <section>
          {
            for $corpus in db:open('gdp')/tei:teiCorpus/tei:teiCorpus
            return <article>
                     <div role="heading">
                       <h2>{$corpus/tei:teiHeader//tei:titleStmt/tei:title}</h2>
                       <h3>{fn:count($corpus//tei:TEI)} éditions</h3>
                     </div>
                     <div>
                       <ul>
                         {
                           for $edition in $corpus//tei:TEI
                           return <li><a href="/gdp/{$edition//tei:sourceDesc/@xml:id}">{$edition//tei:titleStmt//tei:title}</a></li>
                          }
                       </ul>
                     </div>
                    </article>
           }
          </section> ,
      "url"      := "http://guidesdeparis.net/corpus" ,
      "metadata" := <meta>test de Métadonnées</meta>
    }
    
  return prof:dump($content)
};
