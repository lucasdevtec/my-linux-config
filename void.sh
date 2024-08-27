##Declarando Variaveis!
#Path das listas de pacotes
pkgs_path="$(pwd)/listsvoid"
# Texto do menu principal...
main_menu="Ambiente com I3 - Apenas para DEBIAN e UBUNTU
   0. Essentials
   1. Firmware - Pacontes non-free
   2. Base e utilitários do i3wm
   3. Utilitários de sistema
   4. Internet
   5. Google Chrome
   6. Multimídia
   7. Escritório
   8. Gráficos
   9. Desenvolvimento
  10. Virtualização
  11. Flatpak
$line
   G. Configuração do ambiente gráfico
   R. Reiniciar a máquina
   Q. Sair
$line
Escolha uma opção: "
#Titulo de Instalação...
main_title="$line
INSTALAR E CONFIGURAR - AMBIENTE: i3mw - RELEASE: Stable
$line"

##Declarando Funções a serem reutilizadas!
# Função de saída do script...
sair_do_script() {
    echo -e "\n\nSaindo...\n"
    exit 0
}
# Função para confirmações...
confirmar() {
    read -p "Podemos continuar (s/N)? " resp
    [[ ${resp,,} != "s" ]] && sair_do_script
    echo ""
}
# Refaz as listas de pacotes...
read_pkgs() {
    pkgs_list=$(grep -vE "^\s*#" $1 | sed '/^\s*$/d')
    pkgs_xbpsi=$(tr "\n" " " <<< $pkgs_list)
}
#Busca e instalação de pacotes...
instalar_pacotes() {
    # Monta lista de pacotes para exibição e instalação...
    read_pkgs "$pkgs_path/$1"
    # Tela de instalação...
    clear
    echo "O caminho da lista é: $pkgs_path/$1"
    echo "$main_title"
    echo -e "Os pacotes da lista '$1' serão instalados:\n"
    echo -e "$pkgs_list\n"
    read -p "Deseja editar a lista de pacotes (s/N)? " editar
    [[ ${editar,,} = "s" ]] && nano "$pkgs_path/$1" && return
    continuar
    # Executa a instalação...
    if (($?)); then
        echo "$instalando"
        sudo xbps-install -Ay $pkgs_xbpsi
        if (($?)); then
            echo -e "\n$line\nA instalação falhou!\nVerifique a lista de pacotes '$1' e tente novamente.\n$line\n"
        else
            echo -e "\n$line\nSucesso!\n$line\n"
        fi
        read -p "Tecle 'enter' para continuar... " segue
    fi
}
#Função de Configurar servidor...
desktop_settings() {
    clear
    echo -e "Esta opção aplicará as configurações do ambiente i3wm"

    mkdir -p $HOME/.local
    cp -R ./pool/bin "$HOME/.local/"

    mkdir -p $HOME/.config
    cp -R ./config/* $HOME/.config

    for f in ./home/*; do
        cp -R $f "$HOME/.${f##*/}"
    done

    echo "Criando pastas do usuário..."
    xdg-user-dirs-update

    pic_dir=$(xdg-user-dir PICTURES)
    cp -R ./pool/artwork/wallpapers "$pic_dir"

    sudo cp -R ./pool/artwork/fonts/* /usr/share/fonts/truetype/

    sudo cp -R ./pool/artwork/icons/* /usr/share/icons/

    sudo cp -R $HOME/.config/rofi/themes/* /usr/share/rofi/themes/

    sed -i "s|PIC_DIR|$pic_dir|g" $HOME/.config/nitrogen/nitrogen.cfg
    sed -i "s|PIC_DIR|$pic_dir|g" $HOME/.config/nitrogen/bg-saved.cfg
    sed -i "s/USER/$USER/g" $HOME/.gtkrc-2.0
    sudo sed -i "s/#greeter-hide-users=false/greeter-hide-users=false/" /etc/lightdm/lightdm.conf


    confirmar
}
#Função para instalar google
instalar_google() {
    clear
    echo -e "Baixando Google Chrome do proprio Google:"
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    echo -e "Instalando o Google Chrome pelo DPKG:"
    sudo dpkg -i google-chrome-stable_current_amd64.deb
}
#Instalando FLATPAK
instalar_flatpak(){
    clear
    echo -e "Instalando Flatpak:"
    sudo xbps-install -SAy install flatpak
    echo -e "Adicionando o REPO do Flatpak:"
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}
#Função de Continuar...
continuar() {
    read -p "Podemos continuar (s/N)? " resp
    [[ ${resp,,} != "s" ]]
}

##Inicio do script
#Info
clear
echo "$line
SCRIPT DE PÓS-INSTALAÇÃO DO DEBIAN E UBUNTU
$line
Antes de executar este script, verifique os requisitos abaixo:

1 - Conexão com a internet;
2 - Repositórios 'contrib' e 'non-free' habilitados e atualizados;
3 - Uma conta de usuário 'sudo'.

ATENÇÃO!

Este script foi criado para uso pessoal e não há garantia de
funcionamento em qualquer outra instalação além da minha!

Use por sua conta e risco.

Inspirado (e praticamente copiado) no script do:
Blau Araujo <blau@debxp.org>
https://debxp.org
https://gitlab.com/blau_araujo/debian-scripts
Agradeço de todo o coração por me apresenter o mundo linux que não conhecia!!!
"
confirmar

#Instalando wget e nano
echo -e "Instalando pacotes necessários: nano, wget, dpkg!"
confirmar
sudo xbps-install -Syu
sudo xbps-install -Ay nano wget dpkg
confirmar

while true; do
    clear
	echo -e "$main_menu\c"
	read option
	case $option in
        0) instalar_pacotes 00-essentials;;
	    1) instalar_pacotes 01-firmware-non-free;;
	    2) instalar_pacotes 02-base-desktop-i3wm-stable;;
	    3) instalar_pacotes 03-system-utilities;;
	    4) instalar_pacotes 04-network-stable;;
	    5) instalar_google;;
	    6) instalar_pacotes 06-multimedia-stable;;
	    7) instalar_pacotes 07-escritorio;;
	    8) instalar_pacotes 08-graficos-stable;;
	    9) instalar_pacotes 09-desenvolvimento;;
       10) instalar_pacotes 10-virtualizacao;;
       11) instalar_flatpak;;
	 [gG]) desktop_settings;;
	 [rR]) sudo reboot;;
	 [qQ]) echo -e "\nSaindo...\n"; exit 0;;
	esac
done
