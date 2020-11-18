DEST_PKGS:=/etc/nixos/packages/qrcp.nix
DEST_OVLS:=/etc/nixos/overlays/neovim.nix
DEST:=/etc/nixos/configuration.nix /etc/nixos/hardware-configuration.nix /etc/nixos/packages/default.nix $(DEST_OVLS) $(DEST_PKGS)

.PHONY: rebuild
rebuild: $(DEST) submodules
	nixos-rebuild switch --upgrade -I nixpkgs=./.submodules/nixpkgs -I nixpkgs-overlays=/etc/nixos/overlays

.PHONY: install
install: $(DEST)

.PHONY: clean
clean:
	nix-collect-garbage -d

.PHONY: submodules
submodules:
	git submodule init
	git submodule update

.dest/hardware-configuration.nix:
	mkdir -p .dest
	if [ -f /etc/nixos/hardware-configuration.nix ]; \
	then cp /etc/nixos/hardware-configuration.nix $@; \
	else sudo nixos-generate-config --show-hardware-config > $@; \
	fi

/etc/nixos/hardware-configuration.nix: .dest/hardware-configuration.nix
	mkdir -p /etc/nixos
	cp $< $@

/etc/nixos/configuration.nix: etc/nixos/configuration.nix
	mkdir -p /etc/nixos
	cp $< $@

/etc/nixos/overlays/neovim.nix: etc/nixos/overlays/neovim.nix
	mkdir -p /etc/nixos/overlays
	cp $< $@

/etc/nixos/packages/default.nix: etc/nixos/packages/default.nix
	mkdir -p /etc/nixos/packages
	cp $< $@

/etc/nixos/packages/qrcp.nix: etc/nixos/packages/qrcp.nix
	mkdir -p /etc/nixos/packages
	cp $< $@
