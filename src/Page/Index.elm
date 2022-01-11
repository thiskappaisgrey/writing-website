module Page.Index exposing (Data, Model, Msg, page)

import Animator
import Browser.Navigation
import DataSource exposing (DataSource)
import Dict exposing (Dict)
import Element exposing (Element, alignRight, centerX, centerY, el, fill, fillPortion, height, none, padding, px, row, spacing, text, width)
import Element.Background as Background exposing (color)
import Element.Border as Border
import Element.Font as Font
import Element.Input
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
import Shared
import Svg as Svg exposing (svg)
import Svg.Attributes as SvgAttributes
import Time
import View exposing (View)


type ButtonState
    = Default
    | Hover


type alias Id =
    String


type alias Model =
    { buttonStates : Animator.Timeline (Dict Id ButtonState) }


type Msg
    = RuntimeTriggeredAnimationStep Time.Posix
    | UserHoveredButton Id
    | UserUnhoveredButton Id
    | Never


type alias RouteParams =
    {}


page : Page.PageWithState RouteParams Data Model Msg
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildWithLocalState
            { view = view
            , init = init
            , update = update
            , subscriptions =
                \maybePageUrl routeParams path model ->
                    Sub.none
            }


init :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> ( Model, Cmd Msg )
init _ _ _ =
    ( { buttonStates =
            Animator.init <|
                Dict.fromList [ ( "Uno", Default ), ( "Dos", Default ), ( "Tres", Default ) ]
      }
    , Cmd.none
    )


update :
    PageUrl
    -> Maybe Browser.Navigation.Key
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> Msg
    -> Model
    -> ( Model, Cmd Msg )
update _ maybeNavigationKey sharedModel static msg model =
    case msg of
        _ ->
            ( model, Cmd.none )


subscriptions :
    Maybe PageUrl
    -> RouteParams
    -> Path.Path
    -> Model
    -> Sub Msg
subscriptions _ _ _ model =
    Sub.none


data : DataSource Data
data =
    DataSource.succeed ()


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Thanawat's Website"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "Thanawat's Homepage" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    ()


view :
    Maybe PageUrl
    -> Shared.Model
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel model static =
    { title = "Thanawat's website"
    , body = [ circle, aboutGroup, puzzleButton ]
    }


aboutGroup =
    Element.column
        [ centerX
        , centerY
        , spacing 30
        ]
        [ Element.el [ Font.size 30,  centerX, centerY ] <| Element.text "Hi, I'm Thanawat!"
        , Element.el [ Font.size 20,  centerX, centerY ] <| Element.text "Learn more about me by clicking one of these puzzle pieces:"
        ]



-- Puzzle Pieces:
-- Defines SVG puzzle pieces starting from top left to top right

-- Maybe I can write it as a function to avoid duplication
puzzleButton =
    Element.link
        [ Element.focused
            []
        , centerX
        , centerY
        ]
        {
            url =   "/life"
            , label =   Element.html puzzleSVGTR
        }

-- Here, I will just duplicate this:
puzzleSVGTR =
    svg
        [ SvgAttributes.width "300"
        , SvgAttributes.height "300"
        , SvgAttributes.viewBox "0 0 150 150"
        , SvgAttributes.fill "#EBCB8B"
        ]
        [ Svg.rect
            [ SvgAttributes.x "0"
            , SvgAttributes.y "0"
            , SvgAttributes.width "100"
            , SvgAttributes.height "100"
            , SvgAttributes.rx "0"
            , SvgAttributes.ry "0"
            ]
            [
            ]
        , Svg.rect
            [ SvgAttributes.x "90"
            , SvgAttributes.y "30"
            , SvgAttributes.width "40"
            , SvgAttributes.height "40"
            , SvgAttributes.rx "15"
            , SvgAttributes.ry "20"

            -- , SvgAttributes.r "50"
            ]
            []
        , Svg.rect
            [ SvgAttributes.x "30"
            , SvgAttributes.y "90"
            , SvgAttributes.width "40"
            , SvgAttributes.height "40"
            , SvgAttributes.rx "20"
            , SvgAttributes.ry "15"

            -- , SvgAttributes.r "50"
            ]
            []
        , Svg.text_
            [ SvgAttributes.fill "#4C566A"
            , SvgAttributes.x "30"
            , SvgAttributes.y "55"
            , SvgAttributes.fontSize "19"
            , SvgAttributes.fontFamily "monospace"
            , SvgAttributes.fontStyle "Fira Mono"
            ]
            [ Svg.text "Life" ]
        -- Maybe I can dynamically add these when hovered, and also change the height and widht to new ones?
         -- , Svg.animate
         --        [
         --         SvgAttributes.attributeName "width", SvgAttributes.values "300;350", SvgAttributes.dur "1s", SvgAttributes.repeatCount "1"
         --        ]
         --        []
         --      , Svg.animate
         --        [
         --         SvgAttributes.attributeName "height", SvgAttributes.values "300;350", SvgAttributes.dur "1s", SvgAttributes.repeatCount "1"
         --        ]
         --        []

        ]


circle : Element msg
circle =
    el [ width <| px 200, height <| px 200, Border.rounded 100, Border.width 3, centerY, centerX ] none
