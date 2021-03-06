{-# LANGUAGE OverloadedStrings #-}
module Decrypt where

import Data.Char (chr)
import System.IO (withBinaryFile, IOMode(ReadMode, WriteMode), Handle)
import Data.Bits (xor)
import System.FilePath (addExtension, dropExtensions)
import Data.Word (Word8)

import Control.Monad (when)

import qualified Data.ByteString as B

type Key = Word8

determineKey :: B.ByteString -> B.ByteString -> Key
determineKey currentHeader expectedHeader = if ka == kb && kb == kc
    then ka
    else error "Wel encryptie, maar een nieuwe onbekende vorm"
    where
        ka = xor (B.index currentHeader 0) (B.index expectedHeader 0)
        kb = xor (B.index currentHeader 1) (B.index expectedHeader 1)
        kc = xor (B.index currentHeader 2) (B.index expectedHeader 2)

bufferSize :: Int
bufferSize = 1024

crypt :: Key -> B.ByteString -> B.ByteString
crypt key = B.pack . B.zipWith xor (B.singleton key)


transcodeStream :: Handle -> Key -> Handle -> IO()
transcodeStream inputHandle key outputHandle = do
    input <- B.hGet inputHandle bufferSize
    when (B.length input > 0) $ do
            B.hPut outputHandle (crypt key input)
            transcodeStream inputHandle key outputHandle


transcodeFile :: FilePath -> FilePath -> Key -> IO ()
transcodeFile inputPath outputPath key = do
    putStrLn $ inputPath ++ " -> " ++ outputPath
    withBinaryFile inputPath ReadMode (\inputHandle ->
            withBinaryFile outputPath WriteMode (transcodeStream inputHandle key)
                )


decryptFile :: FilePath -> IO FilePath
decryptFile path = do
    let pdfHeader = "%PDF" :: B.ByteString
    firstBytes <- withBinaryFile path ReadMode (\handle -> B.hGet handle (B.length pdfHeader))
    if firstBytes == pdfHeader
        then do
            putStrLn "Mooi, niet versleuteld"
            return path
        else do
            --Determine XOR byte
            let key = determineKey firstBytes pdfHeader
            let decryptedFilePath = addExtension (dropExtensions path ++ "_decrypted") "pdf"
            putStrLn ("Vesleuteld met: " ++ show key)
            transcodeFile path decryptedFilePath key
            return decryptedFilePath
