.PHONY: rebuild
rebuild: submodules /etc/nixos/configuration.nix /etc/nixos/hardware-configuration.nix
	nixos-rebuild switch --upgrade -I nixpkgs=./.submodules/nixpkgs

.PHONY: install
install: /etc/nixos/configuration.nix /etc/nixos/hardware-configuration.nix

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
	cp $< $@

/etc/nixos/configuration.nix: etc/nixos/configuration.nix
	cp $< $@
