#!/usr/bin/env bash
# Bootstrap this nvim config on a fresh macOS or Ubuntu machine.
# Idempotent: re-running is a no-op when everything is already in place.
#
# Usage:
#   ./install.sh           # install system deps + first nvim launch
#   ./install.sh --deps    # system deps only, skip the nvim launch
#   ./install.sh --no-font # skip nerd font install

set -euo pipefail

INSTALL_FONT=1
RUN_NVIM=1
for arg in "$@"; do
  case "$arg" in
    --no-font) INSTALL_FONT=0 ;;
    --deps)    RUN_NVIM=0 ;;
    -h|--help)
      sed -n '2,9p' "$0"; exit 0 ;;
    *) echo "unknown flag: $arg" >&2; exit 2 ;;
  esac
done

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!! \033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mxx \033[0m %s\n' "$*" >&2; exit 1; }

OS="$(uname -s)"
case "$OS" in
  Darwin) PLATFORM=mac ;;
  Linux)
    if ! grep -qi ubuntu /etc/os-release 2>/dev/null; then
      die "Linux detected but not Ubuntu — this script only handles Ubuntu via apt."
    fi
    PLATFORM=ubuntu
    ;;
  *) die "Unsupported OS: $OS" ;;
esac
log "Platform: $PLATFORM"

# ---------------------------------------------------------------------------
# 1. Package manager + system deps
# ---------------------------------------------------------------------------
if [ "$PLATFORM" = mac ]; then
  if ! command -v brew >/dev/null 2>&1; then
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if ! xcode-select -p >/dev/null 2>&1; then
    warn "Xcode Command Line Tools not installed. Run: xcode-select --install"
    warn "(Needed for clangd LSP and treesitter parser compilation.)"
  fi

  log "Installing system packages via brew"
  brew install \
    neovim git curl unzip make \
    ripgrep fd \
    node python@3

  if [ "$INSTALL_FONT" = 1 ]; then
    log "Installing JetBrainsMono Nerd Font"
    brew install --cask font-jetbrains-mono-nerd-font || \
      warn "Font install failed — set your terminal font manually."
  fi
else
  log "Updating apt"
  sudo apt-get update

  log "Adding neovim unstable PPA (apt's nvim is too old for this config)"
  if ! grep -rq neovim-ppa /etc/apt/sources.list.d/ 2>/dev/null; then
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt-get update
  fi

  log "Installing system packages via apt"
  sudo apt-get install -y \
    neovim git curl unzip build-essential \
    ripgrep fd-find \
    clangd \
    nodejs npm \
    python3 python3-pip python3-venv \
    xclip wl-clipboard

  # On Ubuntu the binary is `fdfind`. Telescope and friends look for `fd`.
  if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    log "Symlinked fdfind -> ~/.local/bin/fd (ensure ~/.local/bin is on PATH)"
  fi

  if [ "$INSTALL_FONT" = 1 ]; then
    log "Installing JetBrainsMono Nerd Font into ~/.local/share/fonts"
    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"
    if ! ls "$FONT_DIR"/JetBrainsMonoNerdFont* >/dev/null 2>&1; then
      TMP="$(mktemp -d)"
      curl -fsSL -o "$TMP/jbm.zip" \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
      unzip -q "$TMP/jbm.zip" -d "$FONT_DIR"
      fc-cache -f >/dev/null
      rm -rf "$TMP"
    else
      log "JetBrainsMono Nerd Font already installed"
    fi
  fi
fi

# ---------------------------------------------------------------------------
# 2. Sanity check toolchain
# ---------------------------------------------------------------------------
for tool in nvim git node npm python3 rg; do
  command -v "$tool" >/dev/null 2>&1 || die "Missing required tool after install: $tool"
done

NVIM_VER="$(nvim --version | head -1 | awk '{print $2}')"
log "neovim installed: $NVIM_VER"

# ---------------------------------------------------------------------------
# 3. First launch: let lazy + mason install everything
# ---------------------------------------------------------------------------
if [ "$RUN_NVIM" = 1 ]; then
  log "First nvim launch — installing plugins via lazy.nvim"
  nvim --headless "+Lazy! sync" +qa || warn "Lazy sync returned non-zero (often benign during first install)"

  log "Installing Mason packages (LSPs, formatters, tree-sitter-cli)"
  # mason-tool-installer's run_on_start handles this, but it's async; drive it
  # synchronously here so the bootstrap is done when this script exits.
  nvim --headless -c "lua require('mason-tool-installer').run_on_start()" \
                  -c "autocmd User MasonToolsUpdateCompleted ++once quitall" \
                  -c "lua vim.defer_fn(function() vim.cmd('qa') end, 180000)" \
    || warn "Mason install returned non-zero"

  log "Done. Open nvim and run :checkhealth to verify."
else
  log "Skipping nvim launch (--deps)."
fi
