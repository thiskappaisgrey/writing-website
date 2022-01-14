module Page.Coding exposing (Data, Model, Msg, page)

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
import Svg as Svg exposing (svg)
import Svg.Attributes


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
    { title = "Coding"
    , body =
        [ el [ Font.size 30, centerX ] <| text "Coding"
        , el [ Font.size 25 ] <| text "Languages"
        , row [ spacing 30] [

         language "Haskell" """Haskell is currently my favorite language despite recently learning it.
                              I like it because it makes coding like putting together legos(because of the purity).
                              Also, it makes me feel superior(I know, languge doesn't matter) and boosts my ego a bit, haha.
                              I know I have a long way to go though""" "https://wiki.haskell.org/wikiupload/4/4a/HaskellLogoStyPreview-1.png" 4
        , language "Javascript/TypeScript + HTML/CSS" """The web languages are first coding languages I've ever learned.
                                                       I mostly self-taught myself through coding tutorials on YouTube(and a bit of freecodecamp)
                                                       to complete projects for my former robotics team(that I was a part of in high school).
                                                       I ended up not contributing much but it was a great learning experience anyways.""" "https://upload.wikimedia.org/wikipedia/commons/b/b2/WWW_logo_by_Robert_Cailliau.svg"  4
              ]
        , el [ Font.size 25 ] <| text "Making this website"
        , paragraph [ paddingXY 20 0,  width <| px 1000] [
               text <| """This website is written in """
            , newTabLink [ mouseOver [ alpha 0.85 ]] {url =  "https://elm-lang.org/", label = el [Font.color Shared.color.green] <| text  "Elm"}
            , text <| """, using a static site generator(a program that tranform some data, like text files, into websites. Similar to wix but the website
                       generated is static, as in, doesn't require a server, than dynamic, as in runs on a server), called """
            , newTabLink [ mouseOver [ alpha 0.85 ]] {url =  "https://elm-pages.com/", label = el [Font.color Shared.color.green] <| text  "Elm Pages"}
            , text  """Anyways, Elm is a stripped down version(or so) variant of Haskell(as in, it's inspired by Haskell), that is designed to run on the web.
                     It's meant to introduce people to functional programming, so you should try it if you want to learn more. I also styled everything with """
            , newTabLink [ mouseOver [ alpha 0.85 ]] {url =  "https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest", label = el [Font.color Shared.color.green] <| text  "Elm-UI"}
            , text <| """ rather than CSS. I think it's a cool concept but there's some missing stuff and it's a bit different than CSS(you style individual elements instead of groups.
                       There's also missing stuff too..). I think, for now, I prefer to style with  """
            , newTabLink [ mouseOver [ alpha 0.85 ]] {url =  "https://tailwindcss.com/", label = el [Font.color Shared.color.green] <| text  "Tailwind CSS"}
            , text """ instead. If you are not familiar with web technology, then this probably meant nothing to you. If you're still learning and feel overwhelmed, then I think you can do it!
                    If an idiot like me can learn this much, anyone can. Feel free to look at the source code of this website at: """
            , newTabLink [ mouseOver [ alpha 0.85 ]] {url =  "", label = el [Font.color Shared.color.green] <| text  "Github"}
              ]

        ]
    , isIndex = False
    }


language lang desc photoUrl rating =
    row [  width (px 900)  ]
        [ column [ spacing 20]
            [ el [ Font.size 23 ] <| text lang
            , row [] <| ((List.repeat rating <| star "#EBCB8B") ++  (List.repeat (5 - rating) <| star "#D8DEE9"))
            , paragraph [  width <| px 400] [ text desc ]
            ]
        , image [ width <| px 400, alignRight ] { src = photoUrl, description = "" }
        ]
star fill =
     Element.html <| svg
        [ Svg.Attributes.width "50"
        , Svg.Attributes.height "50"
        , Svg.Attributes.viewBox "0 0 300 300"
        ]
        [
         Svg.polygon [ Svg.Attributes.points "100,10 40,180 190,60 10,60 160,180"
                     , Svg.Attributes.fill fill ] []
        ]
