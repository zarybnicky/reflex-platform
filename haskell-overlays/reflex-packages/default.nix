{ haskellLib
, lib, nixpkgs
, thunkSet, fetchFromGitHub, fetchFromBitbucket
, useFastWeak, useReflexOptimizer, enableTraceReflexEvents, enableLibraryProfiling
}:

with haskellLib;

self: super:

let
  reflexDom = import self._dep.reflex-dom self nixpkgs;
  jsaddleSrc = self._dep.jsaddle;
  gargoylePkgs = self.callPackage self._dep.gargoyle self;
  ghcjsDom = import self._dep.ghcjs-dom self;
  addReflexTraceEventsFlag = drv: if enableTraceReflexEvents
    then appendConfigureFlag drv "-fdebug-trace-events"
    else drv;
  addReflexOptimizerFlag = drv: if useReflexOptimizer && (self.ghc.cross or null) == null
    then appendConfigureFlag drv "-fuse-reflex-optimizer"
    else drv;
  addFastWeakFlag = drv: if useFastWeak
    then enableCabalFlag drv "fast-weak"
    else drv;
in
{
  _dep = super._dep or {} // thunkSet ./dep;

  ##
  ## Reflex family
  ##

  # Failing hlint test
  reflex = doJailbreak (dontCheck (addFastWeakFlag (addReflexTraceEventsFlag (
    appendPatch (addReflexOptimizerFlag (self.callPackage self._dep.reflex {})) ./reflex-cabal.patch
  ))));
  reflex-todomvc = self.callPackage self._dep.reflex-todomvc {};
  reflex-aeson-orphans = self.callCabal2nix "reflex-aeson-orphans" self._dep.reflex-aeson-orphans {};
  reflex-dom = if !(self.ghc.isGhcjs or false)
    then (nixpkgs.haskell.lib.addBuildDepend (nixpkgs.haskell.lib.enableCabalFlag
      (doJailbreak (addReflexOptimizerFlag reflexDom.reflex-dom)) "use-warp")
      self.jsaddle-warp)
    else doJailbreak (addReflexOptimizerFlag reflexDom.reflex-dom);

  reflex-dom-core = dontCheck (doJailbreak (appendConfigureFlags
    (addReflexOptimizerFlag (appendPatch reflexDom.reflex-dom-core ./reflex-dom-core-hydration.patch))
    (lib.optional enableLibraryProfiling "-fprofile-reflex")));
  chrome-test-utils = reflexDom.chrome-test-utils;

  haskell-src-exts = self.callHackage "haskell-src-exts" "1.21.0" {};

  jsaddle-warp = dontCheck super.jsaddle-warp;
  jsaddle-webkit2gtk = null;

  haddock-api = dontHaddock (doJailbreak super.haddock-api);
  multistate = doJailbreak super.multistate;
  stylish-haskell = doJailbreak super.stylish-haskell;
  monad-dijkstra = dontCheck super.monad-dijkstra;

  inspection-testing = if self.ghc.isGhcjs or false then null else super.inspection-testing;

  ##
  ## Gargoyle
  ##

  inherit (gargoylePkgs) gargoyle gargoyle-postgresql gargoyle-postgresql-nix;

  ##
  ## Misc other dependencies
  ##

  haskell-gi-overloading = dontHaddock (self.callHackage "haskell-gi-overloading" "0.0" {});

  monoidal-containers = self.callHackage "monoidal-containers" "0.4.0.0" {};

  # Misc new features since Hackage relasese
  dependent-sum-template = self.callCabal2nix "dependent-sum-template" (fetchFromGitHub {
    owner = "mokus0";
    repo = "dependent-sum-template";
    rev = "bfe9c37f4eaffd8b17c03f216c06a0bfb66f7df7";
    sha256 = "1w3s7nvw0iw5li3ry7s8r4651qwgd22hmgz6by0iw3rm64fy8x0y";
  }) {};
  # Not on Hackage yet
  dependent-sum-universe-orphans = self.callCabal2nix "dependent-sum-universe-orphans" (fetchFromGitHub {
    owner = "obsidiansystems";
    repo = "dependent-sum-universe-orphans";
    rev = "8c28c09991cd7c3588ae6db1be59a0540758f5f5";
    sha256 = "0dg32s2mgxav68yw6g7b15w0h0z116zx0qri26gprafgy23bxanm";
  }) {};
  # Version 1.2.1 not on Hackage yet
  hspec-webdriver = self.callCabal2nix "hspec-webdriver" (fetchFromBitbucket {
    owner = "wuzzeb";
    repo = "webdriver-utils";
    rev = "a8b15525a1cceb0ddc47cfd4d7ab5a29fdbe3127";
    sha256 = "0csmxyxkxqgx0v2vwphz80515nqz1hpw5v7391fqpjm7bfgy47k4";
  } + "/hspec-webdriver") {};

}
