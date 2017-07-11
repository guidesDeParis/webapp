xquery version "3.0" ;
module namespace gdp.blog = 'gdp.blog' ;

(:~
 : This module is a RESTXQ for Paris' guidebooks blog
 :
 : @author emchateau (Cluster Pasts in the Present)
 : @since 2015-02-05 
 : @version 0.5
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
 : @qst give webpath by dates and pages ?
 :)

import module namespace restxq = 'http://exquery.org/ns/restxq' ;

import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace synopsx.models.synopsx= 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module namespace gdp.models.tei = "gdp.models.tei" at '../models/tei.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;

declare default function namespace 'gdp.blog' ;

declare variable $gdp.blog:project := 'blog';
declare variable $gdp.blog:dbName := synopsx.models.synopsx:getProjectDB($gdp.blog:project);

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
    'project' : 'gdp',
    'dbName' : 'blog',
    'model' : 'tei' ,
    'function' : 'getBlogPosts',
    'sorting' : 'date',
    'order' : 'descending'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsListSerif.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
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
    'project' : 'gdp',
    'dbName' :  'blog',
    'model' : 'tei' ,
    'function' : 'getBlogPosts',
    'sorting' : 'date',
    'order' : 'descending'
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsListSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
  };
 
(:~
 : resource function for a blog item
 :
 : @param $itemId an entry ID
 : @return a blog item
 :)
declare 
  %restxq:path('/blog/posts/{$entryId}')
  %rest:produces('text/html')
  %output:method('html')
  %output:html-version('5.0')
function blogItem($entryId as xs:string) {
  let $queryParams := map {
    'project' : 'gdp',
    'dbName' : 'blog',
    'model' : 'tei',
    'function' : 'getBlogItem',
    'entryId' : $entryId
    }
  let $function := synopsx.models.synopsx:getModelFunction($queryParams)
  let $result := fn:function-lookup($function, 1)($queryParams)
  let $outputParams := map {
    'layout' : 'refillsHtml5.xhtml',
    'pattern' : 'refillsArticleSerif.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
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
 'todo'
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
  











