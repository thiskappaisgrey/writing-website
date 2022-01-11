module View exposing (View,  map)

-- import Html exposing (Html)

import Element exposing (Element)




type alias View msg =
    { title : String
    , body : List (Element msg)
    }


map : (msg1 -> msg2) -> View msg1 -> View msg2
map fn doc =
    { title = doc.title
    , body =  List.map (Element.map fn) doc.body
    }
placeholder : String -> View msg
placeholder moduleName =
    { title = "Placeholder"
    , body = [ Element.text moduleName ]
    }