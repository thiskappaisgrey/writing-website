module Page.Life exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.File
import Element
import Head
import Head.Seo as Seo
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Parser exposing (DeadEnd, run)
import Shared
import Slide exposing (..)
import Svg.Attributes exposing (offset)
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
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Thanawat's website"
    , body = [ renderSlides static.data]
    }

-- TODO figure out a way to render the "slides"
renderSlides : Data -> Element.Element msg
renderSlides d =
    case d of
        Ok a ->
            Element.text <| Debug.toString a

        Err err ->
            Element.text <| Debug.toString err
