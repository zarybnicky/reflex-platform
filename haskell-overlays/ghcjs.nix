{ lib, haskellLib, nixpkgs, fetchgit, fetchFromGitHub, useReflexOptimizer }:

with haskellLib;

self: super: {
  # doctest doesn't work on ghcjs, but sometimes dontCheck doesn't seem to get rid of the dependency
  doctest = lib.warn "ignoring dependency on doctest" null;

  # These packages require doctest
  comonad = dontCheck super.comonad;
  http-types = dontCheck super.http-types;
  lens = disableCabalFlag (disableCabalFlag (dontCheck super.lens) "test-properties") "test-doctests";
  pgp-wordlist = dontCheck super.pgp-wordlist;
  prettyprinter = dontCheck super.prettyprinter;
  QuickCheck = dontCheck super.QuickCheck;
  tasty-quickcheck = dontCheck super.tasty-quickcheck;
  semigroupoids = disableCabalFlag super.semigroupoids "doctests";

  jsaddle = haskellLib.addBuildDepend super.jsaddle self.ghcjs-base;
  ghcjs-base = doJailbreak (dontCheck (self.callCabal2nix "ghcjs-base" (fetchFromGitHub {
    owner = "ghcjs";
    repo = "ghcjs-base";
    rev = "6be0e992e292db84ab42691cfb172ab7cd0e709e";
    sha256 = "0nk7a01lprf40zsiph3ikwcqcdb1lghlj17c8zzhiwfmfgcc678g";
  }) {}));

  # Convenience: tests take long to finish
  megaparsec = dontCheck super.megaparsec;

  # Need newer version of colour for some reason.
  colour = dontCheck (super.colour.overrideAttrs (drv: {
    src = nixpkgs.buildPackages.fetchurl {
      url = "http://hackage.haskell.org/package/colour-2.3.4/colour-2.3.4.tar.gz";
      sha256 = "1sy51nz096sv91nxqk6yk7b92b5a40axv9183xakvki2nc09yhqg";
    };
  }));
}
