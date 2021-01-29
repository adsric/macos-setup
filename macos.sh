#!/usr/bin/env sh

################################################################################
# ERROR: Let the user know if the script fails
################################################################################

trap 'ret=$?; test $ret -ne 0 && printf "\n   \e[31m\033[0m  Setup failed  \e[31m\033[0m\n" >&2; exit $ret' EXIT

set -e

################################################################################
# FUNC: Check for required functions file
################################################################################

if [ -e functions.sh ]; then
	source functions.sh
else
	printf "\n ⚠️  ./functions.sh not found! \n"
	exit 1
fi

################################################################################
# Get in Setup!          http://patorjk.com/software/taag/ ( font: Script )
################################################################################

printf "

            ()
            /\  _ _|_          _
           /  \|/  |  |   |  |/ \_
          /(__/|__/|_/ \_/|_/|__/
 -------------------------- /| -----------------------
   [for macOS 11.1]         \|
 ╭───────────────────────────────────────────────────╮
 │  Okay developers the macOS setup has ${bold}started!${normal}.    │
 │───────────────────────────────────────────────────│
 │  Safe to run multiple times on the same machine.  │
 │  It ${green}installs${reset}, ${blue}upgrades${reset}, or ${yellow}skips${reset} packages based   │
 │  on what is already installed on the machine.     │
 ╰───────────────────────────────────────────────────╯
   ${dim}$(get_os) $(get_os_version) ${normal}
"

################################################################################
# CHECK: Internet
################################################################################

chapter "Checking internet connection…"
check_internet_connection

################################################################################
# PROMPT: Password
################################################################################

chapter "Caching password…"
ask_for_sudo

################################################################################
# PROMPT: SSH Key
################################################################################

chapter 'Checking for SSH key…'
ssh_key_setup

################################################################################
# INSTALL: Dependencies
################################################################################

chapter "Installing Dependencies…"

# ------------------------------------------------------------------------------
# XCode
# ------------------------------------------------------------------------------

if [ xcode_tools_is_installed ]; then
	print_success_muted "Xcode already installed. Skipping."
else
	step "Installing Xcode…"
	xcode-select --install &> /dev/null
	print_success "Xcode installed!"
fi

# ------------------------------------------------------------------------------
# Homebrew
# ------------------------------------------------------------------------------

if ! [ -x "$(command -v brew)" ]; then
	step "Installing Homebrew…"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	export PATH="/usr/local/bin:$PATH"
	print_success "Homebrew installed!"
else
	print_success_muted "Homebrew already installed. Skipping."
fi

# ------------------------------------------------------------------------------
# NVM
# ------------------------------------------------------------------------------

if [ ! -d "$NVM_DIRECTORY" ]; then
	step "Installing NVM…"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
	command printf "$NVM_SOURCE_PATH" >> "$HOME/.path"
	command printf "$NVM_COMPLETION_PATH" >> "$HOME/.path"
	. $HOME/.path
	print_success "NVM installed!"
	step "Installing latest Node…"
	nvm install node
	nvm use node
	nvm run node --version
	nodev=$(node -v)
	print_success "Using Node $nodev!"
else
	print_success_muted "NVM/Node already installed. Skipping."
fi

################################################################################
# INSTALL: brews
################################################################################

if [ -e $cwd/install/brews ]; then
	chapter "Installing Homebrew formulae…"

	for brew in $(<$cwd/install/brews); do
		install_brews $brew
	done
fi

################################################################################
# UPDATE: Homebrew
################################################################################

chapter "Updating Homebrew formulae…"
brew update

################################################################################
# INSTALL: casks
################################################################################

if [ -e $cwd/install/casks ]; then
	chapter "Installing apps via Homebrew…"

	for cask in $(<$cwd/install/casks); do
		install_casks $cask
	done
fi

################################################################################
# INSTALL: Mac App Store Apps
################################################################################

chapter "Installing apps from App Store…"
if [ -x mas ]; then

	print_warning "Please install mas-cli first: brew mas. Skipping."

	else

	if [ -e $cwd/install/apps ]; then
		if mas_setup; then
			# Workaround for associative array in Bash 3
			# https://stackoverflow.com/questions/6047648/bash-4-associative-arrays-error-declare-a-invalid-option
			for app in $(<$cwd/install/apps); do
				KEY="${app%%::*}"
				VALUE="${app##*::}"
				install_application_via_app_store $KEY $VALUE
			done
		else
			print_warning "Please signin to App Store first. Skipping."
		fi
	fi

fi

################################################################################
# CLEAN: Homebrew files
################################################################################

chapter "Cleaning up Homebrew files…"
brew cleanup 2> /dev/null

################################################################################
# INSTALL: npm packages
################################################################################

if [ -e $cwd/install/npm ]; then
	chapter "Installing npm packages…"

	for pkg in $(<$cwd/install/npm); do
		KEY="${pkg%%::*}"
		VALUE="${pkg##*::}"
		install_npm_packages $KEY $VALUE
	done
fi

################################################################################
# CONFIGURATION: macOS configuration
################################################################################

chapter "Configure macOS…"

step " macOS preferences…"
if [ -f $cwd/preferences.sh ]; then
	if ask "Do you want to apply preferences?" Y; then
		. "$cwd/preferences.sh"; printf "\n  You're preferences have been updated. 🔥 \n";
	else
		print_success_muted "Preferences declined. Skipped.";
	fi
else
	print_warning "No preferences found. Skipping."
fi

################################################################################
# SYMLINK: symbolic link of files
################################################################################

chapter "Symbolic Link of files to root…"

symlink_files

################################################################################
# 🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋🍋
################################################################################
e_message
