module Shared exposing (Data, Model, Msg(..), SharedMsg(..), color, template)

import Browser.Navigation
import DataSource
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { showMobileMenu = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg globalMsg ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed ()



-- TODO render the homepage separately


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view sharedData page model toMsg pageView =
    { body =
        Element.layout [] <|
            Element.column
                [ width fill
                , height fill
                , spacing 30
                , Element.padding 30
                , Background.color color.nordBackground
                , Font.color color.white
                , Font.family
                    [ Font.typeface "Fira Mono"
                    , Font.monospace
                    ]
                ]
            <|
                [ navBar (not pageView.isIndex) ]
                    ++ pageView.body
                    ++ if (not pageView.isIndex) then [ row
                            [ width fill
                            , paddingEach  { top = 20 , right = 0 , bottom = 10 , left = 0}
                            , Font.size 15
                            ]
                            [ el [ alignLeft ] <| text "Copyright Thanawat Techaumnuaiwit, 2022"
                            , newTabLink [ mouseOver [ alpha 0.85 ], alignRight ] { url = "https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest", label = el [ Font.color color.green ] <| text "Source Code" }
                            ]
                       ] else []
    , title = pageView.title
    }


navBar : Bool -> Element.Element msg
navBar showNav =
    if showNav then
        Element.row [] [ Element.link [ Font.size 20 ] { url = "/", label = Element.text "Thanawat's website" } ]

    else
        Element.none


color =
    { yellow = rgb255 0xEB 0xCB 0x8B
    , orange = rgb255 0xD0 0x87 0x70
    , green = rgb255 0xA3 0xBE 0x8C
    , red = rgb255 0xBF 0x61 0x6A
    , purple = rgb255 0xB4 0x8E 0xAD
    , nordBackground = rgb255 0x2E 0x34 0x40
    , lightGrey = rgb255 0x43 0x4C 0x5E
    , white = rgb255 0xEC 0xEF 0xF4
    }
