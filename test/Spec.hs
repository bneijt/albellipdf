
import Test.Hspec
import Test.QuickCheck
import Control.Exception (evaluate)
import Decrypt
import Data.Char (chr)
-- import System.IO (withBinaryFile, IOMode(ReadMode, WriteMode))

import qualified Data.ByteString.Char8 as B

main :: IO ()
main = hspec $ do
    describe "Decrypt" $ do
        it "finds a zero key if the header is already good" $ do
            (determineKey (B.pack "ABCD") (B.pack "ABCD")) `shouldBe` (B.singleton (chr 0))
        it "finds a key if the header is encrypted" $ do
            (determineKey (B.pack "+^JH#") (B.pack "%PDF-")) `shouldBe` (B.singleton (chr 14))
