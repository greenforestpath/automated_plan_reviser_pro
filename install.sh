#!/usr/bin/env bash
#
# APR (Automated Plan Reviser Pro) Installer
# Downloads and installs APR to your system
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/automated_plan_reviser_pro/main/install.sh | bash
#
# Options (via environment variables):
#   DEST=/path/to/dir      Install directory (default: ~/.local/bin)
#   APR_SYSTEM=1           Install to /usr/local/bin (requires sudo)
#   APR_NO_DEPS=1          Skip dependency installation
#   APR_VERSION=x.y.z      Install specific version (default: latest from main)
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# Configuration
REPO_OWNER="Dicklesworthstone"
REPO_NAME="automated_plan_reviser_pro"
REPO_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/main"
SCRIPT_NAME="apr"

log_info() { echo -e "${GREEN}[apr]${NC} $1" >&2; }
log_warn() { echo -e "${YELLOW}[apr]${NC} $1" >&2; }
log_error() { echo -e "${RED}[apr]${NC} $1" >&2; }
log_step() { echo -e "${BLUE}[apr]${NC} $1" >&2; }

download_file() {
    local url="$1"
    local out="$2"

    if command -v curl &> /dev/null; then
        curl -fsSL "$url" -o "$out" || return 1
    elif command -v wget &> /dev/null; then
        wget -qO "$out" "$url" || return 1
    else
        log_error "Neither curl nor wget found. Please install one of them."
        return 127
    fi
}

get_install_dir() {
    if [[ -n "${DEST:-}" ]]; then
        echo "$DEST"
    elif [[ -n "${APR_SYSTEM:-}" ]]; then
        echo "/usr/local/bin"
    else
        echo "${HOME}/.local/bin"
    fi
}

get_shell_config() {
    local shell_name
    shell_name=$(basename "${SHELL:-/bin/bash}")

    case "$shell_name" in
        zsh) echo "${HOME}/.zshrc" ;;
        bash)
            if [[ -f "${HOME}/.bashrc" ]]; then
                echo "${HOME}/.bashrc"
            elif [[ -f "${HOME}/.bash_profile" ]]; then
                echo "${HOME}/.bash_profile"
            else
                echo "${HOME}/.bashrc"
            fi
            ;;
        fish) echo "${HOME}/.config/fish/config.fish" ;;
        *) echo "${HOME}/.bashrc" ;;
    esac
}

add_to_path() {
    local install_dir="$1"
    local shell_config="$2"
    local shell_name
    shell_name=$(basename "${SHELL:-/bin/bash}")

    [[ ":$PATH:" == *":${install_dir}:"* ]] && return 0

    if [[ -f "$shell_config" ]] && grep -qF "$install_dir" "$shell_config" 2>/dev/null; then
        log_info "PATH entry already in $shell_config"
        return 0
    fi

    local config_dir
    config_dir=$(dirname "$shell_config")
    [[ ! -d "$config_dir" ]] && mkdir -p "$config_dir"

    local path_line
    if [[ "$shell_name" == "fish" ]]; then
        path_line="fish_add_path ${install_dir}"
    else
        path_line="export PATH=\"${install_dir}:\$PATH\""
    fi

    {
        echo ""
        echo "# Added by APR installer"
        echo "$path_line"
    } >> "$shell_config"

    log_info "Added ${install_dir} to PATH in ${shell_config}"
}

install_gum() {
    if command -v gum &> /dev/null; then
        log_info "gum already installed"
        return 0
    fi

    log_step "Installing gum (beautiful CLI output)..."

    local os="unknown"
    case "$(uname -s)" in
        Darwin*) os="macos" ;;
        Linux*)  os="linux" ;;
    esac

    case "$os" in
        macos)
            if command -v brew &> /dev/null; then
                brew install gum &>/dev/null && return 0
            fi
            ;;
        linux)
            if command -v apt-get &> /dev/null; then
                (
                    sudo mkdir -p /etc/apt/keyrings 2>/dev/null
                    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg 2>/dev/null
                    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list >/dev/null
                    sudo apt-get update -qq && sudo apt-get install -y -qq gum
                ) &>/dev/null && return 0
            elif command -v dnf &> /dev/null; then
                (
                    echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo >/dev/null
                    sudo dnf install -y gum
                ) &>/dev/null && return 0
            elif command -v pacman &> /dev/null; then
                sudo pacman -S --noconfirm gum &>/dev/null && return 0
            fi

            # Fallback: GitHub releases
            local arch
            arch=$(uname -m)
            case "$arch" in
                x86_64) arch="amd64" ;;
                aarch64|arm64) arch="arm64" ;;
                *) log_warn "Unsupported architecture for gum: $arch"; return 1 ;;
            esac

            local tmp_dir gum_version="0.14.5"
            tmp_dir=$(mktemp -d)
            local gum_url="https://github.com/charmbracelet/gum/releases/download/v${gum_version}/gum_${gum_version}_Linux_${arch}.tar.gz"

            (
                cd "$tmp_dir"
                curl -fsSL "$gum_url" -o gum.tar.gz
                tar -xzf gum.tar.gz
                sudo mv gum /usr/local/bin/gum 2>/dev/null || {
                    mkdir -p ~/.local/bin
                    mv gum ~/.local/bin/gum
                }
            ) &>/dev/null && rm -rf "$tmp_dir" && return 0

            rm -rf "$tmp_dir"
            ;;
    esac

    log_warn "Could not install gum automatically (APR will fall back to ANSI colors)"
    return 1
}

install_oracle() {
    if command -v oracle &> /dev/null; then
        log_info "Oracle already installed: $(oracle --version 2>/dev/null | head -1)"
        return 0
    fi

    log_step "Checking Oracle availability..."

    if command -v npx &> /dev/null; then
        log_info "Oracle available via npx"
        log_info "For faster execution, install globally: npm install -g @steipete/oracle"
        return 0
    fi

    if command -v npm &> /dev/null; then
        log_step "Installing Oracle globally..."
        npm install -g @steipete/oracle && return 0
    fi

    log_warn "Oracle not installed. APR requires Oracle for GPT Pro reviews."
    log_warn "Install Node.js and run: npm install -g @steipete/oracle"
    return 1
}

main() {
    echo "" >&2
    echo -e "${BOLD}${MAGENTA}╔════════════════════════════════════════════════════════════════╗${NC}" >&2
    echo -e "${BOLD}${MAGENTA}║${NC}  ${BOLD}  Automated Plan Reviser Pro${NC}                                ${BOLD}${MAGENTA}║${NC}" >&2
    echo -e "${BOLD}${MAGENTA}║${NC}  ${DIM}Iterative AI-Powered Spec Refinement${NC}                         ${BOLD}${MAGENTA}║${NC}" >&2
    echo -e "${BOLD}${MAGENTA}╚════════════════════════════════════════════════════════════════╝${NC}" >&2
    echo "" >&2

    local install_dir shell_config
    install_dir=$(get_install_dir)
    shell_config=$(get_shell_config)
    local script_path="${install_dir}/${SCRIPT_NAME}"

    log_step "Install directory: ${install_dir}"
    log_step "Shell config: ${shell_config}"

    # Create install directory
    if [[ ! -d "$install_dir" ]]; then
        log_info "Creating directory: ${install_dir}"
        mkdir -p "$install_dir"
    fi

    # Check if we need sudo
    local use_sudo=""
    if [[ ! -w "$install_dir" ]]; then
        if command -v sudo &> /dev/null; then
            use_sudo="sudo"
            log_warn "Using sudo for installation to ${install_dir}"
        else
            log_error "Cannot write to ${install_dir} and sudo not available"
            exit 1
        fi
    fi

    # Download APR
    log_step "Downloading APR..."
    local tmp_file
    tmp_file=$(mktemp)
    if ! download_file "${REPO_URL}/${SCRIPT_NAME}" "$tmp_file"; then
        log_error "Failed to download APR"
        rm -f "$tmp_file"
        exit 1
    fi

    # Install APR
    log_step "Installing to ${script_path}..."
    $use_sudo mv "$tmp_file" "$script_path"
    $use_sudo chmod +x "$script_path"

    # Add to PATH
    add_to_path "$install_dir" "$shell_config"

    # Install dependencies (unless disabled)
    if [[ -z "${APR_NO_DEPS:-}" ]]; then
        echo "" >&2
        log_step "Installing dependencies..."
        install_gum || true
        install_oracle || true
    fi

    # Verify installation
    if [[ -x "$script_path" ]]; then
        echo "" >&2
        log_info "Installation complete!"
        echo "" >&2
        echo -e "${BOLD}What APR Does:${NC}" >&2
        echo -e "  ${GREEN}1.${NC} Bundle your docs (README, spec, implementation)" >&2
        echo -e "  ${GREEN}2.${NC} Send to GPT Pro 5.2 with Extended Reasoning" >&2
        echo -e "  ${GREEN}3.${NC} Capture detailed revision suggestions" >&2
        echo -e "  ${GREEN}4.${NC} Track multiple rounds of refinement" >&2
        echo "" >&2
        echo -e "${BOLD}Quick Start:${NC}" >&2
        echo "" >&2

        if [[ ":$PATH:" != *":${install_dir}:"* ]]; then
            echo -e "  ${BOLD}1. Reload your shell:${NC}" >&2
            echo -e "     source ${shell_config}" >&2
            echo "" >&2
            echo -e "  ${BOLD}2. Run the setup wizard:${NC}" >&2
        else
            echo -e "  ${BOLD}Run the setup wizard:${NC}" >&2
        fi

        echo -e "     ${CYAN}apr setup${NC}" >&2
        echo "" >&2
        echo -e "  ${BOLD}Then start your first revision:${NC}" >&2
        echo -e "     ${CYAN}apr run 1${NC}" >&2
        echo "" >&2
        echo -e "${YELLOW}First run will require ChatGPT login via browser${NC}" >&2
        echo "" >&2
    else
        log_error "Installation failed - script not executable"
        exit 1
    fi
}

main "$@"
