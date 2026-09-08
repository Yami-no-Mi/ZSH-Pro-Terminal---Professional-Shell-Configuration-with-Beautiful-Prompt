#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════╗
# ║  ZSH Pro Terminal - Automated Setup Script                    ║
# ║  This script will set up your terminal in 2 minutes!          ║
# ╚═══════════════════════════════════════════════════════════════╝

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "${MAGENTA}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC} $1"
    echo -e "${MAGENTA}╚═══════════════════════════════════════════════════╝${NC}"
}

print_step() {
    echo -e "${BLUE}▶${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if ZSH is installed
check_zsh() {
    if ! command -v zsh &> /dev/null; then
        print_error "ZSH is not installed"
        print_step "Installing ZSH..."
        sudo apt update
        sudo apt install -y zsh
        print_success "ZSH installed"
    else
        print_success "ZSH is installed"
    fi
}

# Check if Oh My Zsh is installed
check_omz() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_step "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed"
    else
        print_success "Oh My Zsh is already installed"
    fi
}

# Install plugins
install_plugins() {
    print_step "Installing ZSH plugins..."
    
    ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
    
    # zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
        print_success "zsh-autosuggestions installed"
    else
        print_success "zsh-autosuggestions already installed"
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
        print_success "zsh-syntax-highlighting installed"
    else
        print_success "zsh-syntax-highlighting already installed"
    fi
    
    # zsh-completions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
        print_success "zsh-completions installed"
    else
        print_success "zsh-completions already installed"
    fi
}

# Install fonts
install_fonts() {
    print_step "Installing recommended fonts..."
    sudo apt update
    sudo apt install -y fonts-fira-code fonts-cascadia-code fonts-jetbrains-mono 2>/dev/null || true
    print_success "Fonts installed"
    print_warning "⚠ Please change your terminal font manually:"
    echo -e "   ${BLUE}Terminal → Preferences → Text → Font${NC}"
    echo -e "   ${BLUE}Select: Fira Code, JetBrains Mono, or Cascadia Code${NC}"
}

# Copy configuration
copy_config() {
    print_step "Setting up ZSH configuration..."
    
    # Backup existing .zshrc
    if [ -f ~/.zshrc ]; then
        cp ~/.zshrc ~/.zshrc.backup
        print_success "Backed up existing .zshrc to ~/.zshrc.backup"
    fi
    
    # Check if .zshrc exists in current directory
    if [ -f ".zshrc" ]; then
        cp .zshrc ~/.zshrc
        print_success "Copied .zshrc to home directory"
    else
        print_error ".zshrc not found in current directory"
        return 1
    fi
    
    # Copy starship config if exists
    if [ -f "starship.toml" ]; then
        mkdir -p ~/.config/starship
        cp starship.toml ~/.config/starship/starship.toml
        print_success "Copied starship.toml configuration"
    fi
}

# Set ZSH as default shell
set_default_shell() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_step "Setting ZSH as default shell..."
        chsh -s $(which zsh)
        print_success "ZSH is now your default shell"
        print_warning "Please close and reopen your terminal"
    else
        print_success "ZSH is already your default shell"
    fi
}

# Main installation flow
main() {
    clear
    print_header "ZSH Pro Terminal Configuration"
    echo ""
    echo "This script will set up a beautiful ZSH terminal with:"
    echo "  ✓ Custom 2-line prompt"
    echo "  ✓ Git integration"
    echo "  ✓ 50+ useful aliases"
    echo "  ✓ Smart plugins"
    echo ""
    read -p "Continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Setup cancelled"
        exit 0
    fi
    
    echo ""
    
    # Run setup steps
    check_zsh
    echo ""
    
    check_omz
    echo ""
    
    install_plugins
    echo ""
    
    read -p "Install fonts? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_fonts
        echo ""
    fi
    
    copy_config
    echo ""
    
    set_default_shell
    echo ""
    
    # Final message
    echo ""
    print_header "Setup Complete! 🎉"
    echo ""
    echo -e "${GREEN}Your terminal is now configured!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Close and reopen your terminal"
    echo "  2. Change your terminal font (if you installed fonts)"
    echo "  3. Start using your new aliases!"
    echo ""
    echo "Useful commands to try:"
    echo -e "  ${BLUE}gs${NC}              - git status"
    echo -e "  ${BLUE}gaa${NC}             - git add ."
    echo -e "  ${BLUE}gc 'message'${NC}    - git commit"
    echo -e "  ${BLUE}nr${NC}              - npm run"
    echo -e "  ${BLUE}create_branch${NC}   - create git branch"
    echo ""
    echo "Documentation: https://github.com/yourusername/zsh-pro-terminal"
    echo ""
}

# Run main function
main
