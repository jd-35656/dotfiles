# JD's Dotfiles

This repository contains a set of configuration files, symlinks, and scripts to set up and manage various tools, packages, and extensions on your system. You can easily install, uninstall, backup, or manage symlinks for different tools using the provided `manage.sh` script.

## Table of Contents

* [Installation](#installation)
* [Usage](#usage)

  * [General Usage](#general-usage)
  * [Subcommands](#subcommands)

    * [symlink](#symlink)
    * [install](#install)
    * [uninstall](#uninstall)
    * [backup](#backup)
* [Examples](#examples)

## Installation

Clone this repository to your local machine:

```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
```

You can now use the `manage.sh` script to manage symlinks, installations, uninstalls, and backups.

## Usage

The `manage.sh` script accepts one main subcommand to perform different operations, such as managing symlinks, installing/uninstalling packages, or backing up your tool configurations.

### General Usage

```bash
./manage.sh {symlink|install|uninstall|backup} [subcommand] [options]
```

Where:

* `{symlink|install|uninstall|backup}`: The primary subcommand that controls the action.
* `[subcommand]`: The specific action within the chosen subcommand.
* `[options]`: Additional options or flags to control behavior.

### Subcommands

#### 1. `symlink`

Manage symlinks for various packages or configuration files.

```bash
./manage.sh symlink {link|unlink|show} [package1 package2 ...]
```

##### Subcommands

* **link**: Create symlinks for specified packages (all if none specified).
* **unlink**: Remove symlinks for specified packages (all if none specified).
* **show**: Display all current symlinks.

##### Options

* `-h`, `--help`: Show help information for the `symlink` subcommand.

Example:

* Create symlinks for all packages:

  ```bash
  ./manage.sh symlink link
  ```

* Remove symlinks for specific packages:

  ```bash
  ./manage.sh symlink unlink package1 package2
  ```

#### 2. `install`

Manage installation of packages and extensions for different tools.

```bash
./manage.sh install [target ...]
```

##### Available Targets

* `brew-leaves`: Install Homebrew packages.
* `brew-casks`: Install Homebrew casks.
* `vscode-extensions`: Install Visual Studio Code extensions.
* `pipx-packages`: Install pipx packages.
* `asdf-plugins`: Install asdf plugins.

If no targets are specified, all targets will be installed.

##### Options

* `-h`, `--help`: Show help information for the `install` subcommand.

Example:

* Install all targets:

  ```bash
  ./manage.sh install
  ```

* Install only Visual Studio Code extensions:

  ```bash
  ./manage.sh install vscode-extensions
  ```

#### 3. `uninstall`

Manage uninstallation of packages and extensions for various tools.

```bash
./manage.sh uninstall [target ...]
```

##### Available Targets

* `brew-leaves`: Uninstall Homebrew packages.
* `brew-casks`: Uninstall Homebrew casks.
* `vscode-extensions`: Uninstall Visual Studio Code extensions.
* `pipx-packages`: Uninstall pipx packages.
* `asdf-plugins`: Uninstall asdf plugins.

If no targets are specified, all targets will be uninstalled.

##### Options

* `-h`, `--help`: Show help information for the `uninstall` subcommand.

Example:

* Uninstall all targets:

  ```bash
  ./manage.sh uninstall
  ```

* Uninstall only Visual Studio Code extensions:

  ```bash
  ./manage.sh uninstall vscode-extensions
  ```

#### 4. `backup`

Backup the lists of installed packages and extensions for various tools.

```bash
./manage.sh backup [target ...]
```

##### Available Targets

* `brew-leaves`: Backup Homebrew packages.
* `brew-casks`: Backup Homebrew casks.
* `vscode-extensions`: Backup Visual Studio Code extensions.
* `pipx-packages`: Backup pipx packages.
* `asdf-plugins`: Backup asdf plugins.

If no targets are specified, all targets will be backed up.

##### Options

* `-h`, `--help`: Show help information for the `backup` subcommand.

Example:

* Backup all targets:

  ```bash
  ./manage.sh backup
  ```

* Backup only Visual Studio Code extensions:

  ```bash
  ./manage.sh backup vscode-extensions
  ```

## Examples

Here are some example use cases:

* **Install all packages**:

  ```bash
  ./manage.sh install
  ```

* **Uninstall only Homebrew leaves** (packages not managed by other tools):

  ```bash
  ./manage.sh uninstall brew-leaves
  ```

* **Backup all configurations**:

  ```bash
  ./manage.sh backup
  ```

* **Show all current symlinks**:

  ```bash
  ./manage.sh symlink show
  ```
