module NLP.Julius.Interface where

import Foreign
import Foreign.C.Types
import Foreign.C.String
import Data.List.NonEmpty (NonEmpty)
import qualified Data.List.NonEmpty as NE
import Data.ByteString (ByteString, useAsCStringLen)
import Data.Vector (Vector)
import Control.Monad (join)
import qualified Data.Vector as V
import Data.IORef

foreign import ccall unsafe "c_init_julius"
               c_init_julius :: IO (Ptr RecogMain)

foreign import ccall unsafe "j_recognize_stream_simplified"
  j_recognize_stream_simplified
  :: Ptr RecogMain
  -> CString
  -> CInt
  -> IO (CInt)

foreign import ccall unsafe "j_clean_recog_work_area"
  j_clean_recog_work_area
  :: Ptr RecogMain
  -> IO ()

foreign import ccall safe "c_get_result_confnet"
  c_get_result_confnet
  :: Ptr RecogMain
  -> StablePtr (IORef ConfusionData)
  -> IO ()

data RecogMain = RecogMain

type ConfusionData = Vector (NonEmpty (Float, String))

foreign export ccall hsAddConfNetData
  :: StablePtr (IORef ConfusionData)
  -> CInt
  -> CString
  -> CFloat
  -> IO ()

computeConfusionDataFromMelData
  :: Ptr RecogMain
  -> ByteString
  -> IO (ConfusionData)
computeConfusionDataFromMelData r bs = do
  let
    frameNum l = floor ((fromIntegral l)/(4*40))
    -- FrameNum * 10ms * 16Khz
    getSpeechLen l = 16* (10*(frameNum l - 1))
  useAsCStringLen bs
    (\(cstr, len) -> j_recognize_stream_simplified r cstr
      (getSpeechLen len))
  confDataPtr <- join $ newStablePtr <$> newIORef V.empty
  c_get_result_confnet r confDataPtr
  j_clean_recog_work_area r
  val <- join (readIORef <$> deRefStablePtr confDataPtr)
  freeStablePtr confDataPtr
  return val

hsAddConfNetData
  :: StablePtr (IORef ConfusionData)
  -> CInt
  -> CString
  -> CFloat
  -> IO ()
hsAddConfNetData ptr (CInt crow) cstr (CFloat float) = do
  vecRef <- deRefStablePtr ptr
  vec <- readIORef vecRef
  str <- peekCString cstr
  let newRow = ((NE.:|) val [])
      oldRow = (V.!?) vec row
      row = fromIntegral crow
      val = (float, str)
      newVec = maybe (V.cons newRow vec)
        (\ne -> (V.//) vec [(row, NE.cons val ne)]) oldRow
  writeIORef vecRef newVec
