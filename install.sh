#!/usr/bin/env bash
#
# Prerequisites:
#   macOS: nothing else (curl installs Homebrew if missing)
#   Linux: sudo (for package manager commands)
#
# Everything else (git, node, npm, go, ripgrep, fd, rustup, neovim) is
# installed automatically by this script.
#
set -euo pipefail

REPO_URL="${REPO_URL:-git@github.com:SaladClimbing/nvim-config.git}"
INSTALL_FONT=false
CONFIG_DIR="$HOME/.config/nvim"
NVIM_BIN_DIR="$HOME/.local/bin"
VERBOSE=false

usage() {
  cat <<EOF
Usage: $0 [options] [repo-url]

Install neovim config and dependencies.

Options:
  -v, --verbose     Show all install output (no progress bar)
  --install-font    Install JetBrainsMono Nerd Font
  --help            Show this help

Arguments:
  repo-url          Git URL of nvim config (default: $REPO_URL)
EOF
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--verbose) VERBOSE=true; shift ;;
    --install-font) INSTALL_FONT=true; shift ;;
    --help) usage ;;
    -*)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
    *) REPO_URL="$1"; shift ;;
  esac
done

# ──────────────────────────────────────────────
# Progress / logging
# ──────────────────────────────────────────────
run_stage() {
  local label="$1"
  shift

  if $VERBOSE; then
    echo "==> $label"
    "$@"
  else
    local log_file
    log_file=$(mktemp)

    (
      trap 'exit 0' TERM
      local spin='-\|/'
      local i=0
      while true; do
        printf "\r[%c] %s  " "${spin:$i:1}" "$label"
        i=$(( (i+1) % 4 ))
        sleep 0.1
      done
    ) &
    local spin_pid=$!

    set +e
    "$@" > "$log_file" 2>&1
    local exit_code=$?
    set -e

    kill "$spin_pid" 2>/dev/null || true
    wait "$spin_pid" 2>/dev/null || true

    printf "\r\033[K"
    if [ "$exit_code" -ne 0 ]; then
      printf "[\e[31m✗\e[0m] %s\n" "$label"
      cat "$log_file" >&2
      rm -f "$log_file"
      exit "$exit_code"
    else
      printf "[\e[32m✓\e[0m] %s\n" "$label"
    fi

    rm -f "$log_file"
  fi
}

# ──────────────────────────────────────────────
# OS / pkg manager detection
# ──────────────────────────────────────────────
OS="$(uname -s)"

detect_pkg_manager() {
  case "$OS" in
    Darwin)
      if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi
      PKG_MANAGER=brew
      PKG_INSTALL="brew install"
      PKG_INSTALL_CASK="brew install --cask"
      ;;
    Linux)
      if command -v apt &>/dev/null; then
        PKG_MANAGER=apt
        PKG_INSTALL="sudo apt install -y"
        PKG_UPDATE="sudo apt update -y"
      elif command -v dnf &>/dev/null; then
        PKG_MANAGER=dnf
        PKG_INSTALL="sudo dnf install -y"
        PKG_UPDATE="sudo dnf check-update || true"
      elif command -v pacman &>/dev/null; then
        PKG_MANAGER=pacman
        PKG_INSTALL="sudo pacman -S --noconfirm"
        PKG_UPDATE="sudo pacman -Sy"
      elif command -v zypper &>/dev/null; then
        PKG_MANAGER=zypper
        PKG_INSTALL="sudo zypper install -y"
        PKG_UPDATE="sudo zypper refresh"
      else
        echo "Unsupported Linux distro (no apt/dnf/pacman/zypper found)." >&2
        exit 1
      fi
      ;;
    *)
      echo "Unsupported OS: $OS" >&2
      exit 1
      ;;
  esac
}

# ──────────────────────────────────────────────
# System dependencies
# ──────────────────────────────────────────────
install_deps() {
  case "$PKG_MANAGER" in
    apt)
      $PKG_UPDATE
      $PKG_INSTALL git curl unzip nodejs npm golang-go ripgrep fd-find build-essential
      if ! command -v rustup &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
      fi
      ;;
    dnf)
      $PKG_UPDATE
      $PKG_INSTALL git curl unzip nodejs npm golang ripgrep fd-find make gcc
      if ! command -v rustup &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
      fi
      ;;
    pacman)
      $PKG_UPDATE
      $PKG_INSTALL git curl unzip nodejs npm go ripgrep fd base-devel
      if ! command -v rustup &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
      fi
      ;;
    zypper)
      $PKG_UPDATE
      $PKG_INSTALL git curl unzip nodejs npm golang ripgrep fd pattern:devel_basis
      if ! command -v rustup &>/dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
      fi
      ;;
    brew)
      $PKG_INSTALL git node go ripgrep fd
      if ! command -v rustup &>/dev/null; then
        $PKG_INSTALL rustup-init
        rustup-init -y
      fi
      ;;
  esac

  # Ensure rustup-managed toolchain is available
  if [ -f "$HOME/.cargo/env" ]; then
    # shellcheck disable=SC1091
    source "$HOME/.cargo/env"
  fi
}

# ──────────────────────────────────────────────
# Neovim installation (Linux: AppImage, macOS: brew)
# ──────────────────────────────────────────────
install_neovim() {
  case "$OS" in
    Darwin)
      $PKG_INSTALL neovim
      ;;
    Linux)
      if command -v nvim &>/dev/null; then
        local version
        version=$(nvim --version 2>/dev/null | head -1 | grep -oP 'v\K[0-9]+\.[0-9]+' || echo "0.0")
        if awk "BEGIN { exit !($version >= 0.9) }" 2>/dev/null; then
          echo "Neovim >= 0.9 already installed, skipping."
          return 0
        fi
      fi

      mkdir -p "$NVIM_BIN_DIR"

      local version_url
      version_url=$(curl -sL "https://api.github.com/repos/neovim/neovim/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)

      # Try AppImage (FUSE required)
      if command -v fusermount &>/dev/null || command -v fuse3 &>/dev/null; then
        echo "Downloading nvim.appimage..."
        curl -fsSL "https://github.com/neovim/neovim/releases/download/${version_url}/nvim.appimage" -o /tmp/nvim.appimage
        chmod +x /tmp/nvim.appimage
        if /tmp/nvim.appimage --version &>/dev/null; then
          cp /tmp/nvim.appimage "$NVIM_BIN_DIR/nvim"
          chmod +x "$NVIM_BIN_DIR/nvim"
          echo "Neovim installed via AppImage."
          return 0
        fi
        echo "AppImage failed, falling back to tarball..."
      fi

      # Fallback: tarball
      echo "Downloading nvim tarball..."
      curl -fsSL "https://github.com/neovim/neovim/releases/download/${version_url}/nvim-linux64.tar.gz" -o /tmp/nvim-linux64.tar.gz
      tar xzf /tmp/nvim-linux64.tar.gz -C /tmp
      cp /tmp/nvim-linux64/bin/nvim "$NVIM_BIN_DIR/nvim"
      chmod +x "$NVIM_BIN_DIR/nvim"
      echo "Neovim installed via tarball."
      ;;
  esac
}

# ──────────────────────────────────────────────
# Nerd Font
# ──────────────────────────────────────────────
install_font() {
  case "$OS" in
    Darwin)
      $PKG_INSTALL_CASK font-jetbrains-mono-nerd-font
      ;;
    Linux)
      local font_dir="$HOME/.local/share/fonts"
      mkdir -p "$font_dir"
      curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" -o /tmp/JetBrainsMono.tar.xz
      tar xf /tmp/JetBrainsMono.tar.xz -C "$font_dir"
      fc-cache -fv "$font_dir" &>/dev/null
      echo "Font installed to $font_dir"
      ;;
  esac
}

# ──────────────────────────────────────────────
# Clone config
# ──────────────────────────────────────────────
clone_config() {
  if [ -d "$CONFIG_DIR" ]; then
    local backup="${CONFIG_DIR}.bak.$(date +%s)"
    echo "Backing up existing config -> $backup"
    mv "$CONFIG_DIR" "$backup"
  fi

  git clone --depth=1 "$REPO_URL" "$CONFIG_DIR"
}

# ──────────────────────────────────────────────
# Install plugins (lazy.nvim bootstrap)
# ──────────────────────────────────────────────
install_plugins() {
  # Ensure PATH includes nvim
  export PATH="$NVIM_BIN_DIR:$PATH"

  # lazy.nvim handles its own bootstrap; sync installs all locked plugins
  nvim --headless "+Lazy! sync" +qa 2>&1 | tail -5 || true
}

# ──────────────────────────────────────────────
# Trigger Mason LSP / tool installs
# ──────────────────────────────────────────────
install_mason_packages() {
  # Start nvim headless and keep it alive for 3 minutes so Mason can download
  # as many LSP servers and tools as possible. The config's ensure_installed
  # and VimEnter autocmd handle everything. Incomplete installs resume on next open.
  nvim --headless \
    "+lua vim.defer_fn(function() vim.cmd('qa!') end, 180000)" \
    2>/dev/null &
  local nvim_pid=$!

  # Show a spinner while waiting
  local elapsed=0
  while kill -0 "$nvim_pid" 2>/dev/null && [ "$elapsed" -lt 210 ]; do
    sleep 5
    elapsed=$((elapsed + 5))
    printf "    Installing Mason packages... %ds\r" "$elapsed"
  done
  printf "\n"

  wait "$nvim_pid" 2>/dev/null || true

  echo "    Mason installs initiated. Open nvim to finish any remaining."
  echo "    Check progress with:  :Mason"
}

# ──────────────────────────────────────────────
# Print summary
# ──────────────────────────────────────────────
print_summary() {
  echo ""
  echo "╔══════════════════════════════════════════╗"
  echo "║         Neovim setup complete!           ║"
  echo "╚══════════════════════════════════════════╝"
  echo ""

  if command -v nvim &>/dev/null; then
    nvim --version | head -1
  else
    echo "NOTE: nvim not in PATH. Add to your shell rc:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
  fi

  echo ""
  echo "Next steps:"
  echo "  1. Open nvim — Mason auto-installs LSP servers & formatters:"
  echo "       nvim"
  echo "     Check progress:  :Mason"
  echo ""
  echo "  2. (optional) Install extra Treesitter parsers:"
  echo "       :TSInstall all"
  echo ""
  echo "Config: $CONFIG_DIR"
}

# ──────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────
run_stage "Detecting OS and package manager" detect_pkg_manager
run_stage "Installing system dependencies" install_deps
run_stage "Installing Neovim" install_neovim

if $INSTALL_FONT; then
  run_stage "Installing JetBrainsMono Nerd Font" install_font
fi

run_stage "Cloning nvim config" clone_config

# Ensure PATH includes nvim for subsequent steps
export PATH="$NVIM_BIN_DIR:$PATH"

run_stage "Installing Neovim plugins" install_plugins
run_stage "Installing Mason LSP packages" install_mason_packages

print_summary
