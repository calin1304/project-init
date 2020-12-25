module Config where

import Data.Aeson
import Data.Aeson.Types (Parser)
import qualified Data.Aeson.Types as A
import Data.Bifunctor (second)
import Data.HashMap.Strict (toList)
import Data.Text
import GHC.Generics (Generic)

data Config = Config
    { files :: [(Text, Text)]
    }
    deriving stock (Show, Generic)

instance FromJSON Config where
    parseJSON = withObject "Config" $ \obj ->
        let 
            files :: Parser [(Text, Text)]
            files = (fmap (second mkFile) . toList) <$> (obj .: "files" :: Parser Object)
            
            mkFile :: A.Value -> Text
            mkFile (A.String t) = t
            mkFile _ = error "Invalid config file"
         in 
            Config <$> files