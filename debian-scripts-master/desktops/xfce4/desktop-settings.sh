#!/usr/bin/env bash

# Todas as receitas devem seguir estes caminhos!
path_pool=$1/pool
path_env=$1/desktops/$2

# Etapa 1 - arquivos de configuração do usuário...

echo -e "\nCopiando arquivos de configuração..."

# Copia pasta .config...
mkdir -p $HOME/.config
cp -R $path_env/config/* "$HOME/.config/"

# Etapa 2 - criação das pastas do usuário...

echo "Criando pastas do usuário..."
xdg-user-dirs-update

# Etapa 3 - cópia da pastas de scripts...

echo "Copiando scripts..."
mkdir -p "$HOME/.local"
cp -R $path_pool/bin "$HOME/.local/"

# Etapa 4 - Artwork

echo "Copiando papéis de parede..."
sudo cp -r $path_pool/artwork/wallpapers /usr/share/backgrounds/

echo "Copiando fontes..."
sudo cp -r $path_pool/artwork/fonts/* /usr/share/fonts/truetype/
sudo fc-cache -f

echo "Criando imagem de usuário..."
cp $path_pool/artwork/icons/debxp-diversos/menu-places.svg $HOME/.face

echo -e "Aplicando temas de ícones..."
sudo cp -r $path_pool/artwork/icons/* /usr/share/icons/

echo -e "Atualizando cachê de ícones..."
sudo update-icon-caches /usr/share/icons/debxp-paper-folders

echo -e "Copiando temas do Rofi..."
sudo cp $path_env/config/rofi/themes/* /usr/share/rofi/themes/

# Scripts diversos

echo -e "Instalando scripts globais..."
sudo cp $path_pool/bin/desktop-indicator /usr/bin/debxp-desktop-indicator
sudo cp $path_pool/bin/rofi-launcher /usr/bin/debxp-rofi-launcher

echo "Mostrando o nome do usuário no login..."
sudo sed -i "s/#greeter-hide-users=false/greeter-hide-users=false/" /etc/lightdm/lightdm.conf

echo "Substituindo tela de bloqueio pelo gestor de login..."
sudo sed -i "s/light-locker-command --lock/dm-tool switch-to-greeter/" /usr/bin/xflock4

echo -e "Pronto!\n"

read -p "Tecle 'enter' para continuar... " segue

exit 0

