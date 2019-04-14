{ lib, haskellLib, fetchFromGitHub, fetchpatch, versionWildcard }:

with lib;
with haskellLib;

self: super: {
  _dep = super._dep or {} // {
    ghcjsBaseTextJSStringSrc = fetchgit {
      url = "https://github.com/ghcjs/ghcjs-base.git";
      rev = "6be0e992e292db84ab42691cfb172ab7cd0e709e";
      sha256 = "0nk7a01lprf40zsiph3ikwcqcdb1lghlj17c8zzhiwfmfgcc678g";
      postFetch = (drv.postFetch or "") + ''
        ( cd $out
          patch -p1 < ${./ghcjs-base-text-jsstring.patch}
        )
      '';
    };
  };

  # text = (doCheck (self.callCabal2nix "text" (fetchFromGitHub {
  #   owner = "obsidiansystems";
  #   repo = "text";
  #   rev = "50076be0262203f0d2afdd0b190a341878a08e21";
  #   sha256 = "1vy7a81b1vcbfhv7l3m7p4hx365ss13mzbzkjn9751bn4n7x2ydd";
  # }) {})).overrideScope (self: super: {
  #   text = null;
  #   QuickCheck = haskellLib.addBuildDepend (self.callHackage "QuickCheck" "2.9.2" {}) self.tf-random;
  # });
  # parsec = dontCheck (self.callHackage "parsec" "3.1.13.0" {});
  jsaddle = overrideCabal super.jsaddle (drv: {
    buildDepends = (drv.buildDepends or []) ++ [
      self.ghcjs-base
      self.ghcjs-prim
    ];
  });
  attoparsec = self.callCabal2nix "attoparsec" (fetchFromGitHub {
    owner = "obsidiansystems";
    repo = "attoparsec";
    rev = "5569fbd47ae235a800653134a06bf51186c91f8f";
    sha256 = "0qgr9xcmwzbxxm84l9api7bib6bspmkii1d7dlg8bcgk9icqwbcw";
  }) {};
  buffer-builder = overrideCabal super.buffer-builder (drv: {
    doCheck = false;
    src = fetchFromGitHub {
      owner = "obsidiansystems";
      repo = "buffer-builder";
      rev = "59c730e0dec7ff0efd8068250f4bca9cb74c471d";
      sha256 = "18dd2ydva3hnsfyrzmi3y3r41g2l4r0kfijaan85y6rc507k6x5c";
    };
  });
  hashable = overrideCabal super.hashable (drv: {
    revision = null;
    editedCabalFile = null;
    jailbreak = true;
    doCheck = false;
    libraryHaskellDepends = (drv.libraryHaskellDepends or []) ++ [
      self.text
    ];
    patches = (drv.patches or []) ++ [
      ./hashable.patch
    ];
  });
  conduit-extra = dontCheck (appendPatch super.conduit-extra ./conduit-extra-text-jsstring.patch);
  double-conversion = overrideCabal super.double-conversion (drv: {
    src = fetchFromGitHub {
      owner = "obsidiansystems";
      repo = "double-conversion";
      rev = "0f9ddde468687d25fa6c4c9accb02a034bc2f9c3";
      sha256 = "0sjljf1sbwalw1zycpjf6bqhljag9i1k77b18b0fd1pzrc29wnks";
    };
  });
  say = overrideCabal super.say (drv: {
    patches = (drv.patches or []) ++ [
      ./say.patch
    ];
    buildDepends = (drv.buildDepends or []) ++ [
      self.ghcjs-base
    ];
  });
  aeson = appendPatch super.aeson ./aeson.patch;
  text-show = appendPatch super.text-show ./text-show.patch;
}
