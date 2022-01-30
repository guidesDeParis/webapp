xquery version "3.1" ;
module namespace gdp.blog = 'gdp.blog' ;

(:~
 : This module is a rest for Paris' guidebooks blog
 :
 : @version 1.0
 : @date 2019-05
 : @since 2015-02-05 
 : @author emchateau (Cluster Pasts in the Present)
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
 : @qst give webpath by dates and pages ?
 :)

import module namespace rest = 'http://exquery.org/ns/restxq' ;

import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace synopsx.models.synopsx= 'synopsx.models.synopsx' at '../../../models/synopsx.xqm' ;

import module namespace gdp.models.tei = "gdp.models.tei" at '../models/tei.xqm' ;

import module namespace synopsx.mappings.htmlWrapping = 'synopsx.mappings.htmlWrapping' at '../../../mappings/htmlWrapping.xqm' ;
import module namespace gdp.mappings.jsoner = 'gdp.mappings.jsoner' at '../mappings/jsoner.xqm' ;

declare default function namespace 'gdp.blog' ;

declare variable $gdp.blog:project := 'blog';
declare variable $gdp.blog:dbName := synopsx.models.synopsx:getProjectDB($gdp.blog:project);

(:~
 : resource function for the blog's root
 :
 :)
declare 
  %rest:path('/blog')
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
  %rest:path('/blog/home')
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
    'layout' : 'page.xhtml',
    'pattern' : 'incBlogItem.xhtml',
    'xquery' : 'tei2html'
    }
    return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
  };

(:~
 : resource function for the blog's home
 :
 : @return a json representation of blog's home
 :)
declare 
  %rest:path('/blog/home')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function blogHomeJson() {
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
    'xquery' : 'tei2html'
    }
    return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
  };

(:~
 : resource function for the blog's posts
 :
 : @return an html collection of blog's posts
 :)
declare 
  %rest:path('/blog/posts')
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
    'layout' : 'page.xhtml',
    'pattern' : 'incBlogItem.xhtml',
    'xquery' : 'tei2html'
    }
  return synopsx.mappings.htmlWrapping:wrapper($queryParams, $result, $outputParams)
  };

(:~
 : resource function for the blog's posts
 :
 : @return a json collection of blog's posts
 :)
declare 
  %rest:path('/blog/posts')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function blogPostsJson() {
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
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
  };
 
(:~
 : resource function for a blog item
 :
 : @param $itemId an entry ID
 : @return a blog item
 :)
declare 
  %rest:path('/blog/posts/{$entryId}')
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
    'layout' : 'page.xhtml',
    'pattern' : 'incBlogArticle.xhtml',
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
  %rest:path('/blog/posts/{$entryId}')
  %rest:produces('application/json')
  %output:media-type('application/json')
  %output:method('json')
function blogItemJson($entryId as xs:string) {
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
    'xquery' : 'tei2html'
    }
  return gdp.mappings.jsoner:jsoner($queryParams, $result, $outputParams)
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
  %rest:path('/blog/search')
function search() {
 'todo'
  };

(:~
 : resource function for collection of blog entries by tag
 : 
 :)
declare
  %rest:path('/blog/tags/{$tagId}')
function entriesByTagId($tagId as xs:string) {
  'todo'
  };

(:~
 : resource function for categories
 :
 : @return a collection of categories
 :)
declare
  %rest:path('/blog/categories')
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
  %rest:path('/blog/categories/{$categoryId}')
function entriesByCategoryId($categoryId as xs:string) {
  'todo'
  };

(:~
 : resource function for authors
 : 
 : @return a collection of blogs posts authors
 :)
declare
  %rest:path('/blog/authors')
function entriesByCategoryId() {
  'todo'
  };

(:~
 : resource function for authors
 : 
 : @return a collection of blogs posts by author
 :)
declare
  %rest:path('/blog/authors/{$authorId}')
function categories($authorId as xs:string) {
  'todo'
  };
  











