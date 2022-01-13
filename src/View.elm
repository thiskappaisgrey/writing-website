module View exposing (View,  map, placeholder)

-- import Html exposing (Html)

import Element exposing (Element)




type alias View msg =
    { title : String
    , body : List (Element msg)
    , isIndex : Bool
    }


map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn doc =
    { title = doc.title
    , body =  List.map (Element.map fn) doc.body
    , isIndex = doc.isIndex
    }
placeholder : String -> View msg
placeholder moduleName =
    { title = "Placeholder"
    , body = [ Element.text moduleName ]
    , isIndex = False
    }
