 FireFly's /etc/nixos
======================

This is the configuration for my NixOS systems.

I clone this repo as my */etc/nixos*, symlinking the host-specific
*configuration.nix* into the repo root on the local machine.


## Repository structure

* *hosts/* --
  Contains directories per host with its *configuration.nix* entry-point along
  with other host-specific config.

* *modules/* --
  This directory contains NixOS modules implementing actual functionality,
  similar to what you'd find in `<nixpkgs/nixos/modules>`.

* *config/* --
  Actual (shared) configuration files for system & application, suited to my
  personal tastes.

* *profiles/* --
  Shared sets of settings grouped together into convenient chunks to
  pick-and-choose from, for instance depending on what type of machine a
  specific host is.

* *overlays/* --
  Various overlays, either adding new packages or patching existing ones.

* (*secrets/*) --
  Not actually present in the repository, this directory is imported from
  the secrets.nix module and contains keys and other sensitive data (but
  nothing that I'm not comfortable with keeping in the nix store).
