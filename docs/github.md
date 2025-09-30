# 🚀 Git Utilities & Aliases for `jd-35656`

A powerful set of Git command-line helpers, shortcuts, and GitHub integrations designed for personal development workflows.

---

## 📦 Function List

### `gclone`

Clone any Git repo and `cd` into it.

```bash
gclone <repo-url>
```

**Example:**

```bash
gclone https://github.com/torvalds/linux.git
```

---

### `gcloneme`

Clone your own GitHub repo via SSH and `cd` into it.

```bash
gcloneme <repo-name>
```

**Example:**

```bash
gcloneme dotfiles
```

Clones:

```txt
git@github.com:jd-35656/dotfiles.git
```

---

### `setoriginme`

Set or replace the `origin` remote in your current project to point to your GitHub SSH repo. Initializes Git if needed.

```bash
setoriginme <repo-name>
```

---

### `gcommit`

Stage all changes and commit with a message.

```bash
gcommit "Your commit message"
```

---

### `gpush`

Stage all, commit, and push to the current branch.

```bash
gpush "Initial commit"
```

---

### `gcode`

Clone your GitHub repo and open in VS Code.

```bash
gcode <repo-name>
```

---

### `gopen`

Open the GitHub page for your repo in the browser.

```bash
gopen <repo-name>
```

---

### `ghmyrepos`

List all your GitHub repositories using `gh` CLI + `jq`.

```bash
ghmyrepos
```

> Requires:
>
> * GitHub CLI (`gh`)
> * `jq` installed

---

### `ghcreate`

Create a **private GitHub repo** and push current directory.

```bash
ghcreate <repo-name>
```

---

### `gstatusall`

Run `git status -s` in all subfolders that are Git repos.

```bash
gstatusall
```

---

### `glog`

Pretty, graphical git log for all branches.

```bash
glog
```

---

### `gcleanup`

Clean up local branches that are already merged (except `main`/`master`).

```bash
gcleanup
```

---

## 🧩 Git Aliases (in `.gitconfig`)

```ini
[alias]
  st = status
  co = checkout
  br = branch
  ci = commit
  cm = commit -m
  ca = commit --amend
  lg = log --oneline --graph --decorate --all
  last = log -1 HEAD
  undo = reset HEAD~1 --mixed
  unstage = reset HEAD --
  hist = log --pretty=format:'%C(yellow)%h%Creset %ad | %s%Creset %Cgreen(%an)%Creset' --date=short
  pushf = push --force-with-lease
  cleanup = "!git branch --merged | grep -v '\\*\\|main\\|master' | xargs -n 1 git branch -d"
```

---

## ⚙️ Recommended Tools

| Tool                | Purpose              | Install Command                                                               |
| ------------------- | -------------------- | ----------------------------------------------------------------------------- |
| `gh`                | GitHub CLI           | [https://cli.github.com](https://cli.github.com)                              |
| `jq`                | JSON parser for CLI  | `sudo apt install jq` / `brew install jq`                                     |
| `code`              | VS Code CLI launcher | [Enable from VS Code](https://code.visualstudio.com/docs/editor/command-line) |
| `open` / `xdg-open` | Open URLs in browser | macOS: built-in, Linux: install `xdg-utils`                                   |
