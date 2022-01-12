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
import Element exposing (mouseOver)
import Element exposing (alpha)
import Element exposing (moveLeft)


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
    , body = [ circle, aboutGroup, puzzleGroup ]
    }


aboutGroup =
    Element.column
        [ centerX
        , centerY
        , spacing 30
        ]
        [ Element.el [ Font.size 30,  centerX, centerY ] <| Element.text "Hi, I'm Thanawat!"
        , Element.el [ Font.size 20,  centerX, centerY ] <| Element.text "Learn more about me by clicking one of these puzzle pieces:"
        -- , Element. [ Font.size 20,  centerX, centerY ] <| Element.text "Learn more about me by clicking one of these puzzle pieces:"

        ]


circle : Element msg
circle =
    el [ width <| px 200, height <| px 200, Border.rounded 100, Border.width 3, centerY, centerX ] none

-- Puzzle Pieces:
-- Defines SVG puzzle pieces starting from top left to top right
puzzleGroup =
    Element.column [centerX, spacing 0, padding 0, Element.moveRight 100]   [

    row [centerX, centerY, spacing 0] [
                    -- puzzleButton
                     puzzleButton
                    , puzzleButton1
                   ]
    , row [centerX, centerY, spacing 0] [
                    -- puzzleButton
                     puzzleButton2
                    , puzzleButton3
                   ]
        ]
-- Maybe I can write it as a function to avoid duplication
puzzleButton =
    Element.link
        [ Element.focused
            []
        -- , Element.moveLeft 199
        -- , centerX
        -- , Element.below puzzleButton2

        -- , Element.behindContent puzzleButton2
        ]
        {
            url =   "/life"
            , label = Element.el [ mouseOver [ alpha 0.85 ]] <|   Element.html puzzleSVGTR
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
        , Svg.text_
            [ SvgAttributes.fill "#4C566A"
            , SvgAttributes.x "15"
            , SvgAttributes.y "55"
            , SvgAttributes.fontSize "19"
            , SvgAttributes.fontFamily "monospace"
            , SvgAttributes.fontStyle "Fira Mono"
            ]
            [ Svg.text "Life" ]
        ]



puzzleButton1 =
    Element.link
        [ Element.focused
            []
        , Element.moveLeft 160

        -- , Element.behindContent puzzleButton

        ]
        {
            url =   "/coding"
            , label = Element.el [ mouseOver [ alpha 0.85 ]] <|  Element.html puzzleSVGTL
        }

-- Here, I will just duplicate this:
puzzleSVGTL =
    svg
        [ SvgAttributes.width "300"
        , SvgAttributes.height "300"
        , SvgAttributes.viewBox "0 0 150 150"
        , SvgAttributes.fill "#A3BE8C"
        ]
        [ Svg.rect
            [ SvgAttributes.x "30"
            , SvgAttributes.y "0"
            , SvgAttributes.width "100"
            , SvgAttributes.height "100"
            , SvgAttributes.rx "0"
            , SvgAttributes.ry "0"
            ]
            [
            ]
        , Svg.rect
            [ SvgAttributes.x "0"
            , SvgAttributes.y "30"
            , SvgAttributes.width "40"
            , SvgAttributes.height "40"
            , SvgAttributes.rx "15"
            , SvgAttributes.ry "20"

            -- , SvgAttributes.r "50"
            ]
            []
        --
        -- , Svg.rect
        --     [ SvgAttributes.x "30"
        --     , SvgAttributes.y "90"
        --     , SvgAttributes.width "40"
        --     , SvgAttributes.height "40"
        --     , SvgAttributes.rx "20"
        --     , SvgAttributes.ry "15"

        --     -- , SvgAttributes.r "50"
        --     ]
        --     []
        , Svg.text_
            [ SvgAttributes.fill "#4C566A"
            , SvgAttributes.x "45"
            , SvgAttributes.y "55"
            , SvgAttributes.fontSize "19"
            , SvgAttributes.fontFamily "monospace"
            , SvgAttributes.fontStyle "Fira Mono"
            ]
            [ Svg.text "Coding" ]

        ]

puzzleButton2 =
    Element.link
        [ Element.focused
            []
        , Element.moveUp 160

        -- , Element.onRight puzzleButton3
        -- , centerX

        ]
        {
            url =   "/stats"
            , label = Element.el [ mouseOver [ alpha 0.85 ]] <|  Element.html puzzleSVGBL
        }

-- Here, I will just duplicate this:
puzzleSVGBL =
    svg
        [ SvgAttributes.width "300"
        , SvgAttributes.height "300"
        , SvgAttributes.viewBox "0 0 150 150"
        , SvgAttributes.fill "#D08770"
        ]
        [ Svg.rect
            [ SvgAttributes.x "0"
            , SvgAttributes.y "30"
            , SvgAttributes.width "100"
            , SvgAttributes.height "100"
            , SvgAttributes.rx "0"
            , SvgAttributes.ry "0"
            ]
            [
            ]
        , Svg.rect
            [ SvgAttributes.x "30"
            , SvgAttributes.y "0"
            , SvgAttributes.width "40"
            , SvgAttributes.height "40"
            , SvgAttributes.rx "20"
            , SvgAttributes.ry "15"

            -- , SvgAttributes.r "50"
            ]
            []
        --
        -- , Svg.rect
        --     [ SvgAttributes.x "30"
        --     , SvgAttributes.y "90"
        --     , SvgAttributes.width "40"
        --     , SvgAttributes.height "40"
        --     , SvgAttributes.rx "20"
        --     , SvgAttributes.ry "15"

        --     -- , SvgAttributes.r "50"
        --     ]
        --     []
        , Svg.text_
            [ SvgAttributes.fill "#4C566A"
            , SvgAttributes.x "10"
            , SvgAttributes.y "80"
            , SvgAttributes.fontSize "19"
            , SvgAttributes.fontFamily "monospace"
            , SvgAttributes.fontStyle "Fira Mono"
            ]
            [ Svg.text "Stats" ]

        ]

puzzleButton3 =
    Element.link
        [ Element.focused
            []
        , Element.moveUp 160
        , Element.moveLeft 160

        -- , Element.inFront puzzleButton
        -- , centerX

        ]
        {
            url =   "/hobbies"
            , label = Element.el [ mouseOver [ alpha 0.85 ]] <|  Element.html puzzleSVGBR
        }

-- Here, I will just duplicate this:
puzzleSVGBR =
    svg
        [ SvgAttributes.width "300"
        , SvgAttributes.height "300"
        , SvgAttributes.viewBox "0 0 150 150"
        , SvgAttributes.fill "#BF616A"
        ]
        [ Svg.rect
            [ SvgAttributes.x "30"
            , SvgAttributes.y "30"
            , SvgAttributes.width "100"
            , SvgAttributes.height "100"
            , SvgAttributes.rx "0"
            , SvgAttributes.ry "0"
            ]
            [
            ]
        , Svg.rect
            [ SvgAttributes.x "60"
            , SvgAttributes.y "0"
            , SvgAttributes.width "40"
            , SvgAttributes.height "40"
            , SvgAttributes.rx "20"
            , SvgAttributes.ry "15"

            -- , SvgAttributes.r "50"
            ]
            []
        --
        , Svg.rect
            [ SvgAttributes.x "0"
            , SvgAttributes.y "60"
            , SvgAttributes.width "40"
            , SvgAttributes.height "40"
            , SvgAttributes.rx "20"
            , SvgAttributes.ry "15"

            -- , SvgAttributes.r "50"
            ]
            []
        , Svg.text_
            [ SvgAttributes.fill "#4C566A"
            , SvgAttributes.x "40"
            , SvgAttributes.y "80"
            , SvgAttributes.fontSize "19"
            , SvgAttributes.fontFamily "monospace"
            , SvgAttributes.fontStyle "Fira Mono"
            ]
            [ Svg.text "Hobbies" ]

        ]
