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
SECONDS=0

REPO_URL="${REPO_URL:-https://github.com/SaladClimbing/nvim-config.git}"
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
elapsed() {
  local m=$((SECONDS / 60))
  local s=$((SECONDS % 60))
  if [ "$m" -gt 0 ]; then
    printf "%dm %ds" "$m" "$s"
  else
    printf "%ds" "$s"
  fi
}

run_stage() {
  local label="$1"
  shift
  local start=$SECONDS

  if $VERBOSE; then
    echo "==> $label"
    "$@"
    printf "[\e[32m✓\e[0m] %s  (%s)\n" "$label" "$(elapsed)"
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
      printf "[\e[31m✗\e[0m] %s  (%s)\n" "$label" "$(elapsed)"
      cat "$log_file" >&2
      rm -f "$log_file"
      exit "$exit_code"
    else
      printf "[\e[32m✓\e[0m] %s  (%s)\n" "$label" "$(elapsed)"
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
# System dependencies (granular stages)
# ──────────────────────────────────────────────
update_pkg_index() {
  case "$PKG_MANAGER" in
    apt|dnf|pacman|zypper) $PKG_UPDATE ;;
    brew) ;; # brew self-updates on install
  esac
}

install_core_tools() {
  case "$PKG_MANAGER" in
    apt|dnf|pacman|zypper) $PKG_INSTALL git curl unzip ;;
    brew) $PKG_INSTALL git ;;
  esac
}

install_langs() {
  case "$PKG_MANAGER" in
    apt) $PKG_INSTALL nodejs npm golang-go ;;
    dnf) $PKG_INSTALL nodejs npm golang ;;
    pacman) $PKG_INSTALL nodejs npm go ;;
    zypper) $PKG_INSTALL nodejs npm golang ;;
    brew) $PKG_INSTALL node go ;;
  esac
}

install_search_build() {
  case "$PKG_MANAGER" in
    apt) $PKG_INSTALL ripgrep fd-find build-essential python3-venv ;;
    dnf) $PKG_INSTALL ripgrep fd-find make gcc ;;
    pacman) $PKG_INSTALL ripgrep fd base-devel ;;
    zypper) $PKG_INSTALL ripgrep fd pattern:devel_basis ;;
    brew) $PKG_INSTALL ripgrep fd ;;
  esac
}

install_rust() {
  if command -v rustup &>/dev/null; then
    return 0
  fi

  case "$PKG_MANAGER" in
    apt|dnf|pacman|zypper)
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
      ;;
    brew)
      $PKG_INSTALL rustup-init
      rustup-init -y
      ;;
  esac

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
      local tarball="/tmp/nvim-linux-x86_64.tar.gz"

      curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz" -o "$tarball"
      sudo rm -rf /opt/nvim-linux-x86_64
      sudo tar -C /opt -xzf "$tarball"

      NVIM_BIN_DIR="/opt/nvim-linux-x86_64/bin"
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
  nvim --headless \
    "+lua vim.defer_fn(function() vim.cmd('qa!') end, 180000)" \
    2>/dev/null &
  local nvim_pid=$!

  local mason_dir="$HOME/.local/share/nvim/mason/packages"
  local seen_file
  seen_file=$(mktemp)

  local tty="/dev/stdout"
  $VERBOSE || tty="/dev/tty"

  local elapsed=0
  while kill -0 "$nvim_pid" 2>/dev/null && [ "$elapsed" -lt 210 ]; do
    sleep 2
    elapsed=$((elapsed + 2))

    if [ -d "$mason_dir" ]; then
      for pkg in "$mason_dir"/*/; do
        pkg=$(basename "$pkg")
        [ -z "$pkg" ] && continue
        grep -qxF "$pkg" "$seen_file" 2>/dev/null && continue
        echo "$pkg" >> "$seen_file"
        printf "    └─ %s\n" "$pkg" > "$tty"
      done
    fi

    printf "\r    Installing Mason packages... %ds" "$elapsed" > "$tty"
  done
  printf "\n" > "$tty"
  rm -f "$seen_file"

  wait "$nvim_pid" 2>/dev/null || true

  echo "    Mason installs initiated. Open nvim to finish any remaining."
  echo "    Check progress with:  :Mason"
}

# ──────────────────────────────────────────────
# Persist PATH and source shell config
# ──────────────────────────────────────────────
persist_path() {
  case "${SHELL##*/}" in
    zsh) RC_FILE="$HOME/.zshrc" ;;
    bash) RC_FILE="$HOME/.bashrc" ;;
    *) RC_FILE="$HOME/.profile" ;;
  esac

  local line="export PATH=\"$NVIM_BIN_DIR:\$PATH\""
  if ! grep -qF "$line" "$RC_FILE" 2>/dev/null; then
    echo "$line" >> "$RC_FILE"
    echo "Added $NVIM_BIN_DIR to PATH in $RC_FILE"
  fi
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
  fi

  echo "To use nvim in this terminal, reload your shell config:"
  echo "  source \"$RC_FILE\""

  echo ""
  printf "Total time: %s\n" "$(elapsed)"
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
run_stage "Updating package index" update_pkg_index
run_stage "Installing core tools" install_core_tools
run_stage "Installing languages" install_langs
run_stage "Installing search and build tools" install_search_build
run_stage "Installing Rust" install_rust
run_stage "Installing Neovim" install_neovim

if $INSTALL_FONT; then
  run_stage "Installing JetBrainsMono Nerd Font" install_font
fi

run_stage "Cloning nvim config" clone_config

# Ensure PATH includes nvim for subsequent steps
export PATH="$NVIM_BIN_DIR:$PATH"

run_stage "Installing Neovim plugins" install_plugins
run_stage "Installing Mason LSP packages" install_mason_packages

run_stage "Adding nvim to PATH" persist_path

print_summary
