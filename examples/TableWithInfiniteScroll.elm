module TableWithInfiniteScroll exposing (main)

import Browser
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)
import InfiniteList as IL


type Msg
    = InfListMsg IL.Model


type alias Model =
    { infList : IL.Model
    , items : List Item
    }


type alias Item =
    { itemId : Int
    , itemName : String
    }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initModel
        , view = view
        , update = update
        }


mkItem : Int -> Item
mkItem id =
    Item id ("item" ++ String.fromInt id)


initModel : Model
initModel =
    { infList = IL.init
    , items = List.range 0 1000 |> List.map mkItem
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        InfListMsg infList ->
            { model | infList = infList }


px : String -> String
px str =
    str ++ "px"


itemHeight : Int
itemHeight =
    48


containerHeight : Int
containerHeight =
    500


columns : List Int
columns =
    List.range 0 40


columnWidth : Int
columnWidth =
    185


config : IL.Config String Msg
config =
    IL.config
        { itemView = itemView
        , itemHeight = IL.withConstantHeight itemHeight
        , containerHeight = containerHeight
        }
        |> IL.withOffset 300


itemView : Int -> Int -> String -> Html Msg
itemView idx listIdx item =
    div
        [ style "height" (String.fromInt itemHeight ++ "px")
        ]
        [ text item ]



-- view : Model -> Html Msg
-- view model =
--     div
--         [ style "height" (String.fromInt containerHeight ++ "px")
--         , style "width" "500px"
--         , style "overflow" "auto"
--         , style "border" "1px solid #000"
--         , style "margin" "auto"
--         , IL.onScroll InfListMsg
--         ]
--         [ IL.view config model.infList model.content ]


view : Model -> Html Msg
view model =
    div
        [ style "height" <| px (String.fromInt containerHeight)
        , style "background" "lightcoral"
        , style "overflow" "auto"
        ]
        [ headers
        , body model
        ]


headers : Html Msg
headers =
    let
        mkHeader num =
            div
                [ style "width" <| px (String.fromInt columnWidth)
                , style "min-width" <| px (String.fromInt columnWidth)
                , style "max-width" <| px (String.fromInt columnWidth)
                , style "background" "lightgreen"
                , style "display" "table-cell"
                , style "height" <| px (String.fromInt itemHeight)
                , style "vertical-align" "middle"
                ]
                [ text <| "Column " ++ String.fromInt num ]
    in
    div [ style "display" "table-header-group" ]
        [ div [ style "display" "table-row" ] <| List.map mkHeader columns
        ]


body : Model -> Html Msg
body { items } =
    let
        mkCell num =
            div
                [ style "width" <| px (String.fromInt columnWidth)
                , style "min-width" <| px (String.fromInt columnWidth)
                , style "max-width" <| px (String.fromInt columnWidth)
                , style "background" "lightblue"
                , style "display" "table-cell"
                , style "height" <| px (String.fromInt itemHeight)
                , style "vertical-align" "middle"
                ]
                [ text <| "Column " ++ String.fromInt num ]

        mkRow item =
            div
                [ style "display" "table-row" ]
            <|
                List.map mkCell columns
    in
    div [ style "display" "table-row-group" ] <|
        List.map mkRow items
