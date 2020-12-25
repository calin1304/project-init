module Main where

import Data.Aeson (eitherDecodeFileStrict)
import Data.Text (Text, unpack)
import qualified Data.Text.IO as T
import System.FilePath (takeDirectory)
import System.Directory (createDirectoryIfMissing)
import Data.Foldable (traverse_)
import System.Environment (getArgs)

import Config

main :: IO ()
main =
    (head <$> getArgs)
        >>= eitherDecodeFileStrict @Config
        >>= traverse_ (\config -> traverse_ writeFile (files config))
  where
    writeFile :: (Text, Text) -> IO ()
    writeFile (path, content) = do
        let path' = unpack path
        createDirectoryIfMissing True (takeDirectory path')
            *> T.writeFile path' content
        
