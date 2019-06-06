xquery version "3.0" ;
module namespace gdp.nego = "gdp.nego" ;

(:~
 : This module is a RESTXQ for Paris' guidebooks bibliography
 :
 : @version 1.0
 : @date 2019-05
 : @since 2015-02-22
 : @author emchateau (Cluster Pasts in the Present)
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework
 : see <https://github.com/ahn-ens-lyon/synopsx>
 : It is distributed under the GNU General Public Licence,
 : see <http://www.gnu.org/licenses/>
 :
 : @qst give webpath by dates and pages ?
 :)

import module namespace rest = 'http://exquery.org/ns/restxq';

import module namespace G = 'synopsx.globals' at '../../../../synopsx/globals.xqm' ;
import module namespace synopsx.models.synopsx = 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module namespace gdp.models.tei = "gdp.models.tei" at '../models/tei.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../../synopsx/mappings/htmlWrapping.xqm' ;
import module namespace gdp.mappings.jsoner = 'gdp.mappings.jsoner' at '../mappings/jsoner.xqm' ;

declare default function namespace 'gdp.nego';

(:~
 : Simple content negociation module in RESTXQ
 : @author Emmanuel Chateau
 : @date 2019-03-23
 : @version 1.0
 : @see https://github.com/publicarchitectura/webappBasex
:)

declare
  %rest:path('/nego/{$param=[^.]+$}')
  %rest:produces('*/*', 'text/html')
  %output:media-type('text/html')
  %output:method('html')
function html($param) {
  <html><h1>{$param}</h1></html>
};

declare
  %rest:path('/nego/{$param=[^.]+$}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function json($param) {
  let $param := $param
  return map{
    'param' : $param, 
    'title' : 'Ceci est un titre JSON',
    'content' : 'Ius omnes consetetur an, facer quando abhorreant has ut. Commune necessitatibus vel ea, nam an viderer apeirian. Cu qui velit fabellas, dico unum munere an eam, id quo perfecto tacimates. Ne animal sententiae definitionem est, te vis option discere ocurreret, et tibique percipitur sit.'
  }
};

declare
  %rest:path('/nego/{$param=.+\.json}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function jsonBis($param) {
  let $param := fn:substring-before($param, '.json')
  let $param := $param
  return map{
    'param' : $param, 
    'title' : 'Ceci est un titre JSON',
    'content' : 'Ius omnes consetetur an, facer quando abhorreant has ut. Commune necessitatibus vel ea, nam an viderer apeirian. Cu qui velit fabellas, dico unum munere an eam, id quo perfecto tacimates. Ne animal sententiae definitionem est, te vis option discere ocurreret, et tibique percipitur sit.'
  }
};

declare
  %rest:path('/nego/{$param=[^.]+$}')
  %rest:produces('application/xml')
  %output:media-type('application/xml')
function xml($param) {
  let $param := $param
  return map{
    'param' : $param, 
    'title' : <h1>Ceci est un titre XML</h1>,
    'content' : <p>Ius omnes consetetur an, facer <emph>quando</emph> abhorreant has ut. Commune necessitatibus vel ea, nam an viderer apeirian. Cu qui velit fabellas, dico unum munere an eam, id quo perfecto tacimates. Ne animal sententiae definitionem est, te vis option discere ocurreret, et tibique percipitur sit.</p>
  }
};

declare
  %rest:path('/nego/{$param=.+\.xml}')
  %rest:produces('application/xml')
  %output:media-type('application/xml')
function xmlBis($param) {
  let $param := fn:substring-before($param, '.xml')
  let $param := $param
  return <text>
    <h1>{$param}</h1>
    <p>Du text</p>
  </text>
};


(:~
 : This function tests the use of Vue.js
 :)
declare
  %rest:path('vue')
  %rest:produces('*/*', 'text/html')
  %output:media-type('text/html')
  %output:method('html')
function vue() {
<html>
  <head>
    <title>Fun with Forms in Vue.js</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.4.4/css/bulma.min.css"/>
  </head>
  <body>
  <div class="columns" id="app">
    <div class="column is-two-thirds">
      <section class="section">
        <h1 class="title">Fun with Forms in Vue 2.0</h1>
        <p class="subtitle">Learn how to work with forms, including <strong>validation</strong>!</p><hr/>
        <!-- form starts here -->
        <section class="form">
          <div class="field">
            <label class="label">Name</label>
            <div class="control">
              <input v-model="form.name" class="input" type="text" placeholder="Text input"/>
            </div>
          </div>
        </section>
      </section>
    </div>
    <div class="column">
      <section class="section" id="results">
        <div class="box">
          <ul>
            <!-- loop through all the `form` properties and show their values -->
            <li v-for="(item, k) in form">
              <strong><![CDATA[{{ k }}:]]></strong><![CDATA[ {{ item }}:]]>
            </li>
          </ul>
        </div>
      </section>
    </div>
    <div class="field">
    <label class="label">Message</label>
    <div class="control">
      <textarea class="textarea" placeholder="Message" v-model="form.message"></textarea>
    </div>
  </div>
  </div>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.3.4/vue.min.js"></script>
  <script src="gdp/static/js/main.js"></script>
  </body>
</html>
};

(:~
 : This function tests the use of axios.js
 :)
declare
  %rest:path('axios')
  %rest:produces('*/*', 'text/html')
  %output:media-type('text/html')
  %output:method('html')
function axios() {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'gdp',
    'model' : 'tei', 
    'function' : 'getHome'
    }
  let $outputParams := map {
    'layout' : 'home.xhtml',
    'pattern' : 'template.xhtml',
    'xquery' : 'tei2html'
    }
  let $template := $outputParams('pattern')
  let $path := $G:WORKSPACE || map:get($queryParams, 'project') || '/templates/' || $template
  return fn:doc($path)
};



declare
  %rest:path('testnego/{$nego}')
  %rest:produces('*/*', 'text/html')
  %output:media-type('text/html')
  %output:method('html')
function testnegoHtml($nego) {
  <html>
  <body>
  <h1>Titre</h1></body>
  </html>
};

declare
  %rest:path('testnego/{$param}')
  %rest:produces('application/xml')
  %output:media-type('application/xml')
  %output:method('xml')
function testnegoXML($param) {
  <html>
  <body>
  <h1>Toto</h1></body>
  </html>
};

declare
  %rest:path('testnego/{$param}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function testnegoJSON($param) {
  <html>
  <body>
  <h1>Toto</h1></body>
  </html>
};


declare
  %rest:path('testo/{$param}')
  %rest:produces('*/*', 'text/html', 'application/xml', 'application/json', 'text/json')
  %rest:header-param("Accept", "{$accept}")
function testo($param, $accept) {
  filter($param, $accept)
};

declare function filter($param, $accept) {
 if ('text/html' = $accept)  then (
   <rest:response>
    <http:response status="200">
      <http:header name="Content-Language" value="en"/>
      <http:header name="Content-Type" value="text/plain; charset=utf-8"/>
    </http:response>
   </rest:response>,
   <html>
     <body>
       <h1>{$param}</h1>
     </body>
   </html>)
 else if ('application/xml' = $accept)  then <xml>{$param}</xml>
 else if ('application/json' = $accept)  then map{'object':'test'}
else 'oups'
};