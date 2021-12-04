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
parseCards =
  map lines
    >>> map (map words)
    >>> map (map (map (read :: String -> Integer)))
    >>> map (map (map (,False)))

parseNumbers :: String -> [Integer]
parseNumbers =
  splitOn "," >>> map (read :: String -> Integer)

findVictors :: [BingoCard] -> [BingoCard]
findVictors =
  filter checkVictory

findLosers :: [BingoCard] -> [BingoCard]
findLosers =
  filter (not . checkVictory)

checkVictory :: BingoCard -> Bool
checkVictory card =
  checkVictoryRows card || checkVictoryColumns card

checkVictoryRows :: BingoCard -> Bool
checkVictoryRows =
  any (all snd)

checkVictoryColumns :: BingoCard -> Bool
checkVictoryColumns =
  transpose >>> checkVictoryRows

firstBoardWinner :: ([Integer], [BingoCard]) -> (Integer, BingoCard)
firstBoardWinner (numbers, cards) =
  case numbers of
    [] -> error "No more numbers"
    n : ns ->
      let cards' = playTurn n cards
       in case findVictors cards' of
            [] -> firstBoardWinner (ns, cards')
            [x] -> (n, x)
            _ -> error "Multiple winners"

lastBoardWinner :: ([Integer], [BingoCard]) -> (Integer, BingoCard)
lastBoardWinner (numbers, cards) =
    case numbers of
        [] -> error "No more numbers"
        n : ns ->
            let cards' = playTurn n cards
            in case findLosers cards' of
                -- Wait for one card to be left and calculate its score when it finally wins
                -- This assumes all cards will win at some point which may not be the case
                [] -> error "Multiple cards won on the last turn"
                [x] -> firstBoardWinner (ns, [x])
                xs -> lastBoardWinner (ns, xs)

playTurn :: Integer -> [BingoCard] -> [BingoCard]
playTurn n =
  map (playTurnForCard n)

playTurnForCard :: Integer -> BingoCard -> BingoCard
playTurnForCard n =
  map (playTurnForRow n)

playTurnForRow :: Integer -> [(Integer, Bool)] -> [(Integer, Bool)]
playTurnForRow n =
  map (playTurnForCell n)

playTurnForCell :: Integer -> (Integer, Bool) -> (Integer, Bool)
playTurnForCell n (n', b)
  | n == n' = (n, True)
  | otherwise = (n', b)

calculateScore :: (Integer, BingoCard) -> Integer
calculateScore (n, card) =
  sumUnmarkedCells card * n

sumUnmarkedCells :: BingoCard -> Integer
sumUnmarkedCells =
  sum . map (sum . map (\(n, b) -> if not b then n else 0))
