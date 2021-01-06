#!/usr/bin/env bash

create_empty_file_if_not_exists () {
	if ! [ -f "$1" ]; then
		echo "creating $1"
		echo -n "" > "$1"
	fi
}

vim_plug_install_to_dir () {
	curl -fLo "$1" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

# install dependencies
echo "Installing dependencies..."
sudo pacman -S --noconfirm --needed acpi zsh git curl neovim playerctl pamixer \
	cscope perl-authen-sasl perl-net-smtp-ssl perl-mime-tools \
	termite termite-terminfo terminus-font gvim archlinux-wallpaper \
	lm_sensors terminus-font-otb xorg-fonts-alias wallutils \
	nvme-cli hddtemp udisks2 smartmontools noto-fonts-{cjk,emoji,extra} \
	wl-clipboard xclip xsel bash-completion ctags fzf ripgrep pkgfile

echo "Update pkgfile db"
sudo pkgfile --update

# install oh-my-zsh and plug-ins
echo "installing oh-my-zsh and plug-ins..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "installing zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

echo "installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"

# detect HW sensors
echo "detecting hardware sensors..."
yes | sudo sensors-detect

# setup dotfiles
echo "installing dotfiles..."
./install

# create directories and files for local zsh configs.
# sed delimiter is set to "?" because "$HOME" contains "/" characters.
local_zsh_config_dir=$(grep "export.*ZSH_CONFIG_LOCAL_HOME" config/zsh/zshrc | cut -d'"' -f2 | sed "s?\$HOME?$HOME?g")
mkdir -p "$local_zsh_config_dir"
create_empty_file_if_not_exists "$local_zsh_config_dir/zsh_env"
create_empty_file_if_not_exists "$local_zsh_config_dir/ohmyzshrc"
create_empty_file_if_not_exists "$local_zsh_config_dir/zsh_funcs"
create_empty_file_if_not_exists "$local_zsh_config_dir/zsh_aliases"

# change user shell to zsh
echo "changing user's shell to zsh..."
chsh -s /usr/bin/zsh

# create local rc files for vim and nvim
local_config_dir="$HOME/.local/config"
mkdir -p "${local_config_dir}"
mkdir -p "${local_config_dir}/vim"
mkdir -p "${local_config_dir}/nvim"

create_empty_file_if_not_exists "${local_config_dir}/vim/init.vim"
create_empty_file_if_not_exists "${local_config_dir}/nvim/init.vim"

# install vim-plug and plug-ins for neovim
echo "installing vim-plug and plungins for neovim..."
vim_plug_install_to_dir "$HOME/.local/share/nvim/site/autoload/plug.vim"
nvim +PlugInstall +qa!

# install vim-plug and olugins for vim
echo "installing vim-plug and plungins for vim..."
vim_plug_install_to_dir "$HOME/.vim/autoload/plug.vim"
vim +PlugInstall +qa!

# create a directory for local git config
# (e.g. mail passwords, work account etc.)
echo "setup local git configs..."
local_gitconfig_dir="$HOME/.config/git"
mkdir -p "$local_gitconfig_dir"

## git user config.
if ! [ -e "$local_gitconfig_dir/gituserinfo" ]; then
cat << GITUSERINFO > "$local_gitconfig_dir/gituserinfo"
[user]
	name = Mehmet Akif Tasova
	email = makiftasova@gmail.com
GITUSERINFO
fi

## git local config (e.g. machine specific config)
if ! [ -e "$local_gitconfig_dir/gitlocalconfig" ]; then
cat << GITLOCALCONF >> "$local_gitconfig_dir/gitlocalconfig"
GITLOCALCONF
fi

## git send-email config.
if ! [ -e "$local_gitconfig_dir/gitsendemail" ]; then
cat << GITSENDEMAIL > "$local_gitconfig_dir/gitsendemail"
[sendemail]
	smtpserver = smtp.gmail.com
	smtpuser = makiftasova@gmail.com
	smtpencryption = tls
	smtpserverport = 587
	smtpPass =
GITSENDEMAIL
fi

echo "now logout and log back in in order to use your new shell"
