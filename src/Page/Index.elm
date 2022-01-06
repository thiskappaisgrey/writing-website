module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)

import Element exposing (Element, el, text, row, alignRight, fill, width,  spacing, centerY, padding)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element exposing (fillPortion)
import Element exposing (height)
import Element exposing (px)
import Element exposing (none)
import Element exposing (centerX)
import Element.Background exposing (color)
import Element.Input

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
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    homepage "Index"

homepage : String -> View msg
homepage moduleName =
    { title = "Homepage - " ++ moduleName
    , body = [ circle, buttonGroup ]
    }

circle : Element msg
circle = el [ width <| px 200, height <| px 200, Border.rounded 100, Border.width 3, centerY, centerX ] none
-- TODO add nord colors
buttonGroup = row [ spacing 20, centerX, centerY ] [ button "Interests", button "Hobbies", button "Timeline" ]
-- TODO Add to component file
button : String -> Element msg
button t = Element.Input.button
                [ padding 20
                , Background.color Shared.color.yellow
                -- , Border.width 2
                , Border.rounded 16
                -- , Border.color Shared.color.orange
                -- , Border.shadow
                --     { offset = ( 4, 4 ), size = 3, blur = 10, color = Shared.color.lightGrey }
                , Font.color Shared.color.lightGrey
                -- , mouseDown
                --     [ Background.color color.white, Font.color color.darkCharcoal ]
                -- , focused
                --     [ Border.shadow
                --         { offset = ( 4, 4 ), size = 3, blur = 10, color = color.blue }
                --     ]
                , centerX
                , centerY
                ]
                { onPress = Nothing
                , label = text t
                }
