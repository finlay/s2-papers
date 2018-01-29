PROJ := s2-papers

result/bin/s2-papers: Main.hs default.nix release.nix
	nix-build --attr project release.nix

default.nix: $(PROJ).cabal
	cabal2nix . > $@

shell:
	nix-shell --attr project.env release.nix


