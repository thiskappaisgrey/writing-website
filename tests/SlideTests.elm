module SlideTests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Parser.Advanced exposing (run)
import Slide exposing (..)
import Test exposing (..)



-- TODO write actual tests for the parser


tests : Test
tests =
    describe "Test parseLine"
        [ test "parse line should get text between -- symbols, getting rid of extra newline symbols"
            (\_ -> Expect.equal (run parseLine testString) (Ok "hello\n"))
        , test "parseSlide should yield a slide" (\_ -> Expect.equal (run parseSlide testSlideString) (Ok <| Slide "Hello World\nsomething\n" "/hello/world"))
        , test "parseSlides should yield multiple slides"
            (\_ ->
                Expect.equal
                    (run parseSlides testSlideString2)
                    (Ok <|
                        [ Slide "Hello World\n" "/hello/world"
                        , Slide "World Hello\n" "/hello/world"
                        , Slide "Kappa\n" "/kappa"
                        ]
                    )
            )
        ]


testString =
    """--
hello
--"""


testSlideString =
    """
begin_slide
--
Hello World
something
--
/hello/world
end_slide"""


testSlideString2 =
    """
begin_slide
--
Hello World
--
/hello/world
end_slide
begin_slide
--
World Hello
--
/hello/world
end_slide
begin_slide
--
Kappa
--
/kappa
end_slide"""
