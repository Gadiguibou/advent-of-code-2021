module Main where

import qualified MyLib (part1, part2)

main :: IO ()
main = interact (\x -> "Part 1: " ++ MyLib.part1 x ++ "\n" ++ "Part 2: " ++ MyLib.part2 x ++ "\n")
