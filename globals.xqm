xquery version '3.0' ;
module namespace gdp.globals = 'gdp.globals' ;
(:~
 : This module is a TEI models library for paris' guidebooks edition
 :
 : @author emchateau (Cluster Pasts in the Present)
 : @since 2017-07-03 
 : @version 0.1
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
 :)
 
 
 (: declare variable $gdp.globals:root := 'http://www.guidesdeparis.net' ; :)
 declare variable $gdp.globals:root := 'http://localhost:8984' ;