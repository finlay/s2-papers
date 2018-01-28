PROJ := s2-papers


default.nix: $(PROJ).cabal
	cabal2nix . > $@

shell:
	nix-shell --attr project.env release.nix


