#!/usr/bin/env bash

# create a directory for local git config (e.g. mail passwords, work account etc.)
gitsendemail_dir="$HOME/.config/git"
mkdir -p "$gitsendemail_dir"

cat << GITSENDEMAIL > "$gitsendemail_dir/gitsendemail"
[sendemail]
	smtpserver = smtp.gmail.com
	smtpuser = makiftasova@gmail.com
	smtpencryption = tls
	smtpserverport = 587
	smtpPass =
GITSENDEMAIL

# install dependencies
sudo pacman -S --noconfirm --needed acpi zsh git curl neovim playerctl pamixer \
	perl-authen-sasl perl-net-smtp-ssl perl-mime-tools \
	termite termite-terminfo terminus-font gvim archlinux-wallpaper \
	lm_sensors terminus-font-otb xorg-fonts-alias wallutils \
	nvme-cli hddtemp udisks2 smartmontools noto-fonts-{cjk,emoji,extra}

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"

# detect HW sensors
yes | sudo sensors-detect

# setup dotfiles
./install

# change user shell to zsh
chsh -s /usr/bin/zsh

# install vim-plug and plug-ins for neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qa!

# install vim-plug and olugins for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qa!

echo "now logout and log back in in order to use your new shell"
