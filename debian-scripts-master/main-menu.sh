# Caminho completo até as listas de pacotes...
pkgs_path="$(pwd)/lists"

# Título comum a todas as telas...
main_title="$line
INSTALAR E CONFIGURAR - AMBIENTE: ${ambiente^^} - RELEASE: ${release^^}
$line"

# Função para continuar...
continuar() {
    read -p "Podemos continuar (s/N)? " resp
    [[ ${resp,,} != "s" ]]
}

# Refaz as listas de pacotes...
read_pkgs() {
    pkgs_list=$(grep -vE "^\s*#" $1 | sed '/^\s*$/d')
    pkgs_apti=$(tr "\n" " " <<< $pkgs_list)
}

# Tela de instalação de pacotes...
instalar_pacotes() {
    # Monta lista de pacotes para exibição e instalação...
    read_pkgs "$pkgs_path/$1"
    # Tela de instalação...
    clear
    echo "$main_title"
    echo -e "Os pacotes da lista '$1' serão instalados:\n"
    echo -e "$pkgs_list\n"
    read -p "Deseja editar a lista de pacotes (s/N)? " editar
    [[ ${editar,,} = "s" ]] && nano "$pkgs_path/$1" && return
    continuar
    # Executa a instalação...
    if (($?)); then
        echo "$instalando"
        sudo apt install -y $testing $pkgs_apti
        if (($?)); then
            echo -e "\n$line\nA instalação falhou!\nVerifique a lista de pacotes '$1' e tente novamente.\n$line\n"
        else
            echo -e "\n$line\nSucesso!\n$line\n"
        fi
        read -p "Tecle 'enter' para continuar... " segue
    fi
}

# Instala o Firefox fornecido diretamente pela Mozilla...
instalar_firefox() {
    clear
    ff_launcher="$(pwd)/pool/firefox/firefox-quantum.desktop"
    echo "$main_title"
    echo -e "Esta opção instala a última versão do Firefox diretamente da Mozilla.\n"
    continuar
    if (($?)); then
	echo "$instalando"
	wget -O firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=pt-BR"
	tar -xvf firefox.tar.bz2
	sudo mv firefox /opt/
	rm firefox.tar.bz2
	sudo ln -s /opt/firefox/firefox /usr/bin/firefox
	sudo cp $ff_launcher /usr/share/applications/
	read -p "Tecle 'enter' para continuar... " segue
    fi
}

# Instalar o Steam...
instalar_steam() {
    clear
    echo "$main_title"
    echo -e "Esta opção ativa a arquiterura i386 e instala o cliente Steam.\n"
    continuar
    if (($?)); then
	echo -e "\nInstalando Steam...\n"
	sudo dpkg --add-architecture i386
	sudo apt update
	sudo apt install steam
	read -p "Tecle 'enter' para continuar... " segue
    fi
}

# Configuração do desktop...
desktop_settings() {
    clear
    echo "$main_title"
    echo -e "Esta opção aplicará as configurações do ambiente $ambiente"
    continuar
    desktops/$ambiente/desktop-settings.sh "$(pwd)" $ambiente
}


# Texto do menu principal...
main_menu="$main_title
   1. Firmware
   2. Base e utilitários do ${ambiente^^}
   3. Utilitários de sistema
   4. Internet
   5. Firefox da Mozilla
   6. Multimídia
   7. Escritório
   8. Gráficos
   9. Desenvolvimento
  10. Virtualização
  11. Jogos
  12. Steam
$line
   G. Configuração do ambiente gráfico
   R. Reiniciar a máquina
   Q. Sair
$line
Escolha uma opção: "

while true; do
    clear
	echo -e "$main_menu\c"
	read option
	case $option in
	    1) instalar_pacotes 01-firmware-non-free;;
	    2) instalar_pacotes 02-base-desktop-$ambiente-$release;;
	    3) instalar_pacotes 03-system-utilities;;
	    4) instalar_pacotes 04-network-$release;;
	    5) instalar_firefox;;
	    6) instalar_pacotes 06-multimedia-$release;;
	    7) instalar_pacotes 07-escritorio;;
	    8) instalar_pacotes 08-graficos-$release;;
	    9) instalar_pacotes 09-desenvolvimento;;
           10) instalar_pacotes 10-virtualizacao;;
	   11) instalar_pacotes 11-jogos;;
	   12) instalar_steam;;
	 [gG]) desktop_settings $ambiente;;
	 [rR]) sudo reboot;;
	 [qQ]) echo -e "\nSaindo...\n"; exit 0;;
	esac
done
