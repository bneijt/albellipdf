module Lib (
    pollForOrderFile,
    findAndKill
    ) where

import System.Directory (getDirectoryContents, findFiles, getTemporaryDirectory, doesFileExist, renameFile)
import System.FilePath ((</>), takeDirectory)
import Control.Concurrent (threadDelay)
import System.Process (callCommand)
import System.Random (getStdRandom, randomR)
import System.IO (hFlush, stdout, hSetBuffering, BufferMode(NoBuffering))
import Decrypt


findOrderFilesBelow :: FilePath -> IO [FilePath]
findOrderFilesBelow basePath = do
    candidateDirectories <- getDirectoryContents basePath
    -- Version 10.0.0.1189 uses ORDER.$$$
    ca <- findFiles (map (\x -> basePath </> x) candidateDirectories) "ORDER.$$$"
    -- Version 10.0.1.1228 uses ORDER.APP again, not sure why they switch back and forth
    cb <- findFiles (map (\x -> basePath </> x) candidateDirectories) "ORDER.APP"
    return $ ca ++ cb

findOrderFiles :: IO [FilePath]
findOrderFiles = do
    temporaryPath <- getTemporaryDirectory
    findOrderFilesBelow temporaryPath

pollForOrderFile :: IO FilePath
pollForOrderFile = do
    threadDelay 500
    candidateFiles <- findOrderFiles
    case length candidateFiles of
        0 -> pollForOrderFile
        1 -> return (head candidateFiles)
        _ -> error ("Meerdere candidaten voor ORDER.$$$ gevonden. Ruim aub zelf deze bestanden op: " ++ show candidateFiles)

waitForAlbFileNextTo :: FilePath -> IO ()
waitForAlbFileNextTo orderFilePath = do
    threadDelay 500
    startedPacking <- doesFileExist (takeDirectory orderFilePath </> "ORDER.ALB")
    if startedPacking
        then return ()
        else waitForAlbFileNextTo orderFilePath

randomOrderPdfName :: IO FilePath
randomOrderPdfName =  do
    number <- getStdRandom (randomR (1, 9999)) :: IO Int
    return ("order_" ++ show number ++ ".pdf")

findAndKill :: IO()
findAndKill = do
    hSetBuffering stdout NoBuffering
    putStrLn "Wachten op order bestand..."
    orderFilePath <- pollForOrderFile
    putStrLn ("Gevonden: " ++ orderFilePath)
    putStrLn "Klaar om zodra inpakken begint Albelli te stoppen..."
    waitForAlbFileNextTo orderFilePath
    putStrLn "ALB bestand gevonden, stop nu Albelli"
    callCommand "taskkill /f /im apc.exe"
    threadDelay 500
    outputPath <- randomOrderPdfName
    renameFile orderFilePath outputPath
    decryptFile outputPath
    putStrLn "Druk op enter dit programma te sluiten"
    _ <- getLine
    return ()
