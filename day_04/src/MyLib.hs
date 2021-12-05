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
lastBoardWinner = lastBoardWinner' Nothing

lastBoardWinner' :: Maybe (Integer, BingoCard) -> ([Integer], [BingoCard]) -> (Integer, BingoCard)
lastBoardWinner' Nothing ([], _) = error "No winners found or multiple last winners"
lastBoardWinner' (Just winner) ([], _) = winner
lastBoardWinner' lastWinner (n : ns, cards) =
  let cards' = playTurn n cards
      winners = findVictors cards'
      losers = findLosers cards'
   in case winners of
        [] -> lastBoardWinner' lastWinner (ns, losers)
        [x] -> lastBoardWinner' (Just (n, x)) (ns, losers)
        _ -> lastBoardWinner' Nothing (ns, losers)

playTurn :: Integer -> [BingoCard] -> [BingoCard]
playTurn n =
  (fmap . fmap . fmap) playTurnForCell
  where
    playTurnForCell (n', b) = (n', b || n == n')

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
  sum . map fst . filter (not . snd) . concat
