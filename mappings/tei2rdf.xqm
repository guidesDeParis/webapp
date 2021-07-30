xquery version '3.0' ;
module namespace gdp.mappings.tei2rdf = 'gdp.mappings.tei2rdf' ;

(:~
 : This module is an RDF mapping from TEI
 :
 : @version 1.0
 : @date 2021-07
 : @since 2021-07
 : @author emchateau, carolinecorbieres
 : @see http://guidesdeparis.net
 :
 : This module uses SynopsX publication framework 
 : see https://github.com/ahn-ens-lyon/synopsx
 : It is distributed under the GNU General Public Licence, 
 : see http://www.gnu.org/licenses/
 :
 :)

import module namespace G = "synopsx.globals" at '../../../globals.xqm' ;
import module namespace gdp.globals = 'gdp.globals' at '../globals.xqm' ;

declare namespace tei = 'http://www.tei-c.org/ns/1.0';
declare namespace rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace crm = "http://www.cidoc-crm.org/cidoc-crm/";
declare namespace sci = "http://www.cidoc-crm.org/crmsci/";
declare namespace rdfs = "http://www.w3.org/2000/01/rdf-schema#";

declare default function namespace 'gdp.mappings.tei2rdf' ;

(:~
 : this function dispatches the content according to the element type
 :
 : @param $queryParams the query params defined in restxq
 : @param $data the result of the query
 : @param $outputParams the serialization params
 : @return an 
 : @todo control element namespace
 :)
declare function tei2rdf($queryParams as map(*), $data as element(), $outputParams as map(*)) {
  let $contents := map:get($data, 'content')
  let $meta := map:get($data, 'meta')
  return typeswitch($data)
  case element(tei:person) return semantizePerson($data)
  case element(tei:place) return semantizePlace($data)
  case element(tei:object) return semantizeObject($data)
  case element(tei:org) return semantizeGroup($data)
  default return ()  
};

(:~
 : this function semantizes the persons item
 :
 : @param $item is an element xml tei person
 : @return an rdf representation of the resource
 :)
declare function semantizePerson($item as element(tei:person)*) as element()* {
  let $context := $item/fn:name()
  return element rdf:RDF {
    namespace rdf {"http://www.w3.org/1999/02/22-rdf-syntax-ns#"},
    namespace rdfs {"http://www.w3.org/2000/01/rdf-schema#"}, 
    namespace crm {"http://www.cidoc-crm.org/cidoc-crm/"},
    element rdf:Description {
      attribute rdf:about {$gdp.globals:root ||'/person/' || $item/@xml:id},
      for $child in $item/* return typeswitch($child)
      case element(tei:persName) return getPersName($child)
      case element(tei:classification) return $child/* ! getCategories(.)       
      case element(tei:birth) return getBirth($child)
      case element(tei:death) return getDeath($child)
      case element(tei:nationality) return getNationality($child)
      case element(tei:occupation) return getOccupation($child)
      case element(tei:residence) return getResidence($child)
      case element(tei:listEvent) return $child/* ! getEvents(., $context)
      case element(tei:listRelation) return $child/* ! getRelations(., $context)
      case element(tei:idno) return getId($child)
      default return "to do"
    }
  }
};

(:~
 : this function semantizes the orgs item
 :
 : @param $item is an element xml tei org
 : @return an rdf representation of the resource
 :)
declare function semantizeGroup($item as element(tei:group)*) as element()* {
  let $context := $item/fn:name()
  return element rdf:RDF {
    namespace rdf {"http://www.w3.org/1999/02/22-rdf-syntax-ns#"},
    namespace rdfs {"http://www.w3.org/2000/01/rdf-schema#"}, 
    namespace crm {"http://www.cidoc-crm.org/cidoc-crm/"},
    element rdf:Description {
      attribute rdf:about {$gdp.globals:root ||'/person/' || $item/@xml:id},
      for $child in $item/* return typeswitch($child)
      case element(tei:orgName) return getOrgName($child)     
      case element(tei:classification) return $child/* ! getCategories(.) 
      case element(tei:location) return getOrgLocation($child) 
      case element(tei:listEvent) return $child/* ! getEvents(., $context)
      case element(tei:listRelation) return $child/* ! getRelations(., $context)
      case element(tei:idno) return getId($child)
      default return "to do"
    }
  }
};

(:~
 : this function semantizes the orgs item
 :
 : @param $item is an element xml tei object
 : @return an rdf representation of the resource
 :)
declare function semantizeObject($item as element(tei:object)*) as element()* {
  let $context := $item/fn:name()
  return element rdf:RDF { 
    namespace rdf {"http://www.w3.org/1999/02/22-rdf-syntax-ns#"},
    namespace rdfs {"http://www.w3.org/2000/01/rdf-schema#"}, 
    namespace crm {"http://www.cidoc-crm.org/cidoc-crm/"},
    element rdf:Description {
      attribute rdf:about {$gdp.globals:root ||'/object/' || $item/@xml:id},
      for $child in $item/* return typeswitch($child)
      case element(tei:objectIdentifier) return getObjectName($child)
      case element(tei:classification) return $child/* ! getCategories(.)
      case element(tei:physDesc) return getDimensions($child)
      case element(tei:history) return $child/tei:acquisition ! getAcquisition(.)
      case element(tei:location) return getLocation($child)
      case element(tei:additional) return $child/* ! getSurrogates(.)
      case element(tei:listEvent) return $child/* ! getEvents(., $context)
      case element(tei:listRelation) return $child/* ! getRelations(., $context)
      case element(tei:idno) return getId($child)
      default return "to do"
    }
  }
};

(:~
 : this function semantizes the orgs item
 :
 : @param $item is an element xml tei place
 : @return an rdf representation of the resource
 :)
declare function semantizePlace($item as element(tei:place)*) as element()* {
  let $context := $item/fn:name()
  return element rdf:RDF { 
    namespace rdf {"http://www.w3.org/1999/02/22-rdf-syntax-ns#"},
    namespace rdfs {"http://www.w3.org/2000/01/rdf-schema#"}, 
    namespace crm {"http://www.cidoc-crm.org/cidoc-crm/"},
    element rdf:Description {
      attribute rdf:about {$gdp.globals:root ||'/place/' || $item/@xml:id},
      for $child in $item/* return typeswitch($child)
      case element(tei:placeName) return getPlaceName($child)
      case element(tei:classification) return $child/* ! getCategories(.)
      case element(tei:location) return getLocation($child)
      case element(tei:listRelation) return $child/* ! getRelations(., $context)
      case element(tei:idno) return getId($child)
      default return "to do"
    }
  }
};

(:~ 
 : -------------
 : Shared functions for the description of people, orgs, places and objects 
 : -------------
 :)

(:~
 : this function retrieves the identifiers and represents these in rdf 
 :
 : @param $item is an element xml tei idno
 : @return an rdf representation of the resource
 :)
declare function getId($item as element(tei:idno)*) as element()* {
  element crm:P1_is_identified_by {
    element crm:E42_Identifier {
      element crm:P190_has_symbolic_content {fn:normalize-space($item)},
      element crm:P2_has_type  {
        element E55_Type {
          element rdfs:label {fn:normalize-space($item/@type)}
        }
      }
    }
  }
};

(:~
 : this function retrieves the classifications and represents these in rdf 
 :
 : @param $class is an element xml tei classification
 : @return an rdf representation of the resource
 :)
declare function getCategories($class as element(tei:category)*) as element()* {
  for $category in $class return
  if ($category[@type] = "destination") then element crm:P103_was_intended_for {
    element crm:E55_Type {
      if ($category[@ref]) then attribute rdf:about {fn:normalize-space($category/@ref)},
      element rdfs:label {fn:normalize-space($category)}
    }
  }
  else element crm:P2_has_type {
    if ($category[@type] = "classe") then switch($category)
    case ($category[fn:contains(@ref, "e22")]) return element crm:E22_Human_Made_Object {
      attribute rdf:about {fn:normalize-space($category/@ref)}
    }
    case ($category[fn:contains(@ref, "e53")]) return element crm:E53_Place {
      attribute rdf:about {fn:normalize-space($category/@ref)}
    }
    default return ()
    else element crm:E55_Type {
      if ($category[@ref]) then attribute rdf:about {fn:normalize-space($category/@ref)},
      element rdfs:label {fn:normalize-space($category)}
    }
  }
};

(:~
 : this function retrieves the dates and represents these in rdf 
 :
 : @param $date is an element xml tei date
 : @return an rdf representation of the resource
 :)
declare function getDates($date as element(tei:date)*) as element()* {
  switch ($date)
  case ($date[@to and @from]) return element crm:P4_has_time-span {
    element crm:E52_Time-Span {
      element crm:P82a_begin_of_the_begin {
        attribute rdf:datatype {"http://www.w3.org/2001/XMLSchema#dateTime"},
        fn:normalize-space($date/@from)
      },
      element crm:P82b_end_of_the_end {
        attribute rdf:datatype {"http://www.w3.org/2001/XMLSchema#dateTime"},
        fn:normalize-space($date/@to)
      }
    }
  }
  case ($date[@to or @from]) return element crm:P4_has_time-span {
    if ($date[@from]) then element crm:E52_Time-Span {
      element crm:P82a_begin_of_the_begin {
        attribute rdf:datatype {"http://www.w3.org/2001/XMLSchema#dateTime"},
        fn:normalize-space($date/@from)
      }
    },
    if ($date[@to]) then element crm:P82b_end_of_the_end {
      attribute rdf:datatype {"http://www.w3.org/2001/XMLSchema#dateTime"},
      fn:normalize-space($date/@to)
    }
  }
  case ($date[@when]) return element crm:P4_has_time-span {
    attribute rdf:datatype {"http://www.w3.org/2001/XMLSchema#dateTime"},
    fn:normalize-space($date/@when)
  }
  default return element crm:P4_has_time-span {
    fn:normalize-space($date)
  }
};

(:~
 : this function retrieves a place name and represents it in rdf 
 :
 : @param $item is an element xml tei place
 : @return an rdf representation of the resource
 :)
declare function getPlace($item as element(tei:placeName)*) as element()* {
  switch ($item)
  case ($item/tei:placeName[@type = "to"]) return element crm:P26_moved_to {
    element crm:E53_Place {
      fn:normalize-space($item),
      if ($item/@ref) then attribute rdf:ressource {getPathFromId($item/@ref)} 
    }
  }
  case ($item/tei:placeName[@type = "from"]) return element crm:P27_moved_from {
    element crm:E53_Place {
      fn:normalize-space($item),
      if ($item/@ref) then attribute rdf:ressource {getPathFromId($item/@ref)}
    }
  }
  default return element crm:P7_took_place_at {
    element crm:E53_Place {
      fn:normalize-space($item),
      if ($item/@ref) then attribute rdf:ressource {getPathFromId($item/@ref)}
    }
  } 
};

(:~
 : this function retrieves parts of an address and represents these in rdf 
 :
 : @param $part is an element xml tei address
 : @return an rdf representation of the resource
 :)
declare function getAddressPart($part) {
  if ($part/tei:settlement) then element crm:P2_has_type {
    element crm:E55_Type {
      attribute rdf:datatype {"http://vocab.getty.edu/page/aat/300008389"},
      element rdfs:label {"ville"}
    },
    element crm:P1_is_defined_by {
      element crm:E33_E41_Linguistic_Appelation {
        element crm:P190_has_symbolic_content {fn:normalize-space($part/tei:settlement)}
      } 
    }
  },
  if ($part/tei:country) then element crm:P2_has_type {
    element crm:E55_Type {
      attribute rdf:datatype {"http://vocab.getty.edu/page/aat/300128207"},
      element rdfs:label {"pays"}
    },
    element crm:P1_is_defined_by {
      element crm:E33_E41_Linguistic_Appelation {
        element crm:P190_has_symbolic_content {fn:normalize-space($part/tei:country)}
      } 
    }
  },
  if ($part/tei:street) then element crm:P2_has_type {
    element crm:E55_Type {
      attribute rdf:datatype {"http://vocab.getty.edu/page/aat/300008247"},
      element rdfs:label {"rue"}
    },
    element crm:P1_is_defined_by {      
      element crm:E33_E41_Linguistic_Appelation {
        element crm:P190_has_symbolic_content {fn:normalize-space($part/tei:street)}
      } 
    }
  },
  if ($part/tei:postCode) then element crm:P2_has_type {
    element crm:E55_Type {
      attribute rdf:datatype {"x"},
      element rdfs:label {"code postal"}
    },
    element crm:P1_is_defined_by {
      element crm:E33_E41_Linguistic_Appelation {
        element crm:P190_has_symbolic_content {fn:normalize-space($part/tei:postCode)}
      }
    }
  }
};
 
(:~
 : this function retrieves the location of an object or a place and represents it in rdf 
 :
 : @param $item is an element xml tei location
 : @return an rdf representation of the resource
 :)
declare function getLocation($item as element(tei:location)*) as element()* {
  element crm:P55_has_current_location {
    element crm:E53_Place {
      if ($item/tei:address) then for $child in ($item/tei:address) return getAddressPart($child),
      if ($item/tei:geo) then element crm:P168_place_is_defined_by {
        fn:normalize-space("POLYGON((" || $item/tei:geo || "))")
      },
      if ($item/tei:offset) then element {"crm:" || $item/tei:offset/@key} {
        element crm:E53_Place {
          attribute rdf:ressource {getPathFromId($item/@ref)}
        }
      } 
      else getAddressPart($item)
    }  
  } 
};
 
(:~ 
 : this function retrieves events and represents these in rdf 
 :
 : @param $item is an element xml tei event
 : @return an rdf representation of the resource
 :)
declare function getEvents($events as element(tei:event)*, $context) as element()* {
  for $event in $events return switch ($event)
  case ($event[@key="E85_Joining"]) return element crm:P143i_was_joined_by {
    element crm:E85_Joining {
      if ($event/tei:date) then getDates($event/tei:date),
      if ($event/tei:orgName) then element crm:P144_joined_with {
        for $group in $event/tei:orgName/@ref return element crm:E74_Group {
          attribute rdf:ressource {getPathFromId($group)}
        }   
      }
    }
  }
  case ($event[@key="E86_Leaving"]) return element crm:P145i_left_by {
    element crm:E86_Leaving {
      if ($event/tei:date) then getDates($event/tei:date),
      if ($event/tei:persName) then element crm:P146_separated_from {
        for $group in $event/tei:orgName/@ref return element crm:E74_Group {
          attribute rdf:ressource {getPathFromId($group)}
        }  
      }
    }
  }
  case ($event[@key="E66_Formation"]) return element crm:P95i_was_formed_by {
    element crm:E66_Formation {
      if ($event/tei:date) then getDates($event/tei:date),
      if ($event/tei:participant) then getParticipants($event/tei:participant), 
      if ($event/tei:placeName) then getPlace($event/tei:placeName)    
    }
  }
  case ($event[@key="E68_Dissolution"]) return element crm:P99i_was_dissolved_by {
    element crm:E68_Dissolution {
      if ($event/tei:date) then getDates($event/tei:date),
      if ($event/tei:participant) then getParticipants($event/tei:participant), 
      if ($event/tei:placeName) then getPlace($event/tei:placeName)  
    }
  }
  case ($event[@key="E12_Production"]) return element crm:P108i_was_produced_by {
    element crm:E12_Production {
      if ($event/tei:date) then getDates($event/tei:date),
      if ($event/tei:participant) then getParticipants($event/tei:participant),
      if ($event/tei:placeName) then getPlace($event/tei:placeName)    
    }
  }
  case ($event[@key="E6_Destruction"]) return element crm:P13i_was_destroyed_by {
    element crm:E6_Destruction {
      if ($event/tei:date) then getDates($event/tei:date),
      if ($event/tei:desc) then element sci:O13i_is_triggered_by {
        element crm:E7_Activity {
          element rdfs:label {fn:normalize-space($event/tei:desc)}
        }
      },
      if ($event/tei:placeName) then getPlace($event/tei:placeName)    
    }
  }
  case ($event[@key="E11_Modification"]) return element crm:P31i_was_modified_by {
    element crm:E11_Modification {
      if ($event/tei:date) then getDates($event/tei:date),
      if ($event/tei:participant) then getParticipants($event/tei:participant), 
      if ($event/tei:desc) then element crm:P2_has_type {
        element crm:E55_Type {
          attribute rdf:datatype {$event/tei:desc/@ref},
          element rdfs:label {fn:normalize-space($event/tei:desc)}
        }
      }  
    }
  }
  case ($event[@key="E81_Transformation"]) return element crm:P124i_was_transformed_by {
    element crm:E81_Transformation {
      if ($event/tei:date) then getDates($event/tei:date),
      element crm:P2_has_type {
        element crm:E55_Type {
          attribute rdf:datatype {"http://data.culture.fr/thesaurus/page/ark:/67717/cdc74cdf-ec5f-4008-83d6-39f3da922ff4"},
          element rdfs:label {"reconstruction"}
        }
      },
      element crm:P124_transformed {
        element crm:E22_Human_Made_Object {
          attribute rdf:ressource {getPathFromId($event/tei:object/@ref)}
        }
      }  
    }
  }
  case ($event[@key="E9_Move"]) return element crm:P25_moved_by {
    element crm:E9_Move {
      if ($event/tei:date) then getDates($event/tei:date),
      if ($event/tei:placeName) then getPlace($event/tei:placeName),
      if ($event/tei:desc) then element crm:P17_was_motivated_by {
        element crm:E7_Activity {
          element rdfs:label {fn:normalize-space($event/tei:desc)}
        }
      }
    }
  }
  default return ()
}; 

(: this function retrieves the role and names of the participants of an event and represents these in rdf 
 :
 : @param $participant is an element xml tei participant
 : @return an rdf representation of the resource
 :)
declare function getParticipants($participants as element(tei:participant)*) as element()* {
  for $participant in $participants return
  if ($participant[tei:role]) then element crm:P01i_is_domain_of {
    element crm:PC14_carried_out_by {
      element crm:P02_has_range {
        if ($participant/tei:persName) then 
        for $person in $participant/tei:persName return element crm:E21_Person {
          fn:normalize-space($person),
          if ($person/[@ref]) then attribute rdf:ressource {getPathFromId($person/@ref)}
        }, 
        if ($participant/tei:orgName) then 
        for $group in $participant/tei:orgName return element crm:E74_Group {
          fn:normalize-space($group),
          if ($group/[@ref]) then attribute rdf:ressource {getPathFromId($group/@ref)}
        }
      },
      element crm:P14.1_in_the_role_of {
        element rdfs:label {fn:normalize-space($participant/tei:role)},
        element crm:E55_Type {
          element rdfs:label {fn:normalize-space($participant/@ref)}
        }
      }
    }
  }
  else element {"crm:" || $participant/@key} {
    if ($participant/tei:persName) then 
    for $person in $participant/tei:persName return element crm:E21_Person {
      fn:normalize-space($person),
      if ($person/[@ref]) then attribute rdf:ressource {getPathFromId($person/@ref)}
    }, 
    if ($participant/tei:orgName) then 
    for $group in $participant/tei:orgName return element crm:E74_Group {
      fn:normalize-space($group),
      if ($group/[@ref]) then attribute rdf:ressource {getPathFromId($group/@ref)}
    }
  }
}; 

(:~ 
 : this function retrieves relations and represents these in rdf 
 :
 : @param $item is an element xml tei relation
 : @return an rdf representation of the resource
 : @rmq only allows you to process relationships between existing records 
 :)
declare function getRelations($relations as element(tei:relation)*, $context) as element()* {
  for $relation in $relations[@key != "P97_from_father" and @key != "P96_by_mother"] return element {"crm:" || $relation/@key} {
    switch ($relation)
    case ($relation[fn:contains(@passive, "nom")]) return
    for $person in $relation/@passive return element crm:E21_Person {
      attribute rdf:ressource {getPathFromId($person)}
    }      
    case ($relation[fn:contains(@passive, "org")]) return
    for $group in $relation/@passive return element crm:E74_Group {
      attribute rdf:ressource {getPathFromId($group)}
    }
    case ($relation[fn:contains(@passive, "loc")]) return 
    for $place in $relation/@passive return element crm:E53_Place {
      attribute rdf:ressource {getPathFromId($place)}
    }
    case ($relation[fn:contains(@passive, "ope")]) return 
    for $object in $relation/@passive return element crm:E22_Human_Made_Object {
      attribute rdf:ressource {getPathFromId($object)}
    }
    default return ()
  }
};

(:todo traiter les states :)



(:~ 
 : -------------
 : Functions dedicated to the description of persons
 : -------------
 :)

(:~
 : this function retrieves the name of a person and represents it in rdf
 :
 : @param $item is an element xml tei persName
 : @return an rdf representation of the resource
 :)
declare function getPersName($item as element(tei:persName)*) as element()* {
  if ($item/*) 
  then element crm:P1_is_identified_by {
    element crm:E33_E41_Linguistic_Appelation {
      element crm:P106_is_composed_of {
        for $part in $item/* return getNamePart($part) 
      }
    },
    if ($item/tei:persName/@xml:lang) then element crm:P72_has_langage {
      element crm:E56_Language { 
        element rdfs:label {fn:normalize-space($item/tei:persName/@xml:lang)} 
      }
    }
  }
  else element crm:P1_is_identified_by {
    element crm:E33_E41_Linguistic_Appelation {
      element crm:P190_has_symbolic_content {fn:normalize-space($item)}
    },
    if ($item/tei:objectName/@xml:lang) then element crm:P72_has_langage {
      element crm:E56_Language { 
        element rdfs:label {fn:normalize-space($item/tei:objectName/@xml:lang)} 
      }
    }
  } 
};

(:~
 : this function retrieves parts of the name of a person and represents these in rdf 
 :
 : @param $part est un sous-élément xml tei de persName
 : @return an rdf representation of the resource
 :)
declare function getNamePart($part) {
  let $type := typeswitch ($part) 
    case element(tei:surname) return element crm:P2_has_type {
      element crm:E55_Type {
        attribute rdf:about {"http://data.culture.fr/thesaurus/page/ark:/67717/5879a6ff-a428-4d64-a575-d37107493dba"}, 
        element rdfs:label {"Nom de famille"}
      }
    }
    case element(tei:forename) return element crm:P2_has_type {
      element crm:E55_Type {
        attribute rdf:about {"http://data.culture.fr/thesaurus/page/ark:/67717/faa45919-d279-43d9-ae51-5cb75a6d5a86"}, 
        element rdfs:label {"Prénom"}
      }
    }
    case element(tei:nameLink) return element crm:P2_has_type {
      element crm:E55_Type {
        attribute rdf:about {"xx"}, 
        element rdfs:label {"Particule"}
      }
    }
    case element(tei:genName) return element crm:P2_has_type {
      element crm:E55_Type {
        attribute rdf:about {"http://vocab.getty.edu/page/aat/300435248"}, 
        element rdfs:label {"Nom de génération"}
      }
    }
    case element(tei:roleName) return element crm:P2_has_type {
      element crm:E55_Type {
        attribute rdf:about {"xx"}, 
        element rdfs:label {"Titre"}
        (: todo ajouter type de titre ? :)
      }
    }
    default return ()
  return element crm:P1_is_defined_by {
    element crm:E33_E41_Linguistic_Appelation {
      element crm:P190_has_symbolic_content {fn:normalize-space($part)}
    },
    $type
  }     
};

(:~
 : this function retrieves the date and place of birth of a person and represents these in rdf
 :
 : @param $item is an element xml tei birth
 : @return an rdf representation of the resource
 :)
declare function getBirth($item as element(tei:birth)*) as element()* {
  element crm:P98i_was_born {
    element crm:E67_Birth {       
      if ($item/tei:date) then getDates($item/tei:date),
      if ($item/tei:placeName) then getPlace($item/tei:placeName), 
      if ($item/parent::tei:person/tei:listRelation/tei:relation[@key = "P97_from_father"]) then element crm:P97_from_father {
        for $person in $item/parent::tei:person/tei:listRelation/tei:relation/@passive 
        return element crm:E21_Person {
          attribute rdf:ressource {getPathFromId($person)}
        } 
      }, 
      if ($item/parent::tei:person/tei:listRelation/tei:relation[@key = "P96_by_mother"]) then element crm:P96_by_mother {
       for $person in $item/parent::tei:person/tei:listRelation/tei:relation/@passive 
        return element crm:E21_Person { 
          attribute rdf:ressource {getPathFromId($person)}
        }
      }
    }
  }
};
  
(:~
 : this function retrieves the date and place of death of a person and represents these in rdf 
 :
 : @param $item is an element xml tei death
 : @return an rdf representation of the resource
 :)
declare function getDeath($item as element(tei:death)*) as element()* {
  element crm:P100i_died_in {
    element crm:E69_Death {
      if ($item/tei:date) then getDates($item/tei:date),
      if ($item/tei:placeName) then getPlace($item/tei:placeName) 
    }
  }
}; 

(:~
 : this function retrieves the nationality of a person and represents it in rdf 
 :
 : @param $item is an element xml tei nationality
 : @return an rdf representation of the resource
 :)
declare function getNationality($item as element(tei:nationality)*) as element()* {
  element crm:P2_has_type {
    if ($item/*[@ref])
    then element crm:E55_Type { 
      attribute rdf:about {fn:normalize-space($item/@ref)}, 
      element rdfs:label {fn:normalize-space($item)} 
    }
    else element crm:E55_Type{
      element rdfs:label {fn:normalize-space($item)}
    },
    element crm:P2_has_type {
      element crm:E55_Type {
        attribute rdf:about {"http://vocab.getty.edu/aat/300379842"}, 
        element rdfs:label {"Nationalité"}
      }
    }
  }
};      

(:~
 : this function retrieves the occupation of a person and represents it in rdf 
 :
 : @param $item is an element xml tei occupation
 : @return an rdf representation of the resource
 :)
declare function getOccupation($item as element(tei:occupation)*) as element()* {
  element crm:P14i_performed {
     element crm:E7_Activity {
      if ($item/*) then 
        if ($item/tei:term) then element crm:P2_has_type {
          element crm:E55_Type {
            if ($item/tei:term[@ref]) then attribute rdf:datatype {fn:normalize-space($item/tei:term/@ref)},
            element rdfs:label {fn:normalize-space($item/tei:term)}
          }       
        },
        if ($item/tei:date) then getDates($item/tei:date)
      else element crm:P2_has_type {
        element crm:E55_Type {
          if ($item/[@ref]) then attribute rdf:datatype {fn:normalize-space($item/@ref)},
          element rdfs:label {fn:normalize-space($item)}
        }       
      }
    }     
  }
};  
 
(:~
 : this function retrieves the place of residence of a person and represents it in rdf 
 :
 : @param $item is an element xml tei residence
 : @return an rdf representation of the resource
 :)
declare function getResidence($item as element(tei:residence)*) as element()* {
  if ($item/tei:date)
  then element crm:P14_performed {
    element crm:E7_Activity {
      element crm:P2_has_type {
        element crm:E55_Type {
          attribute rdf:datatype {"http://vocab.getty.edu/page/aat/300266051"},
          element rdfs:label {"occupant"}
        }
      },
      if ($item/tei:date) then getDates($item/tei:date),
      if ($item/tei:placeName) then element crm:P7_took_place_at {
        element crm:E53_Place {
          for $child in $item/*[fn:not(fn:name()="date")] return getAddressPart($child)
        }
      }
    }
  }
  else element crm:P74_has_former_or_current_residence {
    element crm:E53_Place {
      for $child in $item/*[fn:not(fn:name()="date")] return getAddressPart($child)
    }
  }
};



(:~ 
 : -------------
 : Functions dedicated to the description of orgainzations
 : -------------
 :)
 
(:~
 : this function retrieves the name of a organization and represents it in rdf
 :
 : @param $item is an element xml tei orgName
 : @return an rdf representation of the resource
 :)
declare function getOrgName($item as element(tei:orgName)*) as element()* {
  element crm:P1_is_identified_by {
    element crm:E33_E41_Linguistic_Appelation {
      element crm:P190_has_symbolic_content {fn:normalize-space($item)}
    }
  },
  if ($item/tei:objectName/@xml:lang) then element crm:P72_has_langage {
    element crm:E56_Language { 
      element rdfs:label {fn:normalize-space($item/tei:objectName/@xml:lang)} 
    }
  }
};

(:~
 : this function retrieves the place of residence of an organization and represents it in rdf 
 :
 : @param $item is an element xml tei location
 : @return an rdf representation of the resource
 :)
declare function getOrgLocation($item as element(tei:location)*) as element()* {
  element crm:P74_has_former_or_current_residence {
    element crm:E53_Place {
      for $child in $item/* return getAddressPart($child)
    }
  }
};



(:~ 
 : -------------
 : Functions dedicated to the description of objects
 : -------------
 :)
 
 (:~
 : this function retrieves the title and inventory number of an object and represents these in rdf 
 :
 : @param $item is an element xml tei idno
 : @return an rdf representation of the resource
 :)
declare function getObjectName($items as element(tei:objectIdentifier)*) as element()* {
  for $item in $items return element crm:P1_is_identified_by {
    if ($item/tei:objectName) then element crm:E33_E41_Linguistic_Appelation {
      element crm:P190_has_symbolic_content {fn:normalize-space($item/tei:objectName)},
      if ($item/tei:objectName/@ref) then element crm:P2_has_type {
        element crm:E55_Type { 
          element rdfs:label {fn:normalize-space($item/tei:objectName/@ref)} 
        }
      },
       if ($item/tei:objectName/@xml:lang) then element crm:P72_has_langage {
        element crm:E56_Language { 
          element rdfs:label {fn:normalize-space($item/tei:objectName/@xml:lang)} 
        }
      }
    },
    if ($item/tei:idno) then element crm:E42_Identifier {
      element crm:P190_has_symbolic_content {fn:normalize-space($item/tei:idno)},
      element crm:P2_has_type {
        element crm:E55_Type { 
          element rdfs:label {fn:normalize-space($item/tei:idno/@type)}
        }
      }
    }
  }
};

(:~
 : this function retrieves the dimensions of an object and represents these in rdf 
 :
 : @param $dimensions is an element xml tei dimensions
 : @return an rdf representation of the resource
 :)
declare function getDimensions($dimensions as element(tei:physDesc)*) as element()* {
  for $dimension in $dimensions//tei:dimensions return element crm:P43_has_dimension {
    if ($dimension/tei:height) then element crm:E54_Dimension {
      element crm:P2_has_type {
        element crm:E55_Type {
          attribute rdf:about {"http://vocab.getty.edu/aat/300055644"},
          element rdfs:label {"hauteur"}
        } 
      },
      element crm:P90_has_value {
        attribute rdf:datatype {"http://www.w3.org/2001/XMLSchema#integer"},
        fn:normalize-space($dimension/tei:height)
      },  
      element crm:P91_has_unit {
        if ($dimension//[@unit]="cm") then attribute rdf:ressource {"http://vocab.getty.edu/page/aat/300379098"},
        if ($dimension//[@unit]="inches") then attribute rdf:ressource {"http://vocab.getty.edu/page/aat/300379100"},
        fn:normalize-space($dimension//[@unit])
      }
    },
    if ($dimension/tei:width) then element crm:E54_Dimension {
      element crm:P2_has_type {
        element crm:E55_Type {
          attribute rdf:about {"http://vocab.getty.edu/aat/300055647"},
          element rdfs:label {"largeur"}
        } 
      },
      element crm:P90_has_value {
        attribute rdf:datatype {"http://www.w3.org/2001/XMLSchema#integer"}, 
        fn:normalize-space($dimension/tei:width)
      },  
      element crm:P91_has_unit {
        if ($dimension//[@unit]="cm") then attribute rdf:ressource {"http://vocab.getty.edu/page/aat/300379098"}, 
        if ($dimension//[@unit]="inches") then attribute rdf:ressource {"http://vocab.getty.edu/page/aat/300379100"},
        fn:normalize-space($dimension//[@unit])
      }
    }
  } 
};
 
(:~
 : this function retrieves the surrogates of an object and represents these in rdf 
 :
 : @param $item is an element xml tei surrogates
 : @return an rdf representation of the resource
 :)
declare function getSurrogates($item as element(tei:surrogates)*) as element()* {
  for $surrogate in $item return element crm:P138i_has_representation {
    element crm:E36_Visual_Item {
      element rdf:type{
        attribute rdf:ressource {fn:normalize-space($surrogate/tei:ref)}
      }, 
      if ($surrogate[@type]) then element crm:P2_has_type {
        if ($surrogate/[@type] = "digital") then element crm:E55_Type {
          attribute rdf:about {"http://vocab.getty.edu/aat/300215302"},
          element rdfs:label {"Image numérique"}
        } 
        (:todo ajouter d'autres types de surrogats :)
      }
    }  
  } 
};
  
(:~
 : this function retrieves the acquisition event of an object and represents it in rdf 
 :
 : @param $item is an element xml tei acquisition
 : @return an rdf representation of the resource
 :)
declare function getAcquisition($item as element(tei:acquisition)*) as element()* {
  element crm:P24i_changed_ownership_through {
    element crm:E8_Acquisition {
      if ($item/tei:date) then getDates($item/tei:date),
      if ($item/tei:persName or $item/tei:orgName) then element crm:P22_transferred_title_to {
        if ($item/tei:persName) then element crm:P21_Person {fn:normalize-space($item/tei:persName)}, 
        if ($item/tei:orgName) then element crm:P74_Group {fn:normalize-space($item/tei:orgName)}
      },
      if ($item/tei:placeName) then getPlace($item/tei:placeName)      
    }
  }
};



(:~ 
 : -------------
 : Functions dedicated to the description of places
 : -------------
 :)
 
(:~
 : this function retrieves the name of a place and represents it in rdf
 :
 : @param $item is an element xml tei placeName
 : @return an rdf representation of the resource
 :)
declare function getPlaceName($item as element(tei:placeName)*) as element()* {
  element crm:P1_is_identified_by {
    element crm:E33_E41_Linguistic_Appelation {
      element crm:P190_has_symbolic_content {fn:normalize-space($item)}
    }, 
    if ($item//@xml:lang) then element crm:P72_has_langage {
      element crm:E56_Language { 
        element rdfs:label {fn:normalize-space($item/@xml:lang)} 
      }
    }
  } 
};



(:~ 
 : -------------
 : Other functions
 : -------------
 :)

(:~ 
 : this function creates an identifier as an url
 :
 : @param $id is the identifier of a resource (person, group, place, object)
 : @return an identifier as an url
 :)
declare function getPathFromId($id){
  let $regex := "#([a-z]{3})(.*)"
  let $seq := fn:analyze-string($id, $regex)//fn:group/text()
  return if ($seq[1] = "nom") then $gdp.globals:root || "/person/" || fn:string-join($seq)
  else if ($seq[1] = "ope") then $gdp.globals:root || "/object/" || fn:string-join($seq)
  else if ($seq[1] = "org") then $gdp.globals:root || "/group/" || fn:string-join($seq)
  else if ($seq[1] = "loc") then $gdp.globals:root || "/place/" || fn:string-join($seq)
};