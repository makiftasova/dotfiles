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
local_zsh_config_dir="$(grep 'export.*ZSH_CONFIG_LOCAL_HOME' 'config/zsh/zshrc' | cut -d'"' -f2 | sed "s?\${HOME}?${HOME}?g")"
if [ -z "${local_zsh_config_dir}" ]; then
	# shellcheck disable=SC2016  # we don't want to expand vaiable here
	echo '$local_zsh_config_dir is empty string. please check validity of this script'
	return 255
fi
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

gpg_dir="$(grep 'export.*GNUPGHOME' 'config/zsh/env' | cut -d'"' -f2 | sed "s?\${HOME}?${HOME}?g")"
if [ -z "${gpg_dir}" ]; then
	# shellcheck disable=SC2016  # we don't want to expand vaiable here
	echo '$gpg_dir is empty string. please check validity of this script'
	return 255
fi
if ! [ -d "${gpg_dir}" ]; then
	mkdir -p "${gpg_dir}"
	chmod 700 "${gpg_dir}"
fi
unset gpg_dir

echo "done"

echo -n "Setting up local Sway config directory..."

local_sway_config_dir="${HOME}/.local/config/sway"

mkdir -p "${local_sway_config_dir}"

if ! [ -e "${local_sway_config_dir}/config" ]; then
cat << SWAYCONFIG > "${local_sway_config_dir}/config"
# use this file to setup PC specific details.
SWAYCONFIG
fi

if ! [ -e "${local_sway_config_dir}/outputs" ]; then
cat << SWAYOUTPUTS > "${local_sway_config_dir}/outputs"
# use this file to setup display outputs
SWAYOUTPUTS
fi

unset local_sway_config_dir

echo "done"

echo -n "Creating sample config for wayvnc..."

local_wayvnc_config_dir="${HOME}/.local/config/wayvnc"

mkdir -p "${local_wayvnc_config_dir}"

if ! [ -e "${local_wayvnc_config_dir}/config" ]; then
cat << WAYVNCCONFIG > "${local_wayvnc_config_dir}/config"
# only accept connections from localhost by default
# see 'man wayvnc' for details
address=localhost
WAYVNCCONFIG
fi

unset local_wayvnc_config_dir

echo "done"

echo -n "Creating local config directory for user service configs..."

local_user_service_config_dir="${HOME}/.local/config/services"

mkdir -p "${local_user_service_config_dir}"

if ! [ -e "${local_user_service_config_dir}/python-http-server.env" ]; then
cat << PYHTTPCONF > "${local_user_service_config_dir}/python-http-server.env"
PORT=80
DIRECTORY=/srv/http
PYHTTPCONF
fi

unset local_user_service_config_dir

echo "done"
