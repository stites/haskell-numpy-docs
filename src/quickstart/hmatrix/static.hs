module Hmatrix.Static where

import Numeric.LinearAlgebra.Static

-- $setup
-- >>> :set -XDataKinds
-- >>> import Numeric.LinearAlgebra.Static
-- >>> import Foreign.Storable (sizeOf)
-- >>> import Numeric.LinearAlgebra ((!), (><))
-- >>> import GHC.TypeLits (KnownNat)
-- >>> import Data.Maybe (fromJust)
-- >>> import qualified Numeric.LinearAlgebra as LA

-- | 78-100
-- >>> let a = matrix [0..3*5-1] :: L 3 5 -- or @build (+) :: L 3 5@
-- >>> a  -- for vectors that are just indices, using @range 15@ is fine
-- (matrix
--  [  0.0,  1.0,  2.0,  3.0,  4.0
--  ,  5.0,  6.0,  7.0,  8.0,  9.0
--  , 10.0, 11.0, 12.0, 13.0, 14.0 ] :: L 3 5)
-- >>> size a
-- (3,5)

-- -- there is no @ndim@ for hmatrix, since there are only scalar, vectors, and (2D) matrices
-- | 78-100
-- >>> let a = build (\x y -> x + y) :: L 3 5
-- >>> :t (extract a ! 0 ! 0)
-- (extract a ! 0 ! 0) :: Double
-- >>> sizeOf (extract a ! 0 ! 0)
-- 8
-- >>> LA.size (LA.flatten (extract a))
-- 15
-- >>> :t a
-- a :: L 3 5
-- >>> :t extract a
-- extract a :: LA.Matrix ℝ
-- >>> :t unwrap a
-- unwrap a :: LA.Matrix ℝ

-- | 114-122
-- >>> let a = vec3 2 3 4
-- >>> unwrap a
-- [2.0,3.0,4.0]
-- >>> :t a
-- a :: R 3
-- >>> :t unwrap a
-- unwrap a :: LA.Vector ℝ
-- >>> let b = fromList [1.2,3.5,5.1] :: R 3
-- >>> :t b
-- b :: R 3

-- -- If you do not cast the numerical literal, you don't get a fully-resolved-type vector
-- | 139-142
-- >>> let b = withRows [vector [1.5, 2, 3], vector [4,5,6]] (exactDims::KnownNat m => L m 3 -> Maybe (L 2 3)) :: Maybe (L 2 3)
-- >>> b
-- Just (matrix
--  [ 1.5, 2.0, 3.0
--  , 4.0, 5.0, 6.0 ] :: L 2 3)
--

-- -- withRows (and withColumns) doesn't exist for complex functions
-- | 148-151
-- >>> let c = (fromList [1,2, 3,4] :: M 2 2)
-- >>> c
-- (matrix
--  [ 1.0 :+ 0.0, 2.0 :+ 0.0
--  , 3.0 :+ 0.0, 4.0 :+ 0.0 ] :: M 2 2)

-- | 166-179
-- >>> konst 0 :: L 3 4
-- (0.0 :: L 3 4)
-- >>> extract (konst 0 :: L 3 4)
-- (3><4)
--  [ 0.0, 0.0, 0.0, 0.0
--  , 0.0, 0.0, 0.0, 0.0
--  , 0.0, 0.0, 0.0, 0.0 ]

-- -- or
-- | 166-179
-- >>> withMatrix (((3><4) . repeat) 0) (exactDims :: (KnownNat m, KnownNat n) => L m n -> Maybe (L 3 4)) :: Maybe (L 3 4)
-- Just (matrix
--  [ 0.0, 0.0, 0.0, 0.0
--  , 0.0, 0.0, 0.0, 0.0
--  , 0.0, 0.0, 0.0, 0.0 ] :: L 3 4)

-- -- there are no 3D tensors in hmatrix
-- -- there are no "empty" matrices in hmatrix

-- | 186-189
-- >>> vector (init [10, 15.. 30]) :: R 4
-- (vector.0,20.0,25.0] :: R 4)
-- >>> vector (init [0, 0.3.. 2]) :: R 7
-- (vector,0.6,0.8999999999999999,1.1999999999999997,1.4999999999999996,1.7999999999999994] :: R 7)

-- | 197-201
-- >>> linspace (0, 2) :: R 9
-- (vector5,0.5,0.75,1.0,1.25,1.5,1.75,2.0] :: R 9)
-- >>> unwrap (linspace (0, 2) :: R 9)
-- [0.0,0.25,0.5,0.75,1.0,1.25,1.5,1.75,2.0]
-- >>> let x = linspace (0, 2*pi) :: R 100
-- >>> let f = dvmap sin x

-- | 234-252
-- >>> let a = range :: R 6
-- >>> disp 2 a
-- R 6
-- 1  2  3  4  5  6
-- >>> let b = matrix [0..4*3-1] :: L 4 3
-- >>> disp 2 b
-- L 4 3
-- 0   1   2
-- 3   4   5
-- 6   7   8
-- 9  10  11

-- -- there are no 3D matrices in hmatrix
-- PENDING 260-270
-- >>> dispShort 6 6 0 (asRow (10000 |> [0..]))
-- 1x10000
-- 0  1  2  .. 9998  9999
-- >>> dispShort 6 6 0 ((100><100) [0..])
-- 100x100
--    0     1     2  ..   98    99
--  100   101   102  ..  198   199
--  200   201   202  ..  298   299
--                   ::
-- 9800  9801  9802  .. 9898  9899
-- 9900  9901  9902  .. 9998  9999

-- | 288-300
-- >>> let a = vector [20,30,40,50] :: R 4
-- >>> let b = vec4 0 1 2 3
-- >>> unwrap b
-- [0.0,1.0,2.0,3.0]
-- >>> let c = a - b
-- >>> unwrap c
-- [20.0,29.0,38.0,47.0]
-- >>> unwrap $ dvmap (^ 2) b
-- [0.0,1.0,4.0,9.0]
-- >>> disp 8 (row (dvmap ((*10) . sin) a))
-- L 1 4
-- 9.12945251  -9.88031624  7.45113160  -2.62374854
-- >>> (LA.fromList . (fmap (<35)) . LA.toList . extract) a -- hmatrix does not have an Element Bool definition
-- [True,True,False,False]

-- | 306-318
-- >>> let asSq2 = fromJust . exactDims :: KnownNat m => L m 2 -> Sq 2
-- >>> let a = withRows [vector [1,1], vector [0,1]] asSq2
-- >>> let b = withRows [vector [2,0], vector [3,4]] asSq2
-- >>> a * b   -- capitals are reserved for data constructors
-- (matrix
--  [ 2.0, 0.0
--  , 0.0, 4.0 ] :: L 2 2)
-- >>> a <> b
-- (matrix
--  [ 5.0, 4.0
--  , 3.0, 4.0 ] :: L 2 2)
-- >>> mul a b -- dot is reserved for vector <.> vector
-- (matrix
--  [ 5.0, 4.0
--  , 3.0, 4.0 ] :: L 2 2)

-- PENDING 325-338
-- >>> import Numeric.LinearAlgebra.HMatrix (Seed, RandDist(..), randomVector, rand)
-- >>> let a' = ((2><3) . repeat) 1     -- inplace mutation not useful here
-- >>> let rand' seed r c = reshape c (randomVector seed Uniform (r*c))
-- >>> let b' = rand' 1 2 3             -- or unseeded: rand 2 3; rand' not actually deterministic (?)
-- >>> let a = cmap (*3) a' :: Matrix Z -- haskell cannot reassign variables using itself
-- >>> a
-- (2><3)
--  [ 3, 3, 3
--  , 3, 3, 3 ]
-- >>> let b = (+ (fromZ a)) b'         -- need to cast away from integer (Z)
-- >>> disp 7 b                         -- unseeded would need fmap due to being IO (...)
-- ...

-- 2x3
--  3.4583777  3.1595528  3.4802844
--  3.6986673  3.8688027  3.5846251

-- PENDING 346-360
-- >>> :set -XFlexibleContexts
-- >>> let a = konst 1 3                -- type not resolved here
-- >>> let b = linspace 3 (0, pi)       -- set FlexibleContexts to get type inference
-- >>> :t b
-- b :: (Container Vector e, Floating e) => Vector e
-- >>> let c = a + b :: Vector R        -- we can force resolving type of only c
-- >>> disp 8 (asRow (c :: Vector R)) -- a and b will remain unresolved
-- 1x3
-- 1.00000000  2.57079633  4.14159265
-- >>> :t c
-- c :: Vector R
-- >>> let d = cmap (exp . (*iC)) (complex c)
-- >>> putStrLn (dispcf 8 (asRow d))
-- 1x3
-- 0.54030231+0.84147098i  -0.84147098+0.54030231i  -0.54030231-0.84147098i
-- <BLANKLINE>
-- >>> :t d
-- d :: Vector C

-- >>> let a = rand' 1 2 3
-- PENDING 367-376
-- >>> let rand' seed r c = reshape c (randomVector seed Uniform (r*c))
-- >>> let a = fromLists [[0.18626021, 0.34556073, 0.39676747], [0.53881673, 0.41919451, 0.6852195]] :: Matrix R
-- >>> a
-- (2><3)
--  [ 0.18626021, 0.34556073, 0.39676747
--  , 0.53881673, 0.41919451,  0.6852195 ]
-- >>> sumElements a :: R
-- 2.57181915
-- >>> minElement a :: R
-- 0.18626021
-- >>> maxElement a :: R
-- 0.6852195

-- PENDING 383-398
-- >>> let b = (3><4) [0::I ..]
-- >>> b
-- (3><4)
--  [ 0, 1,  2,  3
--  , 4, 5,  6,  7
--  , 8, 9, 10, 11 ]
--  >>> (fromList . fmap sumElements . toColumns) b
--  [12,15,18,21]
--  >>> (fromList . fmap minElement . toRows) b
--  [0,4,8]
--  >>> (fromLists . (fmap (scanl1 (+))) . toLists) b
--  (3><4)
--   [ 0,  1,  3,  6
--   , 4,  9, 15, 22
--   , 8, 17, 27, 38 ]

-- PENDING 411-420
-- >>> let b = 3 |> [0::R ..] -- if we used @I@, we'd need @fromInt b@ below
-- >>> b
-- [0.0,1.0,2.0]
-- >>> cmap exp b
-- [1.0,2.718281828459045,7.38905609893065]
-- >>> cmap sqrt b
-- [0.0,1.0,1.4142135623730951]
-- >>> let c = vector [2, -1, 4]
-- >>> b + c
-- [2.0,0.0,6.0]

-- PENDING 477-501
-- >>> let a = build 10 (^3) :: Vector I -- helper function with implicit counter
-- >>> a
-- [0,1,8,27,64,125,216,343,512,729]
-- >>> a ! 2 -- also can do @a `atIndex` 2@
-- 8
-- >>> subVector 2 (5-2) a
-- [8,27,64]

-- -- that uses @Data.Vector.slice@ underneath, without copying
-- -- we could convert to a matrix for nice indexing
-- -- using @(flatten . ((flip (??)) (All, Range 2 1 4)) . asRow) a@
-- -- we could also do @(flatten . remap (asColumn (scalar 0)) (asRow (fromList [2..4])) . asRow) b@
-- -- or even @fromList ((sequence . fmap (flip (!))) [2..4] b)@
-- PENDING 477-501
-- >>> let a = build 10 (^3) :: Vector I -- helper function with implicit counter
-- >>> let a' = accum a const (zip [0,2..4] (repeat (negate 1000)))
-- >>> a'
-- [-1000,1,-1000,27,-1000,125,216,343,512,729]
-- >>> import qualified Data.Vector.Storable as V
-- >>> V.reverse a' -- unlike in Python, this is not a view, and is O(n)
-- [729,512,343,216,125,-1000,27,-1000,1,-1000]
-- >>> import Numeric.LinearAlgebra.Devel (mapVectorM_)
-- >>> mapVectorM_ print (cmap (**(1/3.0)) (fromInt a') :: Vector R)
-- NaN
-- 1.0
-- NaN
-- 3.0
-- NaN
-- 4.999999999999999
-- 6.0
-- 6.999999999999998
-- 8.0
-- 8.999999999999998

-- PENDING 506-524,531-532
-- >>> let f x y = 10*x+y
-- >>> let b = build (5,4) f :: Matrix Z
-- >>> b
-- (5><4)
--  [  0,  1,  2,  3
--  , 10, 11, 12, 13
--  , 20, 21, 22, 23
--  , 30, 31, 32, 33
--  , 40, 41, 42, 43 ]
-- >>> b ! 2 ! 3
-- 23
-- >>> flatten (subMatrix (0,1) (5,1) b) -- @subMatrix@ always return a Matrix
-- [1,11,21,31,41]
-- >>> flatten (b ?? (All, Pos (scalar 1)))
-- [1,11,21,31,41]
-- >>> b ?? (Range 1 1 2, All)
-- (2><4)
--  [ 10, 11, 12, 13
--  , 20, 21, 22, 23 ]
-- >>> flatten (b ? [rows b - 1])
-- [40,41,42,43]

-- -- hmatrix does not have 3D matrices; there are no ellipsis equivalents
-- PENDING 565-572,579-601
-- >>> let f x y = 10*x+y
-- >>> let b = build (5,4) f :: Matrix Z
-- >>> mapM_ print (toRows b)
-- [0,1,2,3]
-- [10,11,12,13]
-- [20,21,22,23]
-- [30,31,32,33]
-- [40,41,42,43]
-- >>> import Numeric.LinearAlgebra.Devel (mapMatrixWithIndexM_)
-- >>> mapMatrixWithIndexM_ (const print) b
-- 0
-- 1
-- 2
-- 3
-- 10
-- 11
-- 12
-- 13
-- 20
-- 21
-- 22
-- 23
-- 30
-- 31
-- 32
-- 33
-- 40
-- 41
-- 42
-- 43

-- PENDING 621-627,633-650
-- >>> import Numeric.LinearAlgebra.HMatrix (Seed, RandDist(..), randomVector, rand)
-- >>> let rand' seed r c = reshape c (randomVector seed Uniform (r*c))
-- >>> let a = cmap (floor . (*10)) (rand' 1 3 4) :: Matrix Z

-- PENDING 621-627,633-650
-- >>> let a = fromLists [[2,8,0,6],[4,5,1,1],[8,9,3,6]] :: Matrix Z
-- >>> a
-- (3><4)
--  [ 2, 8, 0, 6
--  , 4, 5, 1, 1
--  , 8, 9, 3, 6 ]
-- >>> size a
-- (3,4)
-- >>> flatten a
-- [2,8,0,6,4,5,1,1,8,9,3,6]
-- >>> ((reshape 2) . flatten) a
-- (6><2)
--  [ 2, 8
--  , 0, 6
--  , 4, 5
--  , 1, 1
--  , 8, 9
--  , 3, 6 ]
-- >>> tr a
-- (4><3)
--  [ 2, 4, 8
--  , 8, 5, 9
--  , 0, 1, 3
--  , 6, 1, 6 ]
-- >>> size (tr a)
-- (4,3)
-- >>> size a
-- (3,4)

-- PENDING 668-675,680-683
-- >>> let a = fromLists [[2,8,0,6],[4,5,1,1],[8,9,3,6]] :: Matrix Z
-- >>> a
-- (3><4)
--  [ 2, 8, 0, 6
--  , 4, 5, 1, 1
--  , 8, 9, 3, 6 ]
-- >>> let a' = ((reshape 6) . flatten) a
-- >>> a'
-- (2><6)
--  [ 2, 8, 0, 6, 4, 5
--  , 1, 1, 8, 9, 3, 6 ]
-- >>> (tr . (reshape 3) . flatten . tr) a
-- (3><4)
--  [ 2, 8, 0, 6
--  , 4, 5, 1, 1
--  , 8, 9, 3, 6 ]

-- PENDING 697-712
-- >>> import Numeric.LinearAlgebra.HMatrix (Seed, RandDist(..), randomVector, rand)
-- >>> let rand' seed r c = reshape c (randomVector seed Uniform (r*c))
-- >>> let a = cmap (floor . (*10)) (rand' 1 2 2) :: Matrix Z
-- >>> let b = cmap (floor . (*10)) (rand' 2 2 2) :: Matrix Z

-- PENDING 697-712
-- >>> let a = fromLists [[8,8],[0,0]] :: Matrix Z
-- >>> a
-- (2><2)
--  [ 8, 8
--  , 0, 0 ]
-- >>> let b = fromLists [[1,8],[0,4]] :: Matrix Z
-- >>> b
-- (2><2)
--  [ 1, 8
--  , 0, 4 ]
-- >>> a === b
-- (4><2)
--  [ 8, 8
--  , 0, 0
--  , 1, 8
--  , 0, 4 ]
-- >>> a ||| b
-- (2><4)
--  [ 8, 8, 1, 8
--  , 0, 0, 0, 4 ]

-- PENDING 718-737
-- >>> let a = fromLists [[8,8],[0,0]] :: Matrix Z
-- >>> let b = fromLists [[1,8],[0,4]] :: Matrix Z
-- >>> a ||| b
-- (2><4)
--  [ 8, 8, 1, 8
--  , 0, 0, 0, 4 ]

-- PENDING 718-737,755-756
-- >>> let a = fromList [4,2] :: Vector Z
-- >>> let b = fromList [3,8] :: Vector Z
-- >>> fromColumns [a,b]
-- (2><2)
--  [ 4, 3
--  , 2, 8 ]
-- >>> vjoin [a,b]
-- [4,2,3,8]
-- >>> asColumn a
-- (2><1)
--  [ 4
--  , 2 ]
-- >>> fromBlocks [fmap asColumn [a,b]]
-- (2><2)
--  [ 4, 3
--  , 2, 8 ]
-- >>> fromList ([1..3] ++ [0] ++ [4]) :: Vector Z
-- [1,2,3,0,4]

-- PENDING 783-796
-- >>> import Numeric.LinearAlgebra.HMatrix (Seed, RandDist(..), randomVector, rand)
-- >>> let rand' seed r c = reshape c (randomVector seed Uniform (r*c))
-- >>> let a = cmap (floor . (*10)) (rand' 1 2 12) :: Matrix Z

-- PENDING 783-796
-- >>> let a = fromLists [[9,5,6,3,6,8,0,7,9,7,2,7],[1,4,9,2,2,1,0,6,2,2,4,0]] :: Matrix Z
-- >>> a
-- (2><12)
--  [ 9, 5, 6, 3, 6, 8, 0, 7, 9, 7, 2, 7
--  , 1, 4, 9, 2, 2, 1, 0, 6, 2, 2, 4, 0 ]
-- >>> toBlocksEvery 2 4 a -- we could do @toBlocksEvery (rows a) ((floor . (/3) . fromIntegral . cols) a) a@
-- [[(2><4)
--  [ 9, 5, 6, 3
--  , 1, 4, 9, 2 ],(2><4)
--  [ 6, 8, 0, 7
--  , 2, 1, 0, 6 ],(2><4)
--  [ 9, 7, 2, 7
--  , 2, 2, 4, 0 ]]]
-- >>> toBlocks [2] [3, 4-3, cols a - 4] a
-- [[(2><3)
--  [ 9, 5, 6
--  , 1, 4, 9 ],(2><1)
--  [ 3
--  , 2 ],(2><8)
--  [ 6, 8, 0, 7, 9, 7, 2, 7
--  , 2, 1, 0, 6, 2, 2, 4, 0 ]]]

-- PENDING 1017-1025
-- >>> let a = build 12 (^2) :: Vector Z
-- >>> let i = fromList [1,1,3,8,5] :: Vector I
-- >>> flatten ((asRow a) ?? (All, Pos i))
-- [1,1,9,64,25]
-- >>> let j = fromLists [[3,4],[9,7]] :: Matrix I
-- >>> remap (asRow (scalar 0)) (j) ((fromRows . replicate (rows j)) a)
-- (2><2)
--  [  9, 16
--  , 81, 49 ]

-- PENDING 1034-1049
-- >>> let palette = fromLists [[0,0,0],[255,0,0],[0,255,0],[0,0,255],[255,255,255]] :: Matrix I
-- >>> let image = fromLists [[0,1,2,0],[0,3,4,0]] :: Matrix I
-- >>> fmap (\img -> palette ?? (Pos img, All)) (toRows image) -- almost 3D, [Matrix Z] instead
-- [(4><3)
--  [   0,   0, 0
--  , 255,   0, 0
--  ,   0, 255, 0
--  ,   0,   0, 0 ],(4><3)
--  [   0,   0,   0
--  ,   0,   0, 255
--  , 255, 255, 255
--  ,   0,   0,   0 ]]

-- PENDING 1056-1080
-- >>> let a = (3><4) [0::Z ..]
-- >>> let i = fromLists [[0,1],[1,2]] :: Matrix I
-- >>> let j = fromLists [[2,1],[3,3]] :: Matrix I
-- >>> remap i j a
-- (2><2)
--  [ 2,  5
--  , 7, 11 ]
-- >>> remap i (asColumn (scalar 2)) a
-- (2><2)
--  [ 2,  6
--  , 6, 10 ]
-- >>> fmap (\r -> remap (asRow (scalar r)) j a) (toList ((rows a) |> [0..])) -- emulating 3D
-- [(2><2)
--  [ 2, 1
--  , 3, 3 ],(2><2)
--  [ 6, 5
--  , 7, 7 ],(2><2)
--  [ 10,  9
--  , 11, 11 ]]

-- PENDING 1111-1136
-- >>> let time = linspace 5 (20.0, 145.0) :: Vector R
-- >>> let ydata = cmap sin ((5><4) [0..]) :: Matrix R -- data is a protected word
-- >>> time
-- [20.0,51.25,82.5,113.75,145.0]
-- >>> ydata
-- (5><4)
--  [                 0.0,  0.8414709848078965,   0.9092974268256817,  0.1411200080598672
--  , -0.7568024953079282, -0.9589242746631385, -0.27941549819892586,  0.6569865987187891
--  ,  0.9893582466233818,  0.4121184852417566,  -0.5440211108893698, -0.9999902065507035
--  , -0.5365729180004349,  0.4201670368266409,   0.9906073556948704,  0.6502878401571168
--  , -0.2879033166650653, -0.9613974918795568,   -0.750987246771676, 0.14987720966295234 ]
-- >>> let ind = fmap maxIndex (toColumns ydata)
-- >>> ind
-- [2,0,3,1]
-- >>> let time_max = flatten ((asRow time) ?? (All, Pos (idxs ind)))
-- >>> let ydata_max = takeDiag (ydata ?? (Pos (idxs ind), All))
-- >>> time_max
-- [82.5,20.0,113.75,51.25]
-- >>> ydata_max
-- [0.9893582466233818,0.8414709848078965,0.9906073556948704,0.6569865987187891]
-- >>> (toList ydata_max) == (fmap maxElement (toColumns ydata))
-- True

-- PENDING 1140-1145,1150-1153,1158-1161
-- >>> let a = 5 |> [0..] :: Vector Z
-- >>> a
-- [0,1,2,3,4]
-- >>> let a' = accum a const (zip [1,3,4] (repeat 0))
-- >>> a'
-- [0,0,2,0,0]
-- >>> let a' = accum a const (zip [1,2,3] [0,0,2])
-- >>> a'
-- [0,0,0,2,4]
-- >>> let a' = accum a (+) (zip [0,0,2] (repeat 1))
-- >>> a' -- this DOES work, since we hit the 0 index twice mutably
-- [2,1,3,3,4]

-- PENDING 1178-1185,1189-1193
-- >>> let a = (3><4) [0..] :: Matrix Z
-- >>> let b = (fmap (fmap (>4))) (toLists a) -- gives a [[Bool]], which is not that useful
-- >>> let b = find (>4) a                    -- better than just Matrix Bool, which does not work in hmatrix
-- >>> b                                      -- a [IndexOf c] is more idiomatic
-- [(1,1),(1,2),(1,3),(2,0),(2,1),(2,2),(2,3)]
-- >>> fromList (fmap (atIndex a) b)
-- [5,6,7,8,9,10,11]
-- >>> accum a const (zip b (repeat 0))
-- (3><4)
--  [ 0, 1, 2, 3
--  , 4, 0, 0, 0
--  , 0, 0, 0, 0 ]

-- PENDING 1226-1244
-- >>> let a = (3><4) [0..] :: Matrix Z
-- >>> let b1' = [False,True,True]
-- >>> let b2' = [True,False,True,False]
-- >>> import Data.List (elemIndices)
-- >>> let helper = elemIndices True
-- >>> let b1 = helper b1'
-- >>> let b2 = helper b2'
-- >>> a ?? (Pos (idxs b1), All)
-- (2><4)
--  [ 4, 5,  6,  7
--  , 8, 9, 10, 11 ]
-- >>> a ? b1
-- (2><4)
--  [ 4, 5,  6,  7
--  , 8, 9, 10, 11 ]
-- >>> a ?? (All, Pos (idxs b2))
-- (3><2)
--  [ 0,  2
--  , 4,  6
--  , 8, 10 ]
-- >>> a ?? (Pos (idxs b1), Pos (idxs b2))       -- unlike numpy, will return matrix that matches any combination from selections
-- (2><2)
--  [ 4,  6
--  , 8, 10 ]
-- >>> (fromList . fmap (atIndex a)) (zip b1 b2) -- this will give you the numpy result, the zipped indexing of a matrix to give a vector
-- [4,10]

-- PENDING 1344-1378
-- >>> let a = fromLists [[1.0, 2.0],[3.0,4.0]] :: Matrix R
-- >>> disp 2 a
-- 2x2
-- 1  2
-- 3  4
--
-- >>> tr a
-- (2><2)
--  [ 1.0, 3.0
--  , 2.0, 4.0 ]
--
-- >>> disp 2 (inv a)
-- 2x2
-- -2.00   1.00
--  1.50  -0.50
--
-- >>> let u = ident 2 :: Matrix R
-- >>> u
-- (2><2)
--  [ 1.0, 0.0
--  , 0.0, 1.0 ]
-- >>> let j = fromLists [[0.0,-1.0],[1.0,0.0]] :: Matrix R
--
-- >>> j <> j
-- (2><2)
--  [ -1.0,  0.0
--  ,  0.0, -1.0 ]
--
-- >>> sumElements (takeDiag u)
-- 2.0
--
-- >>> let y = vector [5,7]
-- >>> disp 2 (asColumn (a <\> y))
-- 2x1
-- -3.00
--  4.00
--
-- >>> eig j
-- ([0.0 :+ 1.0,0.0 :+ (-1.0)],(2><2)
--  [    0.7071067811865475 :+ 0.0, 0.7071067811865475 :+ (-0.0)
--  , 0.0 :+ (-0.7071067811865475),    0.0 :+ 0.7071067811865475 ])

-- PENDING 1401-1415
-- >>> let a = 30 |> [0..] :: Vector Z
-- >>> toBlocksEvery 5 3 (reshape 3 a) -- emulate depth with lists
-- [[(5><3)
--  [  0,  1,  2
--  ,  3,  4,  5
--  ,  6,  7,  8
--  ,  9, 10, 11
--  , 12, 13, 14 ]],[(5><3)
--  [ 15, 16, 17
--  , 18, 19, 20
--  , 21, 22, 23
--  , 24, 25, 26
--  , 27, 28, 29 ]]]

-- PENDING 1427-1431
-- >>> let x = fromList [0,2..10-2] :: Vector Z
-- >>> x
-- [0,2,4,6,8]
-- >>> let y = 5 |> [0..] :: Vector Z
-- >>> y
-- [0,1,2,3,4]
-- >>> let m = fromRows [x,y]
-- >>> m
-- (2><5)
--  [ 0, 2, 4, 6, 8
--  , 0, 1, 2, 3, 4 ]
-- >>> let xy = vjoin [x,y]
-- >>> xy
-- [0,2,4,6,8,0,1,2,3,4]

-- PENDING 1452-1463
-- >>> let (mu, sigma) = (2, 0.5)
-- >>> (mu, sigma)
-- (2,0.5)
-- >>> import Numeric.LinearAlgebra.Static (Seed, RandDist(..), gaussianSample, rand)
-- >>> let rand' seed mu sigma c = konst mu + konst sigma * (randomVector seed Gaussian :: R 10000)
-- >>> let v = rand' 1 mu sigma 10000
-- >>> :{
-- normedhist :: R 10000 -> Int -> R 10000
-- normedhist vec numbins = accum bins (+) (fmap go (toList vec))
--                          where
--                            bins :: R _
--                            bins = konst 0 numbins
--                            lo = maxElement vec
--                            hi = minElement vec
--                            delt = (hi-lo) / fromIntegral numbins
--                            valscale val = min (numbins-1) (floor ((val-lo) / delt))
--                            go val = (valscale val, 1 / fromIntegral (size vec))
-- :}
--
-- >>> let hist = normedhist v 50
-- >>> disp 2 (scalar (sumElements hist))
-- 1x1
-- 1.00
-- >>> let bins = linspace 50 (minElement v, maxElement v)

