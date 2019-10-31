#!/usr/bin/env bash

sudo pacman -S --noconfirm --needed acpi zsh git curl neovim playerctl pamixer \
	termite termite-terminfo terminus-font gvim archlinux-wallpaper \
	terminus-font-otb xorg-fonts-alias wallutils \
	noto-fonts-{cjk,emoji,extra}

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"

# setup dotfiles
./install

# install vim-plug and plug-ins for neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
nvim +PlugInstall +qa!

# install vim-plug and olugins for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qa!
