module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, optional, required)
import Models exposing (Id, Info, Location, Login, Name, Picture, Res, User)
import Msgs exposing (Msg)
import RemoteData


fetchUsers : String -> Cmd Msg
fetchUsers num =
    Http.get (fetchUsersUrl num) resDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchUsers


fetchUsersUrl : String -> String
fetchUsersUrl int =
    "https://randomuser.me/api/?results=" ++ int


resDecoder : Decode.Decoder Res
resDecoder =
    decode Res
        |> required "results" (Decode.list userDecoder)
        |> required "info" infoDecoder


userDecoder : Decode.Decoder User
userDecoder =
    decode User
        |> required "gender" Decode.string
        |> required "name" nameDecoder
        |> required "location" locationDecoder
        |> required "email" Decode.string
        |> required "login" loginDecoder
        |> required "dob" Decode.string
        |> required "registered" Decode.string
        |> required "phone" Decode.string
        |> required "cell" Decode.string
        |> required "id" idDecoder
        |> required "picture" pictureDecoder
        |> required "nat" Decode.string


nameDecoder : Decode.Decoder Name
nameDecoder =
    decode Name
        |> required "title" Decode.string
        |> required "first" Decode.string
        |> required "last" Decode.string


locationDecoder : Decode.Decoder Location
locationDecoder =
    decode Location
        |> required "street" Decode.string
        |> required "city" Decode.string
        |> required "state" Decode.string
        |> required "postcode" (Decode.oneOf [ Decode.string, Decode.map toString Decode.int ])


loginDecoder : Decode.Decoder Login
loginDecoder =
    decode Login
        |> required "username" Decode.string
        |> required "password" Decode.string
        |> required "salt" Decode.string
        |> required "md5" Decode.string
        |> required "sha1" Decode.string
        |> required "sha256" Decode.string


idDecoder : Decode.Decoder Id
idDecoder =
    decode Id
        |> required "name" Decode.string
        |> optional "value" Decode.string "NULL"


pictureDecoder : Decode.Decoder Picture
pictureDecoder =
    decode Picture
        |> required "large" Decode.string
        |> required "medium" Decode.string
        |> required "thumbnail" Decode.string


infoDecoder : Decode.Decoder Info
infoDecoder =
    decode Info
        |> required "seed" Decode.string
        |> required "results" Decode.int
        |> required "page" Decode.int
        |> required "version" Decode.string
