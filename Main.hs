module Main where

import NLP.Julius.Interface
import Data.ByteString as BS
import Text.Pretty.Simple
-- Compile command

-- export JULIUS_ROOT=/nix/store/k8a7m7a90c9qq39k1zz4z5j2ylh33pri-julius-4.4.2.1
-- ghc src/NLP/Julius/Interface
-- cp src/NLP/Julius/Interface_stub.h csrc/
-- ghc Main.hs  -isrc/ csrc/julius_interface.c ${JULIUS_ROOT}/lib/libjulius.a ${JULIUS_ROOT}/lib/libsent.a

-- export JULIUS_ROOT=/home/divam/repos/julius-asr/julius
--  ghc Main.hs  -isrc/ csrc/julius_interface.c ${JULIUS_ROOT}/libjulius/libjulius.a ${JULIUS_ROOT}/libsent/libsent.a -I${JULIUS_ROOT}/libjulius/include -I${JULIUS_ROOT}/libsent/include


main = do
  print "Hello"
  v <- c_init_julius
  bs <- BS.readFile "meldata.raw"
  confData <- computeConfusionDataFromMelData v bs
  pPrint confData
  return()
