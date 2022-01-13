module Page.Life.Number__ exposing (Data, Model, Msg, page)

import Browser.Navigation
import DataSource exposing (DataSource)
import DataSource.File
import Dict exposing (Dict)
import Element exposing (..)
import Element.Font as Font
import Element.Input exposing (button)
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
import Task
import View exposing (View)


type alias Model =
    { slideDict : Result (List DeadEnd) (Dict String Slide)
    }


type Direction
    = Prev
    | Next


type Msg
    = None
    | FixUrl
    | Nav Direction


type alias RouteParams =
    { number : Maybe String }



-- TODO figure out how to model the slide state(maybe using a dictionary of numbers)
-- Also get the slide number from the URL
-- Also, when button(or navigation key) is clicked, animate the slide by changing the opacity


page : PageWithState RouteParams Data Model Msg
page =
    Page.prerender
        { head = head
        , data = \a -> data
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
            List.indexedMap (\a b -> RouteParams <| Just (String.fromInt a)) list |> (::) (RouteParams Nothing)


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
    -- let
    --     currSlide =   Maybe.withDefault "0" static.routeParams.number
    --                   |> String.toInt
    --                   |> Maybe.withDefault 0
    --     -- debug =   Debug.log "init is called with currSlide: " currSlide
    -- in
    case static.data of
        Err a ->
            ( Model (Err a), Cmd.none )

        Ok a ->
            ( Model (Ok (indexedMap (\x y -> ( String.fromInt x, y )) a |> Dict.fromList))
            , case static.routeParams.number of
                Just _ ->
                    Cmd.none

                Nothing ->
                    Cmd.none
                    -- Task.succeed FixUrl |> Task.perform identity
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
        FixUrl ->
            ( model
            , maybeNavigationKey
                |> Maybe.map
                    (\navKey ->
                        Browser.Navigation.pushUrl navKey
                            "/life/0"
                    )
                |> Maybe.withDefault Cmd.none
            )

        Nav direction ->
            let
                totalSlides =
                    Result.withDefault Dict.empty model.slideDict |> Dict.size

                currentSlide =
                    Maybe.withDefault "0" static.routeParams.number |> String.toInt |> Maybe.withDefault 0

                nextSlide =
                    clamp
                        0
                        (totalSlides - 1)
                        (case direction of
                            Next ->
                                currentSlide + 1

                            Prev ->
                                currentSlide - 1
                        )
            in
            ( model
            , maybeNavigationKey
                |> Maybe.map
                    (\navKey ->
                        Browser.Navigation.pushUrl navKey
                            ("/life/"
                                ++ String.fromInt
                                    nextSlide
                            )
                    )
                |> Maybe.withDefault Cmd.none
            )

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
    { title = "Thoughts on life"
    , body =
        [ el [ centerX, Font.size 40, Font.variant Font.smallCaps ] (text "life")
        , renderSlides model static.routeParams
        , slideNavButtons static.routeParams model
        ]
    , isIndex = False
    }



-- TODO Add fade in animation for the slides


renderSlides : Model -> RouteParams -> Element.Element msg
renderSlides d params =
    case d.slideDict of
        Ok a ->
            renderSlide <| Dict.get (Maybe.withDefault "0" params.number) a

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
    row [ centerX, centerY  ] [ paragraph [ width (fillPortion 1) ] [ text s.text ], el [ width (fillPortion 1), centerX, Font.center ] (text s.image) ]


slideNavButtons : RouteParams -> Model -> Element Msg
slideNavButtons routeParams model =
    let
        prev =
            case routeParams.number of
                Nothing ->
                    []

                Just "0" ->
                    []

                Just _ ->
                    [ button
                        [ alignLeft
                        , Font.color Shared.color.yellow
                        , Element.focused []
                        , mouseOver [ Font.color Shared.color.orange ]
                        ]
                        { label = text "Previous"
                        , onPress = Just (Nav Prev)
                        }
                    ]

        totalSlides =
            Result.withDefault Dict.empty model.slideDict |> Dict.size
        debug = Debug.log "total slides: " totalSlides
        next =
            case routeParams.number of
                Nothing ->
                    [ button
                            [ alignRight
                            , Font.color Shared.color.green
                            , Element.focused []
                            , mouseOver [ Font.color Shared.color.purple ]
                            ]
                            { label = text "Next"
                            , onPress = Just (Nav Next)
                            }
                        ]

                Just a ->
                    if a == String.fromInt (totalSlides - 1) then
                        []

                    else
                        [ button
                            [ alignRight
                            , Font.color Shared.color.green
                            , Element.focused []
                            , mouseOver [ Font.color Shared.color.purple ]
                            ]
                            { label = text "Next"
                            , onPress = Just (Nav Next)
                            }
                        ]
    in
    row [ width fill, padding 30 , Font.size 30 ] <|
        prev
            ++ next
