module Main where

import Graphics.Rendering.OpenGL as GL
import Graphics.UI.GLUT
import Foreign.Storable
import Data.Array.Storable
import Data.Array.MArray

--
-- I wrote this example because OpenGL ES needs to use vertex arrays.
--
--

main :: IO ()
main = do
  getArgsAndInitialize
  w <- createWindow "Vertex Array Test"
  clientState VertexArray $= Enabled -- this must be enabled for vertex arrays to work!
  clearColor $= Color4 0 0 0 0
  currentColor $= Color4 1 1 1 1
  windowSize $= Size 800 800
  setupArray
  displayCallback $= display w
  mainLoop


mkVertices :: (GLfloat, GLfloat) -> [GLfloat]
mkVertices (x,y) = [ -0.25 + x, -0.25 +y , 0.25 + x, -0.25 + y,
                    0.25+x, 0.25+y, -0.25+x, 0.25+y]

vertices = mkVertices (-0.5, 0.5) ++ mkVertices (0.5, -0.5)


setupArray :: IO ()
setupArray = do
  a <- newListArray (0,length vertices-1) vertices
  withStorableArray (a ::StorableArray Int GLfloat) $ \ptr -> do
    arrayPointer VertexArray $= VertexArrayDescriptor 
                                  2
                                  Float
                                  0 -- 0 = stride automatically computed by OpenGL
                                  ptr

display :: Window -> IO ()
display w = do
  clear [ColorBuffer, DepthBuffer]


  drawArrays LineLoop 0 4 -- draw first four vertices
  drawArrays Polygon 4 4  -- draw second four vertices
  flush
  return ()