module Slide exposing (..)

import Parser exposing (..)


type alias Slide
    = { text : String
        , image : String
        }
-- Parser is a Monad,
-- "|=" is a function that takes (Parser (a -> b)) -> Parser a -> Parser b
-- the type of "succeed identity" is (Parser (a -> b)) (that's why you need to use the identity function)
parseLine : Parser String
parseLine =
 succeed identity
 |. token "--"
 |. spaces
 |= (getChompedString <| chompUntil "--")
 |. token "--"
parseSlide : Parser Slide
parseSlide =
    succeed Slide
        |. spaces
        |. keyword "begin_slide"
        |. spaces
        |= parseLine
        |. spaces
        |= (getChompedString <| chompWhile (\c -> c /= '\n'))
        |. spaces
        |. keyword "end_slide"
        |. spaces
parseSlides : Parser (List Slide)
parseSlides =
  loop [] slidesHelp

slidesHelp : List Slide -> Parser (Step (List Slide) (List Slide))
slidesHelp revSlides =
  oneOf
    [
     end
        |> map (\_ -> Done (List.reverse revSlides))
     , succeed (\slide -> Loop (slide :: revSlides))
        |= parseSlide
    ]
