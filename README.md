# Dotfiles

Just some basic dotfiles, configs, and setup scripts I use with Ubuntu and GNOME. Nothing crazy optimised or efficient if that's what you're looking for.

## Directories

- `_conf` - Configuration files
- `_scripts` - Some helper scripts for setup and configuration

All other directories in this repo (that don't begin with underscore) are packages to used with the [stow](https://www.gnu.org/software/stow/) command. Refer to the guide below for this.

## Guide

### Package Installation

Run the following command to install the desired apt and snap packages defined in [./\_conf/packages.conf](./_conf/packages.conf) using the dedicated install script:

```
./_scripts/install.sh
```

### Applying Gsettings Keybinds

Run the following command to apply the specified Gsettings keybinds defined in [./\_conf/gsettings.conf](./_conf/gsettings.conf) as well as custom keybinds in [./\_conf/custom-keybinds.conf](./_conf/custom-keybinds.conf) with the dedicated script:

```
./_scripts/gsettings.sh
```

### Setting Up Dotfiles

Make sure you have `stow` installed. Run the following command to `stow` the packages in this repo.

```
./_scripts/stow.sh
```

Note: This basically puts in the place the configured dotfiles into the home directory as well as any other files specified in the packages.

### Setup

Run the following command to run the above two steps back to back for easy setup:

```
./_scripts/setup.sh
```
