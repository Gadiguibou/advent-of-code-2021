{-# LANGUAGE TupleSections #-}

module MyLib (part1, part2) where

import Control.Arrow ((>>>))
import Data.List (transpose)
import Data.List.Split (splitOn)

type BingoCard = [[(Integer, Bool)]]

part1 :: String -> String
part1 = parseInput >>> firstBoardWinner >>> calculateScore >>> show

part2 :: String -> String
part2 = parseInput >>> lastBoardWinner >>> calculateScore >>> show

parseInput :: String -> ([Integer], [BingoCard])
parseInput s =
  case splitOn "\n\n" s of
    [] -> error "No input"
    x : xs -> (parseNumbers x, parseCards xs)

parseCards :: [String] -> [BingoCard]
parseCards = fmap parseCard
  where
    parseCard = fmap parseLine . lines
    parseLine = fmap ((,False) . read) . words

parseNumbers :: String -> [Integer]
parseNumbers =
  splitOn "," >>> fmap read

firstBoardWinner :: ([Integer], [BingoCard]) -> (Integer, BingoCard)
firstBoardWinner ([], _) = error "No more numbers"
firstBoardWinner (n : ns, cards) =
  let cards' = playTurn n cards
   in case findVictors cards' of
        [] -> firstBoardWinner (ns, cards')
        [x] -> (n, x)
        _ -> error "Multiple winners"

lastBoardWinner :: ([Integer], [BingoCard]) -> (Integer, BingoCard)
lastBoardWinner ([], _) = error "No more numbers"
lastBoardWinner (n : ns, cards) =
  let cards' = playTurn n cards
   in case findLosers cards' of
        -- Wait for one card to be left and calculate its score when it finally wins
        -- This assumes all cards will win at some point which may not be the case
        [] -> error "Multiple cards won on the last turn"
        [x] -> firstBoardWinner (ns, [x])
        xs -> lastBoardWinner (ns, xs)

playTurn :: Integer -> [BingoCard] -> [BingoCard]
playTurn n =
  let playTurnForCell n (n', b) = (n', b || n == n')
   in (fmap . fmap . fmap . playTurnForCell) n

findVictors :: [BingoCard] -> [BingoCard]
findVictors =
  filter checkVictory

findLosers :: [BingoCard] -> [BingoCard]
findLosers =
  filter (not . checkVictory)

checkVictory :: BingoCard -> Bool
checkVictory card = checkVictoryRows card || checkVictoryColumns card
  where
    checkVictoryRows = any (all snd)
    checkVictoryColumns = transpose >>> checkVictoryRows

calculateScore :: (Integer, BingoCard) -> Integer
calculateScore (n, card) =
  sumUnmarkedCells card * n

sumUnmarkedCells :: BingoCard -> Integer
sumUnmarkedCells =
  sum . fmap (sum . fmap (\(n, b) -> if not b then n else 0))
