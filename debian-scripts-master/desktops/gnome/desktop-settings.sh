#!/usr/bin/env bash

# Todas as receitas devem seguir estes caminhos!
path_pool=$1/pool
path_env=$1/desktops/$2


# Etapa 1 - arquivos de configuração e da home do usuário...

echo -e "\nCopiando arquivos de configuração..."

# Copia pasta .config...
cp -R $path_env/config "$HOME/.config"

# Etapa 2 - criação das pastas do usuário...

echo "Criando pastas do usuário..."
xdg-user-dirs-update

# Etapa 3 - cópia da pasta de scripts...

echo "Copiando scripts..."
mkdir -p "$HOME/.local"
cp -R $path_pool/bin "$HOME/.local/"

# Etapa 4 - Artwork

pic_dir=$(xdg-user-dir PICTURES)

echo "Copiando papéis de paredes..."
cp -R $path_pool/artwork/wallpapers "$pic_dir"

echo "Criando link dp diretório wallpapers para o diretório padrão do GNOME..."
mkdir -p $HOME/.cache/gnome-control-center
ln -s "$pic_dir/wallpapers" $HOME/.cache/gnome-control-center/backgrounds

echo "Copiando fontes..."
sudo cp -R $path_pool/artwork/fonts/* /usr/share/fonts/truetype/

echo "Copiando ícones..."
sudo cp -R $path_pool/artwork/icons/* /usr/share/icons/

# Etapa 5 - Instalando as extensões do GNOME
echo "Instalando extensões do GNOME"
sudo apt install gnome-shell-extension-appindicator gnome-shell-extension-dash-to-panel

# Etapa 6 - Configurar o NetworkManager para gerenciar as placas de rede
echo "Configurando o Network Manager..."
sudo sed -i "s/managed=false/managed=true/g" /etc/NetworkManager/NetworkManager.conf

echo -e "\nPronto!\n"

read -p "Tecle 'enter' para continuar... " segue


exit 0
