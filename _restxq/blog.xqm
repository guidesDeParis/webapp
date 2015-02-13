xquery version "3.0" ;
module namespace gdp.blog = 'gdp.blog' ;

(:~
 : This module is a RESTXQ for Paris' guidebooks electronic edition's blog
 :
 : @author emchateau (Cluster Pasts in the Present)
 : @since 2015-02-05 
 : @version 0.5
 : @see http://guidesdeparis.net
 : @see https://github.com/guidesDeParis/
 :
 : This module uses SynopsX publication framework see <https://github.com/ahn-ens-lyon/synopsx> 
 : It is distributed under the GNU General Public Licence, see <http://www.gnu.org/licenses/>
 :
 : @rmq treated as a project with SynopsX
 : @qst give webpath by dates and pages ?
 :)

import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace synopsx.lib.commons = 'synopsx.lib.commons' at '../../../lib/commons.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;

declare default function namespace 'gdp.blog' ;

declare variable $gdp.blog:project := 'blog';
declare variable $gdp.blog:dbName := synopsx.lib.commons:getProjectDB($gdp.blog:project);

(:~
 : resource function for the blog's root
 :
 :)
declare 
  %restxq:path('/blog')
function index() {
  <rest:response>
    <http:response status="303" message="See Other">
      <http:header name="location" value="/blog/home"/>
    </http:response>
  </rest:response>
};

(:~
 : resource function for the blog's home
 :
 : @return an html representation of blog's home
 :)
declare 
  %restxq:path('/blog/home')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function blogHome() {
  let $queryParams := map {
    'project' : 'gdpWebapp',
    'dbName' :  'blog',
    'model' : 'tei' ,
    'function' : 'getBlogHome'
    }
  let $data := synopsx.lib.commons:getQueryFunction($queryParams)
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'page.xhtml',
    'pattern' : 'inc_blogArticleSerif.xhtml',
    'sorting' : 'descending'
    (: specify an xslt mode and other kind of output options :)
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
  }; 
 
(:~
 : resource function for the blog's posts
 :
 : @return a collection of blog's posts
 :)
declare 
  %restxq:path('/blog/posts')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function blogPosts() {
  let $queryParams := map {
    'project' : 'gdpWebapp',
    'dbName' :  'blog',
    'model' : 'tei' ,
    'function' : 'getBlogPosts'
    }
  let $data := synopsx.lib.commons:getQueryFunction($queryParams)
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'page.xhtml',
    'pattern' : 'inc_blogArticleSerif.xhtml',
    'sorting' : 'descending'
    (: specify an xslt mode and other kind of output options :)
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
  };
 
(:~
 : resource function for a blog item
 :
 : @param $itemId an entry ID
 : @return a blog item
 :)
declare 
  %restxq:path('/gdp/posts/{$entryId}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function blogItem($entryId as xs:string) {
  let $queryParams := map {
    'project' : 'gdpWebapp',
    'dbName' :  'blog',
    'model' : 'tei',
    'function' : 'getBlogItem',
    'entryId' : $entryId
    }
  let $data := synopsx.lib.commons:getQueryFunction($queryParams)
  let $outputParams := map {
    'lang' : 'fr',
    'layout' : 'page.xhtml',
    'pattern' : 'inc_blogArticleSerif.xhtml'
    (: specify an xslt mode and other kind of output options :)
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $data, $outputParams)
  };

(:~
 : resource function for a collection of blog item's comments
 :)
 
(:~
 : resource function for a blog item's comment by ID
 :)

(:~
 : resource function to search blog posts
 : 
 : `guidesdeparis.net/blog/posts/search?q=query` 
 : ou bien `guidesdeparis.net/blog/posts?q=query`
 : ?? `added_after`, `blog`, `blog_tag`, `pmid`, `tag`, `term`
 :)
declare 
  %restxq:path('/blog/search')
function search() {
 'toto'
  };

(:~
 : resource function for collection of blog entries by tag
 : 
 :)
declare
  %restxq:path('/blog/tags/{$tagId}')
function entriesByTagId($tagId as xs:string) {
  'todo'
  };

(:~
 : resource function for categories
 :
 : @return a collection of categories
 :)
declare
  %restxq:path('/blog/categories')
function categories() {
  'todo'
  };

(:~
 : resource function for category
 :
 : @param $categoryId the category ID
 : @return a collection of blogs entries by category's ID
 :)
declare
  %restxq:path('/blog/categories/{$categoryId}')
function entriesByCategoryId($categoryId as xs:string) {
  'todo'
  };

(:~
 : resource function for authors
 : 
 : @return a collection of blogs posts authors
 :)
declare
  %restxq:path('/blog/authors')
function entriesByCategoryId() {
  'todo'
  };

(:~
 : resource function for authors
 : 
 : @return a collection of blogs posts by author
 :)
declare
  %restxq:path('/blog/authors/{$authorId}')
function categories($authorId as xs:string) {
  'todo'
  };