module Page.Hobbies exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Element exposing (..)
import Element.Font as Font
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)
import Html
import Html.Attributes
import Json.Encode


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type alias Data =
    ()


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "MY life"
    , body =
        [ el [ Font.size 25, centerX ] <| text "My Hobbies"
        , hobby "Reading/Youtube" "I love doing mindless activities like watching youtube and reading (Reddit, novels, manga, etc) on my phone. Using my braincells to much is nauseating so I try not to use it too much until it's necessary." "/images/mylife.png"
        -- , hobby "Playing Guitar" "I learned to play in middle school and have been playing on and off since. I'm not very good, but it's fine I guess. I was going to include a performance but I couldn't get a good take.." "/images/mylife.png"
        , row [ centerX, width (px 1000) ]
        [ column [ spacing 20 ]
            [ el
                [ alignLeft

                -- below <|
                , width <| px 400
                , Font.size 25
                ]
              <|
                text "Playing guitar"
            , paragraph [] [ text  "I learned to play in middle school and have been playing on and off since. I'm not very good, but it's fine I guess. ", el [ Font.color Shared.color.yellow] <| text "Warning: This is me playing a song I wrote. It's pretty cringe, so brace your ears if you're going to listen. Don't say I didn't warn you" ]
            ]
        , Element.el [alignRight] <| Element.html video
        ]
        -- , hobby "Working out and video games" "I also try to workout and run everyday. Occasionally, I play video games too. My current favorites are Super Auto Pets, Dead Cells, and League of Legends." "/images/mylife.png"
        ]
    , isIndex = False
    }


hobby : String -> String -> String -> Element msg
hobby tit txt img =
    row [ centerX, width (px 1000) ]
        [ column [ spacing 20 ]
            [ el
                [ alignLeft

                -- below <|
                , width <| px 400
                , Font.size 25
                ]
              <|
                text tit
            , paragraph [] [ text txt ]
            ]
        , image [ width <| px 400, alignRight ] { src = img, description = "" }
        ]
video =
  Html.iframe
  [ Html.Attributes.width 400
  , Html.Attributes.height 225
  , Html.Attributes.src "https://www.youtube.com/embed/Vx01bNz0PSs"
  , Html.Attributes.property "frameborder" (Json.Encode.string "0")
  , Html.Attributes.property "allowfullscreen" (Json.Encode.string "true")
  , Html.Attributes.property "allow" (Json.Encode.string  "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture")
  ]
  []
