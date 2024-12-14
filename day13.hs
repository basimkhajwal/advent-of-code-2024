import Data.List.Split (chunksOf)
import Data.Maybe (mapMaybe)
import System.IO (readFile)
import Text.Regex.TDFA ((=~))

type Pos = (Int, Int)
type Case = (Pos, Pos, Pos)

extract :: String -> Maybe Pos
extract line =
  case line =~ "X[+=]([0-9]+), Y[+=]([0-9]+)" of
    [[_, x, y]] -> Just (read x, read y) 
    _           -> Nothing

readInput :: String -> IO [Case]
readInput file = fmap (toTriples . parse) (readFile file)
  where parse = mapMaybe extract . lines
        toTriples = map (\[a, b, c] -> (a, b, c)) . chunksOf 3 

maybeInt :: Double -> Maybe Int
maybeInt x =
  if abs (x - fromIntegral (floor x)) < 1e-5 
  then Just (floor x) 
  else Nothing

solveCase :: Case -> Maybe Int
solveCase ((ax, ay), (bx, by), (x, y)) = do
  let det = fromIntegral (ax * by - bx * ay) 
  i <- maybeInt $ fromIntegral (by * x - bx * y) / det 
  j <- maybeInt $ fromIntegral (ax * y - ay * x) / det 
  return (3*i+j)

solve :: [Case] -> Int
solve = sum . mapMaybe solveCase

partTwo :: Case -> Case
partTwo (a, b, (x, y)) = (a, b, (x+n, y+n))
  where n = 10000000000000

main :: IO ()
main = do
  cases <- readInput "input/input13.txt"
  print $ solve cases
  print $ solve $ map partTwo cases
