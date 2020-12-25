module Main where

import Data.Aeson (eitherDecodeFileStrict)
import Data.Text (Text, unpack)
import qualified Data.Text.IO as T
import System.FilePath (takeDirectory)
import System.Directory (createDirectoryIfMissing)
import Data.Foldable (traverse_)
import System.Environment (getArgs)
import Control.Lens
import Data.Generics.Product.Fields (field)

import Config

main :: IO ()
main =
    (head <$> getArgs)
        >>= eitherDecodeFileStrict @Config
        >>= traverseOf_ (folded . _files . folded) writeFile
  where
    writeFile :: (Text, Text) -> IO ()
    writeFile (path, content) = do
        let path' = unpack path
        createDirectoryIfMissing True (takeDirectory path')
            *> T.writeFile path' content
        
