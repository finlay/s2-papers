PROJ := rob-elshire-citations


default.nix: $(PROJ).cabal
	cabal2nix . > $@

shell:
	nix-shell --attr project.env release.nix


