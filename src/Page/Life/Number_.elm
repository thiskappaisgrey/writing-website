module Page.Life.Number_ exposing (Data, Model, Msg, page)

import Browser.Navigation
import DataSource exposing (DataSource)
import DataSource.File
import Dict exposing (Dict)
import Element exposing (..)
import Element.Font as Font
import Head
import Head.Seo as Seo
import List exposing (indexedMap)
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Parser exposing (DeadEnd, run)
import Shared exposing (color)
import Slide exposing (..)
import Svg.Attributes exposing (offset)
import View exposing (View)


type alias Model =
    { slideDict : Result (List DeadEnd) (Dict String Slide)
    }


type alias Msg =
    Never


type alias RouteParams =
    { number : String }



-- TODO figure out how to model the slide state(maybe using a dictionary of numbers)
-- Also get the slide number from the URL


page : PageWithState RouteParams Data Model Msg
page =
    Page.prerender
        { head = head
        , data = (\a -> data)
        , routes = routes
        }
        |> Page.buildWithLocalState
            { view = view
            , init = init
            , update = update
            , subscriptions =
                \maybePageUrl routeParams path model ->
                    Sub.none
            }

routesHelper : Data -> List RouteParams
routesHelper d =
            case d of
                Err a ->
                    []

                Ok list ->
                         List.indexedMap (\a b -> RouteParams <| String.fromInt a) list
routes : DataSource (List RouteParams)
routes =
    DataSource.map routesHelper data
        -- (\d ->
        -- )


init :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> ( Model, Cmd Msg )
init url sharedModel static =
    case static.data of
        Err a ->
            ( Model (Err a) , Cmd.none )

        Ok a ->
            ( Model (Ok (indexedMap (\x y -> ( String.fromInt x, y )) a |> Dict.fromList)) , Cmd.none )


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


type alias Data =
    Result (List DeadEnd) (List Slide)


data : DataSource Data
data =
    DataSource.File.rawFile "content/life.slide" |> DataSource.map (run parseSlides)


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
    -> Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel model static =
    { title = "Thanawat's website"
    , body = [ el [ centerX, Font.size 40, Font.variant Font.smallCaps ] (text "life"), renderSlides model static.routeParams ]
    }



-- TODO figure out a way to render the "slides"


renderSlides : Model -> RouteParams -> Element.Element msg
renderSlides d params =
    case d.slideDict of
        Ok a ->
            renderSlide <| Dict.get params.number a

        Err err ->
            Element.text <| Debug.toString err


renderSlide : Maybe Slide -> Element msg
renderSlide slide =
    case slide of
        Just s ->
            singleSlide s

        Nothing ->
            Element.text "Slide not found"


singleSlide : Slide -> Element msg
singleSlide s =
    row [ centerX, centerY ] [ paragraph [ width (fillPortion 1) ] [ text s.text ], el [ width (fillPortion 1), centerX, Font.center ] (text s.image) ]
