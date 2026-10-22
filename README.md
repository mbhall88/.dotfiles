# Install

```sh
git clone https://github.com/mbhall88/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

# Latch pods

Ubuntu pods (root, `ssh pod`) get a different install, because the pod already has its own bash
setup (mamba, nvm, `gh` credentials) that must not be replaced:

```sh
git clone https://github.com/mbhall88/.dotfiles.git ~/.dotfiles
~/.dotfiles/pod-setup --git-email you@example.com
```

Safe to re-run. It installs zsh and the CLI tools I use (`--skip-apt` to leave system packages alone),
links the subset of dotfiles in `install.pod.conf.yaml` (anything it would replace is moved to
`~/.dotfiles-backup/`), and makes terminal logins land in zsh. `ssh pod <cmd>`, scp, rsync and VS Code
still run under bash.

Pod-specific pieces it writes (not in the repo): `~/.bash_profile` (bash -> zsh handoff),
`~/.zshrc.local` (the pod's mamba/nvm/cargo init, repeated for zsh), `~/.zshenv`, `~/.gitconfig.local`,
and a `latch` wrapper in `~/.local/bin` that runs the Latch CLI with `HOME=/root/latchhome`.

If zsh is ever broken: `ssh -t pod bash --norc`.
