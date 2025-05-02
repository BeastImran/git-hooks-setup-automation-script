#!/usr/bin/env bash

# This script extends git init to automatically set up pre-commit hooks with colorful output
# Save this as ~/.git-init-hook.sh and make it executable (chmod +x ~/.git-init-hook.sh)

# Define colors and styling
BOLD="\033[1m"
RESET="\033[0m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
MAGENTA="\033[0;35m"

# Function to print section headers
print_header() {
    echo -e "\n${BOLD}${MAGENTA}====== 🚀 $1 ======${RESET}\n"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}✅ $1${RESET}"
}

# Function to print info messages
print_info() {
    echo -e "${BLUE}ℹ️  $1${RESET}"
}

# Function to print warning messages
print_warning() {
    echo -e "${YELLOW}⚠️  $1${RESET}"
}

# Function to print error messages
print_error() {
    echo -e "${RED}❌ $1${RESET}"
}

# Function to print commands
print_cmd() {
    echo -e "\n\n${CYAN}$ $1${RESET}\n\n"
}

# Create a git alias for init that runs this script
setup_git_alias() {
    print_header "Setting Up Git Alias"

    # Check if the alias already exists
    if ! git config --global alias.custom-init >/dev/null 2>&1; then
        git config --global alias.custom-init '!git init "$@" && ~/.git-init-hook.sh init'
        print_success "Git alias 'custom-init' has been created!"
        print_info "Use ${BOLD}git custom-init${RESET}${BLUE} instead of ${BOLD}git init${RESET}${BLUE} to initialize repositories with the pre-commit setup."
    else
        print_info "Git alias 'custom-init' already exists."
    fi
}

# Function to create the pre-commit config file
create_pre_commit_config() {
    print_header "Creating Pre-commit Configuration"

    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [ -z "$git_root" ]; then
        print_error "Not in a git repository."
        return 1
    fi

    # Create the pre-commit config file
    cat >"$git_root/.pre-commit-config.yaml" <<'EOF'
# See https://pre-commit.com for more information
# See https://pre-commit.com/hooks.html for more hooks
repos:
- repo: https://github.com/pre-commit/pre-commit-hooks
  rev: v5.0.0
  hooks:
  - id: trailing-whitespace
  - id: end-of-file-fixer
  - id: check-symlinks
  - id: check-yaml
  - id: check-added-large-files
    args: [ "--maxkb=5000" ]
  - id: check-case-conflict
  - id: check-json
  - id: pretty-format-json
    args: [ --autofix ]
  - id: detect-aws-credentials
    args: [ --allow-missing-credentials ]
  - id: detect-private-key
  - id: check-shebang-scripts-are-executable

- repo: https://github.com/gitleaks/gitleaks
  rev: 'v8.25.1'
  hooks:
  - id: gitleaks

- repo: https://github.com/thoughtworks/talisman
  rev: 'v1.36.0'
  hooks:
  - id: talisman-commit
  - id: talisman-push

- repo: https://github.com/shellcheck-py/shellcheck-py
  rev: 'v0.10.0.1'
  hooks:
  - id: shellcheck

- repo: local
  hooks:
  - id: local-biome-check
    name: biome check
    entry: biome check --files-ignore-unknown=true --no-errors-on-unmatched
    language: system
    types: [ text ]
    files: "\\.(jsx?|tsx?|c(js|ts)|m(js|ts)|d\\.(ts|cts|mts)|svelte|vue|astro|graphql|gql)$"

- repo: local
  hooks:
  - id: trufflehog
    name: TruffleHog
    description: Detect secrets in your data.
    entry: bash -c 'trufflehog git file://. --since-commit HEAD --results=verified,unknown --fail'
    language: system
    stages: [ "pre-commit", "pre-push" ]

EOF

    print_success "Created .pre-commit-config.yaml in $git_root 📄"
    return 0
}

# Function to run pre-commit
run_pre_commit() {
    print_header "Setting Up Pre-commit Hooks"

    if ! command -v brew &>/dev/null; then
        print_warning "brew is not installed!. Know more about brew here: https://brew.sh/"
        print_cmd "/bin/bash -c '\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'"

        echo -n -e "${BOLD}Proceed to install brew right now with above command (y/N)?${RESET}: "
        read -r -n 3 brew_answer

        case ${brew_answer:0:1} in
            y|Y|yes|Yes )
                print_info "You have selected yes. Proceeding with installing Brew..."
                /usr/bin/env bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            ;;
            * )
                print_error "Not proceeding further with this script.... EXITING"
                exit 1
            ;;
        esac
        print_cmd "/bin/bash -c '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'"
        return 1
    fi

    if ! command -v pre-commit &>/dev/null; then
        print_warning "pre-commit is not installed! Know more about pre-commit here: https://pre-commit.com/"
        print_cmd "brew install pre-commit"

        echo -n -e "${BOLD}Proceed to install pre-commit right now with above command (y/N)?${RESET}: "
        read -r -n 3 brew_answer

        case ${brew_answer:0:1} in
            y|Y|yes|Yes )
                print_info "You have selected yes. Proceeding with installing Brew..."
                brew install pre-commit
            ;;
            * )
                print_error "Not proceeding further with this script.... EXITING"
                exit 1
            ;;
        esac
        print_cmd "/bin/bash -c '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'"
        return 1
    fi

    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)

    if [ -z "$git_root" ]; then
        print_error "Not in a git repository."
        return 1
    fi

    cd "$git_root" || exit 1
    print_info "Installing common tools required using brew package manager for MacOS... 🔄"
    brew install biome trufflehog shellcheck

    print_info "Installing pre-commit hooks into this local repository... 🔄"
    pre-commit install

    print_info "Running pre-commit on all files... 🔍"

    if pre-commit run --all-files; then
        print_success "Pre-commit setup completed successfully! 🎉"
    else
        print_warning "Pre-commit ran with some issues. Please check the output above. 🔧"
    fi

    return 0
}

# Function to display a welcome banner
display_banner() {
    echo -e "${BOLD}${CYAN}"
    echo -e "╔═══════════════════════════════════════════════════════════╗"
    echo -e "║                                                           ║"
    echo -e "║   🚀 Git Init Hook - Pre-commit Automation Tool 🚀        ║"
    echo -e "║                                                           ║"
    echo -e "╚═══════════════════════════════════════════════════════════╝${RESET}"
}

# Main function
main() {
    display_banner

    # Check if we're in a git repository
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        print_error "This script should be run inside a git repository! 🚫"
        print_info "Please run 'git init' first, then run this script."
        echo -e "\n${BOLD}${RED}❌ Setup failed! Not in a git repository. ❌${RESET}\n"
        return 1
    fi

    # Create the pre-commit config
    create_pre_commit_config
    config_status=$?

    # Run pre-commit
    run_pre_commit
    precommit_status=$?

    # Check if both operations were successful
    if [ $config_status -eq 0 ] && [ $precommit_status -eq 0 ]; then
        echo -e "\n${BOLD}${GREEN}✨ All done! Your repository is now setup with pre-commit hooks! ✨${RESET}"
        echo -e "${BLUE}Happy coding! 😊${RESET}\n"
    else
        echo -e "\n${BOLD}${YELLOW}⚠️ Setup partially completed with some issues. Git hooks may not work as expected. Please check the messages above, fix and re-run the script. ⚠️${RESET}\n"
    fi

    return 0
}

# If this script is being run directly (not through the alias). i.e no argument
if [ -z "$1"  ]; then
    # Setup the git alias (comment/uncomment based on your preference)
    setup_git_alias
    exit $?
elif [[ $1 == "init" ]]; then
    # If this script is being run with custom-init
    main
else
    print_error "Invalid argument(s) passed\n"
fi
