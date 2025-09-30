# ✅ JD's Dotfiles

This repository contains a set of configuration files, symlinks, and scripts to manage and reproduce your system setup. You can install, uninstall, backup, audit, and manage symlinks for various tools using the `manage.sh` script.

---

## 📑 Table of Contents

* [📦 Installation](#-installation)
* [⚙️ Usage](#️-usage)

  * [🔧 General Usage](#-general-usage)
  * [🧩 Subcommands](#-subcommands)

    * [`symlink`](#1-symlink)
    * [`install`](#2-install)
    * [`uninstall`](#3-uninstall)
    * [`backup`](#4-backup)
    * [`list`](#5-list)
    * [`audit`](#6-audit)
* [💡 Examples](#-examples)

---

## 📦 Installation

Clone this repository to your machine:

```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
```

Make sure `manage.sh` is executable:

```bash
chmod +x manage.sh
```

---

## ⚙️ Usage

Run the main command like this:

### 🔧 General Usage

```bash
./manage.sh {symlink|install|uninstall|backup|list|audit} [target ...]
```

* `{...}`: Subcommand for the action you want to take
* `[target ...]`: (Optional) Limit to one or more specific tools
* `--help`: Show help for any subcommand

---

## 🧩 Subcommands

### 1. `symlink`

Manage symlinks for configuration files.

```bash
./manage.sh symlink {link|unlink|show} [target ...]
```

#### Subcommands

* `link`: Create symlinks (all or specified)
* `unlink`: Remove symlinks
* `show`: Show existing symlinks and paths

---

### 2. `install`

Install tools, packages, or extensions based on your tracked configuration files.

```bash
./manage.sh install [target ...]
```

---

### 3. `uninstall`

Remove tools, packages, or extensions listed in your configs.

```bash
./manage.sh uninstall [target ...]
```

---

### 4. `backup`

Back up your current system state (installed packages/extensions) to text files for version control.

```bash
./manage.sh backup [target ...]
```

---

### 5. `list`

Show the contents of your backed-up config files. This does **not** check your current system — it only shows what's version-controlled.

```bash
./manage.sh list [target ...]
```

---

### 6. `audit`

Compare your current system state against the version-controlled `.txt` files.

```bash
./manage.sh audit [target ...]
```

* 🔎 Lists what’s **missing** or **extra**
* Helps you sync system state with your dotfiles

---

## 💡 Examples

### ✅ Install everything

```bash
./manage.sh install
```

### 🧼 Uninstall just VS Code extensions

```bash
./manage.sh uninstall vscode-extensions
```

### 💾 Backup current system state

```bash
./manage.sh backup
```

### 📋 List what's in your tracked config

```bash
./manage.sh list gh-extensions
```

### 🔍 Audit what's missing or extra

```bash
./manage.sh audit pipx-packages
```

### 🔗 Show all active symlinks

```bash
./manage.sh symlink show
```
