#!/usr/bin/env bash

create_empty_file_if_not_exists () {
	if ! [ -f "$1" ]; then
		echo "creating $1"
		echo -n "" > "$1"
	fi
}

# install dependencies
echo "Installing dependencies..."
sudo pacman -S --noconfirm --needed acpi zsh git curl neovim playerctl pamixer \
	perl-authen-sasl perl-net-smtp-ssl perl-mime-tools \
	termite termite-terminfo terminus-font gvim archlinux-wallpaper \
	lm_sensors terminus-font-otb xorg-fonts-alias wallutils \
	nvme-cli hddtemp udisks2 smartmontools noto-fonts-{cjk,emoji,extra}

# install oh-my-zsh
echo "installing oh-my-zsh and plug-ins..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"

# detect HW sensors
echo "detecting hardware sensors..."
yes | sudo sensors-detect

# setup dotfiles
echo "installing dotfiles..."
./install

local_zsh_config_dir=$(grep "ZSH_CONFIG_LOCAL_HOME" config/zsh/zshrc | cut -d'"' -f2 | sed "s?\$HOME?$HOME?g")
mkdir -p "$local_zsh_config_dir"
create_empty_file_if_not_exists "$local_zsh_config_dir/zsh_env"
create_empty_file_if_not_exists "$local_zsh_config_dir/ohmyzshrc"
create_empty_file_if_not_exists "$local_zsh_config_dir/zsh_funcs"
create_empty_file_if_not_exists "$local_zsh_config_dir/zsh_aliases"

# change user shell to zsh
echo "changing user's shell to zsh..."
chsh -s /usr/bin/zsh

# install vim-plug and plug-ins for neovim
echo "installing vim-plug and plungins for neovim..."
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qa!

# install vim-plug and olugins for vim
echo "installing vim-plug and plungins for vim..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qa!

# create a directory for local git config
# (e.g. mail passwords, work account etc.)
echo "setup local git configs..."
local_gitconfig_dir="$HOME/.config/git"
mkdir -p "$local_gitconfig_dir"

if ! [ -e "$local_gitconfig_dir/gituserinfo" ]; then
cat << GITUSERINFO > "$local_gitconfig_dir/gituserinfo"
[user]
	name = Mehmet Akif Tasova
	email = makiftasova@gmail.com
GITUSERINFO
fi

if ! [ -e "$local_gitconfig_dir/gitlocalconfig" ]; then
cat << GITLOCALCONF >> "$local_gitconfig_dir/gitlocalconfig"
GITLOCALCONF
fi

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
