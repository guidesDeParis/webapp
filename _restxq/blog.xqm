xquery version '3.0' ;
module namespace gdp.blog = 'gdp.blog' ;
(:~
 : This module is a RESTXQ for the Paris' guidebooks electronic edition' blog
 :
 : @author Emmanuel Chateau (Cluster Pasts in the Present)
 : @date 2014-11-30
 : @version 0.4
 : @see https://github.com/guidesDeParis/
 : @see http://www.passes-present.eu/en/node/363
 :
 : @rmq traiter comme un projet avec synopsx
 : @qst Donner une organisation par pages ?
 : @qst Donner une organisation par dates ?
 :
 :)

import module namespace restxq = 'http://exquery.org/ns/restxq';
 
import module namespace G = 'synopsx.globals' at '../../../globals.xqm' ;
import module namespace gdp.models.tei = 'gdp.models.tei' at '../models/tei.xqm' ;
import module namespace gdp.mappings.htmlWrapping = 'gdp.mappings.htmlWrapping' at '../mappings/htmlWrapping.xqm' ; 
declare default function namespace 'gdp.blog';


declare namespace tei = 'http://www.tei-c.org/ns/1.0'; (: to supress :)

(:~
 : resource function for the blog home
 : 
:)
declare 
  %restxq:path('/blog/home')
function home(){
  let $data    := gdp.models.tei:listTexts()
  let $options := map {'sorting' : 'descending'} (: todo :)
  let $layout  := $G:PROJECTS || 'gdpWebapp/templates/html5.xhtml'
  let $pattern  := $G:PROJECTS || 'gdpWebapp/templates/list.xhtml'
  return gdp.mappings.htmlWrapping:wrapper($data, $options, $layout, $pattern)
};


(:~
 : resource function for a blog entry
 : 
:)
declare 
  %restxq:path('/blog/{$entryId}')
function article($entryId as xs:string){
  let $data    := gdp.models.tei:article($entryId)
  let $options := map {}
  let $layout  := $G:PROJECTS || 'gdpWebapp/templates/html5.xhtml'
  let $pattern  := $G:PROJECTS || 'gdpWebapp/templates/article.xhtml'
  return gdp.mappings.htmlWrapping:wrapper($data, $options, $layout, $pattern)
};

(:~
 : resource function for comments (if supported)
 : 
 : Collection des commentaires d'un billet de blog : 
 : `guidesdeparis.net/blog/posts/{entryId}/{comments}`
 : Item de commentaires d'un billet de blog 
 : `guidesdeparis.net/blog/posts/{entryId}/{comments}/{commentId}`
 :)

(:~
 : resource function to search blog posts
 : 
 : `guidesdeparis.net/blog/posts/search?q=query` 
 : ou bien `guidesdeparis.net/blog/posts?q=query`
 : ?? `added_after`, `blog`, `blog_tag`, `pmid`, `tag`, `term`
 : 
 :)
declare 
  %restxq:path('/blog/search')
function search(){
 'toto'
};


(:~
 : resource function for collection of tags
 : 
 :)
declare
  %restxq:path('/blog/tags')
function tags(){
  'todo'
};


(:~
 : resource function for collection of blog entries by tag
 : 
 :)
declare
  %restxq:path('/blog/tags/{$tagId}')
function entriesByTagId($tagId as xs:string){
  'todo'
};


(:~
 : resource function for collection of category
 : 
 :)
declare
  %restxq:path('/blog/categories')
function categories(){
  'todo'
};


(:~
 : resource function for collection of blog entries by tag
 : 
 :)
declare
  %restxq:path('/blog/categories/{$categoryId}')
function entriesByCategoryId($categoryId as xs:string){
  'todo'
};


(:~
 : resource function for collection of authors
 : 
 :)
declare
  %restxq:path('/blog/authors')
function entriesByCategoryId(){
  'todo'
};


(:~
 : resource function for collection of category
 : 
 :)
declare
  %restxq:path('/blog/authors/{$authorId}')
function categories($authorId as xs:string){
  'todo'
};
