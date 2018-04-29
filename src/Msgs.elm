module Msgs exposing (..)

import Models exposing (Res)
import RemoteData exposing (WebData)


type Msg
    = OnFetchUsers (WebData Res)
