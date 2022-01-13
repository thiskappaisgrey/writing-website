module Page.Stats exposing (Data, Model, Msg, page)

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
    { title = "My Stats"
    , body = [ avatarAndStats, description ]
    , isIndex = False
    }


type alias Stats =
    { statName : String

    --  out of 10
    , score : Int
    }


myStats : List Stats
myStats =
    [ { statName = "procrastination", score = 8 }
    , { statName = "looks", score = 5 }
    , { statName = "pessimism", score = 7 }
    , { statName = "braincells", score = 7 }
    , { statName = "strength", score = 5 }
    , { statName = "luck", score = 6 }
    ]


avatarAndStats : Element msg
avatarAndStats =
    column [ centerX ]
        [ el [ centerX, Font.size 30, paddingXY 0 15 ] <| text "Thanawat"
        , el [ centerX ] <| text "Lvl 20 University Student"
        , row [ centerX, centerY ]
            [ column []
                [ image []
                    { src = "/images/out.png"
                    , description = "My pixel-art avatar"
                    }
                ]
            , table [ spacingXY 20 10 ]
                { data = myStats
                , columns =
                    [ { header = el [ Font.underline, Font.size 25 ] <| Element.text "Stat"
                      , width = fill
                      , view = \stat -> Element.text stat.statName
                      }
                    , { header = el [ Font.underline, Font.size 25 ] <| Element.text "Score"
                      , width = fill
                      , view = \stat -> Element.text <| String.fromInt stat.score ++ " / 10"
                      }
                    ]
                }
            ]
        ]


description =
    column [  centerX, spacing 20, width (fill |> maximum 1000)  ]
        [ el [  Font.size 30, centerX ] <| text "Character Description"
        , paragraph [] [text """
                              Thanawat is a character with average stats, specializing with knowlege work
                              due to his relatievly high braincell stat. However, all advantages in his build
                              is negated by his high procrastination stat, which makes his build somewhat hard to play at times.
                              With above average luck, early game is not too hard, but winning mid/late game may be difficult.

                              """]
        , el [  Font.size 30, centerX ] <| text "Titles"
        , el [centerX] <| text "<Cactus slayer>"
        , el [centerX] <| text "<Master Procrastinator>"
        ]
