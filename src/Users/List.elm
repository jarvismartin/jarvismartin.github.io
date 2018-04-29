module Users.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Models exposing (Res, User)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)


view : WebData Res -> Html Msg
view response =
    div []
        [ nav
        , maybeList response
        ]


nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Users" ] ]


maybeList : WebData Res -> Html Msg
maybeList response =
    case response of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Success response ->
            list response.results

        RemoteData.Failure error ->
            text ("ERROR! " ++ toString error)


list : List User -> Html Msg
list users =
    div [ class "p2" ]
        [ table []
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , th [] [ text "Name" ]
                    , th [] [ text "Level" ]
                    , th [] [ text "Actions" ]
                    ]
                ]
            , tbody [] (List.map userRow users)
            ]
        ]


userRow : User -> Html Msg
userRow user =
    tr []
        [ td [] [ text user.id.name ]
        , td [] [ text user.name.first ]
        , td [] [ text (toString user.id.value) ]
        , td []
            []
        ]
