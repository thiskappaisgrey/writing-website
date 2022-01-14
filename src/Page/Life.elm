module Page.Life exposing (Data, Model, Msg, page)

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
    { title = "MY life"
    , body =
        [ el [ Font.size 25, centerX ] <| text "My Life"
        , el [ Font.size 25 ] <| text "A short bio"
        , paragraph [ width <| px 1000, paddingXY 20 0 ]  [
               text """My life's not that interesting.
                     Especially in quarantine, I don't actually do too much these days, I just eat,
                     exercise if I remember to, get distracted for most of the day, and then realize that I have work to do.
                     My solution to that is to tell myself that I have ALL day tommorow to do it.. Anyways,
                     I didn't include photos of other people because I didn't want to add photos of other people without their permission, so you'll just
                     have to look at my uninteresting face 😛."""
              ]
        , el [ Font.size 25 ] <| text "(Some of) My Favorite Songs, in no particular order:"
        , column [ spacing 20, paddingXY 20 0] [
               text <| " Be Yourself - Audioslave/Chris Cornell"
               , text <| " Rex's Blues - Townes Van Zandt"
               , text <| " Althea - Grateful Dead"
               , text <| " Rockstar - Nickleback"
               , text <| " Why Georgia - John Mayer"
              ]
        , el [ Font.size 25 ] <| text "(Some of) My Life in Photos"
        , photosRow

        ]
    , isIndex = False
    }
photosRow = wrappedRow [ centerX, spacing 50] [
              image [ height <| px 350 ] { src="/images/result4.jpg", description = "" }
             , image [ width <| px 400 ] { src="/images/result2.jpg", description = "" }
             , image [ width <| px 400 ] { src="/images/result3.jpg", description = "" }
             , image [ width <| px 400  ] { src="/images/result1.jpg", description = "" }
             , image [ height <| px 350  ] { src="/images/result5.jpg", description = "" }
             , image [ height <| px 350  ] { src="/images/result6.jpg", description = "" }
             , image [ height <| px 350  ] { src="/images/result7.jpg", description = "" }
             , image [ height <| px 350  ] { src="/images/result8.jpg", description = "" }
            ]
-- favQuotes = column [] [
--             Element.el [] <| text "There ain't no dark till something shines, I'm bound to leave this dark behind - Townes van Zandt, Rex's blues"
            -- ]
