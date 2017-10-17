module NLP.Julius.Interface where

import Foreign
import Foreign.C.Types

foreign import ccall unsafe "c_init_julius"
               c_init_julius :: IO (Ptr RecogMain)

data RecogMain = RecogMain
