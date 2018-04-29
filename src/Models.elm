module Models exposing (..)

import RemoteData exposing (WebData)


type alias Model =
    { users : WebData Res }


initialModel : Model
initialModel =
    { users = RemoteData.Loading
    }


type Route
    = UsersRoute
    | UserRoute Id
    | NotFoundRoute


type alias Name =
    { title : String
    , first : String
    , last : String
    }


type alias Location =
    { street : String
    , city : String
    , state : String
    , postcode : String
    }


type alias Login =
    { username : String
    , password : String
    , salt : String
    , md5 : String
    , sha1 : String
    , sha256 : String
    }


type alias Id =
    { name : String
    , value : String
    }


type alias Picture =
    { large : String
    , medium : String
    , thumbnail : String
    }


type alias User =
    { gender : String
    , name : Name
    , location : Location
    , email : String
    , login : Login
    , dob : String
    , registered : String
    , phone : String
    , cell : String
    , id : Id
    , picture : Picture
    , nat : String
    }


type alias Info =
    { seed : String
    , results : Int
    , page : Int
    , version : String
    }


type alias Res =
    { results : List User
    , info : Info
    }
