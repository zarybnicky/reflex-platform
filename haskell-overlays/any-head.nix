{ haskellLib, fetchFromGitHub }:

self: super: let
  universeSrc = fetchFromGitHub {
    owner = "dmwit";
    repo = "universe";
    rev = "c5c7433ddf34d6997cfa0f9859b7fa6c846d063a";
    sha256 = "1m2s34lads8i1y71lx7mfvbnna1490bscgqx2nqmfjgw462mgfrg";
  };
in {
  th-expand-syns = haskellLib.doJailbreak super.th-expand-syns;
  ChasingBottoms = haskellLib.doJailbreak super.ChasingBottoms;
  base-orphans = haskellLib.dontCheck super.base-orphans;
  bifunctors = haskellLib.doJailbreak (haskellLib.dontCheck super.bifunctors);
  HTTP = haskellLib.doJailbreak super.HTTP;
  newtype-generics = haskellLib.doJailbreak super.newtype-generics;
  split = haskellLib.doJailbreak super.split;
  StateVar = haskellLib.doJailbreak super.StateVar;
  ref-tf = haskellLib.doJailbreak super.ref-tf;
  parallel = haskellLib.doJailbreak super.parallel;
  cabal-doctest = haskellLib.doJailbreak super.cabal-doctest;
  vector = haskellLib.doJailbreak super.vector;
  pointed = haskellLib.doJailbreak super.pointed;
  exception-transformers = haskellLib.doJailbreak super.exception-transformers;
  async = haskellLib.doJailbreak super.async;
  th-abstraction = haskellLib.doJailbreak super.th-abstraction;
  th-lift = haskellLib.doJailbreak super.th-lift;
  integer-logarithms = haskellLib.doJailbreak super.integer-logarithms;
  vault = haskellLib.doJailbreak super.vault;
  unliftio-core = haskellLib.doJailbreak super.unliftio-core;
  unix-compat = haskellLib.doJailbreak super.unix-compat;
  bsb-http-chunked = haskellLib.doJailbreak super.bsb-http-chunked;
  lens = haskellLib.doJailbreak super.lens;
  jsaddle = haskellLib.doJailbreak super.jsaddle;
  exceptions = haskellLib.doJailbreak super.exceptions;
  keycode = haskellLib.doJailbreak super.keycode;
  template-haskell-ghcjs = haskellLib.doJailbreak super.template-haskell-ghcjs;
  haddock-library-ghcjs = haskellLib.doJailbreak super.haddock-library-ghcjs;
  constraints-extras = haskellLib.doJailbreak super.constraints-extras;

  universe-dependent-sum = self.callCabal2nix "universe-dependent-sum" (universeSrc + "/universe-dependent-sum") {};
  universe-instances-base = self.callCabal2nix "universe-instances-base" (universeSrc + "/deprecated/universe-instances-base") {};
  universe-instances-trans = self.callCabal2nix "universe-instances-trans" (universeSrc + "/deprecated/universe-instances-trans") {};
  universe-instances-extended = self.callCabal2nix "universe-instances-extended" (universeSrc + "/universe-instances-extended") {};
  universe-reverse-instances = self.callCabal2nix "universe-reverse-instances" (universeSrc + "/universe-reverse-instances") {};
  universe-base = self.callCabal2nix "universe-base" (universeSrc + "/universe-base") {};
  universe = self.callCabal2nix "universe" (universeSrc + "/universe") {};

}
