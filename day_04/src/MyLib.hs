{-# LANGUAGE TupleSections #-}

module MyLib (part1, part2) where

import Control.Arrow ((>>>))
import Data.List (transpose)
import Data.List.Split (splitOn)

type BingoCard = [[(Integer, Bool)]]

part1 :: String -> String
part1 = parseInput >>> firstWinningCard >>> calculateScore >>> show

part2 :: String -> String
part2 = parseInput >>> lastWinningCard >>> calculateScore >>> show

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

firstWinningCard :: ([Integer], [BingoCard]) -> (Integer, BingoCard)
firstWinningCard ([], _) = error "No more numbers"
firstWinningCard (n : ns, cards) =
  let cards' = playTurn n cards
   in case findVictors cards' of
        [] -> firstWinningCard (ns, cards')
        [x] -> (n, x)
        _ -> error "Multiple winners"

lastWinningCard :: ([Integer], [BingoCard]) -> (Integer, BingoCard)
lastWinningCard = lastWinningCard' Nothing

lastWinningCard' :: Maybe (Integer, BingoCard) -> ([Integer], [BingoCard]) -> (Integer, BingoCard)
lastWinningCard' Nothing ([], _) = error "No winners found or multiple last winners"
lastWinningCard' (Just winner) ([], _) = winner
lastWinningCard' lastWinner (n : ns, cards) =
  let cards' = playTurn n cards
      winners = findVictors cards'
      losers = findLosers cards'
   in case winners of
        [] -> lastWinningCard' lastWinner (ns, losers)
        [x] -> lastWinningCard' (Just (n, x)) (ns, losers)
        _ -> lastWinningCard' Nothing (ns, losers)

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
