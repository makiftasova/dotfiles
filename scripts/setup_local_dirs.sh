#!/usr/bin/env bash

create_empty_file_if_not_exists () {
	if ! [ -f "$1" ]; then
		echo "creating $1"
		echo -n "" > "$1"
	fi
}

echo -n "Setting up local zsh configs..."

# create directories and files for local zsh configs.
# sed delimiter is set to "?" because "$HOME" contains "/" characters.
local_zsh_config_dir=$(grep "export.*ZSH_CONFIG_LOCAL_HOME" config/zsh/zshrc | cut -d'"' -f2 | sed "s?\${HOME}?${HOME}?g")
mkdir -p "${local_zsh_config_dir}"
create_empty_file_if_not_exists "${local_zsh_config_dir}/env"
create_empty_file_if_not_exists "${local_zsh_config_dir}/ohmyzshrc"
create_empty_file_if_not_exists "${local_zsh_config_dir}/funcs"
create_empty_file_if_not_exists "${local_zsh_config_dir}/aliases"
unset local_zsh_config_dir

echo "done"

echo -n "Setting up local neovim config..."

local_nvim_config_dir="${HOME}/.local/config/nvim"

mkdir -p "${local_nvim_config_dir}"
create_empty_file_if_not_exists "${local_nvim_config_dir}/init.vim"

unset local_nvim_config_dir

echo "done"

echo -n "Setting up local git configs..."

# create a directory for local git config
# (e.g. mail passwords, work account etc.)
local_gitconfig_dir="${HOME}/.local/config/git"
mkdir -p "${local_gitconfig_dir}"

## git user config.
if ! [ -e "${local_gitconfig_dir}/userinfo" ]; then
cat << GITUSERINFO > "${local_gitconfig_dir}/userinfo"
[user]
	name = Mehmet Akif Tasova
	email = makiftasova@gmail.com
GITUSERINFO
fi

## git local config (e.g. machine specific config)
if ! [ -e "${local_gitconfig_dir}/localconfig" ]; then
cat << GITLOCALCONF >> "${local_gitconfig_dir}/localconfig"
GITLOCALCONF
fi

## git send-email config.
if ! [ -e "${local_gitconfig_dir}/sendemail" ]; then
cat << GITSENDEMAIL > "${local_gitconfig_dir}/sendemail"
[sendemail]
	smtpserver = smtp.gmail.com
	smtpuser = makiftasova@gmail.com
	smtpencryption = tls
	smtpserverport = 587
	smtpPass =
GITSENDEMAIL
fi

unset local_gitconfig_dir

echo "done"

echo -n "Setting up GnuPG home directory..."

__gpg_dir=$(grep "export.*GNUPGHOME" config/zsh/env | cut -d'"' -f2 | sed "s?\${HOME}?${HOME}?g")
if ! [ -d "${__gpg_dir}" ]; then
	mkdir -p "${__gpg_dir}"
	chmod 700 "${__gpg_dir}"
fi
unset __gpg_dir

echo "done"
