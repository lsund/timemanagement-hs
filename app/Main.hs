module Main where

import qualified Data.Map.Strict as M
import Data.List (sortBy)
import Data.Map.Strict (Map)
import Data.List.Split (splitOn)
import System.Environment (getArgs)

type Time = (Int, Int)
type Activity = String

data Entry = Entry { _time :: Time, _activity :: Activity }
    deriving (Show)

aggregateMinutes :: [Entry] -> Map Activity Int
aggregateMinutes (e : es) =
    fst $ foldl
        (\(acc, (Entry (h', m') a')) entry@(Entry (h, m) a) ->
            case M.lookup a' acc of
              Just a'' -> (M.adjust (+ minuteDiff (h', m') (h, m)) a' acc, entry)
              Nothing -> (M.insert a' (minuteDiff (h', m') (h, m)) acc, entry))
        (M.empty, e) es


minutesToTime :: Int -> Time
minutesToTime x = (div x 60, rem x 60)


-- First argument is smaller than the second
minuteDiff :: Time -> Time -> Int
minuteDiff (h1, m1) (h2, m2) = ((h2 - h1) * 60) + m2 - m1


makeEntry :: [String] -> Maybe Entry
makeEntry [] = Nothing
makeEntry [x] = Nothing
makeEntry (x : xs) = Just $ Entry (makeTime x) (unwords xs)
    where
          makeTime x =
              let [hours, minutes] = splitOn ":" x -- FIXME bad pattern match
               in (read hours :: Int, read minutes :: Int)

main :: IO ()
main = do
    args <- getArgs
    if (not . null) args
       then
        do
            let file = head args
            content <- readFile file
            case mapM (makeEntry . words) $ lines content of
                Just es -> (mapM_ print . sortBy (\(_, t1) (_, t2) -> t2 `compare` t1) . M.toList . M.map minutesToTime . aggregateMinutes) es
                Nothing -> putStrLn $ "Problem reading " <> file
       else
            putStrLn "Usage: ./timemanagement-hs FILE"

