module Main where

import NLP.Julius.Interface

-- Compile command
-- ghc Main.hs  -isrc/ csrc/julius_interface.c /nix/store/fxvmbayz2wxh1f9xkzxvnyw45lk1c0x5-julius-4.4.2.1/lib/libjulius.a /nix/store/fxvmbayz2wxh1f9xkzxvnyw45lk1c0x5-julius-4.4.2.1/lib/libsent.a

main = do
  print "Hello"
  v <- c_init_julius
  return()
