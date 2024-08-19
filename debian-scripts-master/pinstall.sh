#!/usr/bin/env bash
# ----------------------------------------------------------
# Script   : pinstall.sh
# Descrição: Scripts de pós-instalação do Debian (stable)
# Versão   : 0.0.3
# Autor    : Blau Araujo <blau@debxp.org>
# Data     : 24/03/2020
# Licença  : GNU/GPL v3.0
# ----------------------------------------------------------
# Uso: Após clonar o git, entre na pasta do repositório
#      e digite ./pinstall.sh
# ----------------------------------------------------------

# Modo de testes...
# Descomente esta linha se estiver testando!
# testing="--dry-run"

# Detectar ambientes disponíveis...
ambs=($(ls desktops/))

# Caminho das listas de pacotes...
pi_path="$(pwd)/lists"

# Arquivo dos pacotes essenciais...
pkg_essentials="$pi_path/00-essentials"

# Lista dos pacotes essenciais para o apt...
pkg_essentials_list=$(grep -vE "^\s*#" $pkg_essentials | sed '/^\s*$/d')
pkg_essentials_apti=$(tr "\n" " " <<< $pkg_essentials_list)

# Desenha linha horizontal no tty...
cols=$(tput cols)
printf -v line "%${cols}s" " "
line=${line// /-}

# Mensagem de erro...
error_msg="
$line
A instalação falhou!
$line
Verifique sua lista de pacotes em '$pkg_essentials',
sua conexão com a rede e tente novamente.
"

# Mensagem 'instalando'...
instalando="
$line
Instalando...
$line
"

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

# Advertência...
clear

echo "$line
SCRIPT DE PÓS-INSTALAÇÃO DO DEBIAN
$line
Antes de executar este script, verifique os requisitos abaixo:

1 - Conexão com a internet;
2 - Repositórios 'contrib' e 'non-free' habilitados e atualizados;
3 - Uma conta de usuário 'sudo'.

ATENÇÃO!

Este script foi criado para uso pessoal e não há garantia de
funcionamento em qualquer outra instalação além da minha!

Use por sua conta e risco.

Blau Araujo <blau@debxp.org>
https://debxp.org
"
confirmar

# Seleção de ambiente gráfico...
clear

echo "$line
PÓS-INSTALAÇÃO - SELECIONE UM AMBIENTE GRÁFICO
$line
"

ge=(${ambs[*]} Sair...)

PS3="
Digite o número da sua opção ou '${#ge[*]}' para sair: "

select ambiente in ${ge[*]}; do
    [[ $REPLY -eq ${#ge[*]} ]] && sair_do_script || break
done

# Seleção da release stable ou unstable
clear

echo "$line
PÓS-INSTALAÇÃO - AMBIENTE: ${ambiente^^}
$line
"

PS3="
Selecione a distribuição: "

select release in stable unstable Sair...; do
    [[ $REPLY -eq 3 ]] && sair_do_script || break
done

# Verificação dos pacotes essenciais...
clear

echo "$line
VERIFICANDO SE PACOTES ESSENCIAIS ESTÃO INSTALADOS...
$line
"
instalado=1
for pkg in $pkg_essentials_apti; do
    echo -e "· Pacote '$pkg' \c"
    if dpkg -l $pkg &> /dev/null; then
        echo "instalado."
    else
        echo "não instalado!"
        instalado=0
        pkg_missing+="'$pkg' "
    fi
done

# Caso '$instalado' seja '0' (falso), continua com a instalação
# dos pacotes básicos. Se for '1' (verdadeiro), parte direto
# para o menu principal...

if (($instalado)); then
    echo -e "\n$line\nTodos os pacotes básicos já estão instalados!\n$line\n"
    read -p "Tecle 'enter' para continuar... " segue
    source main-menu.sh
    exit
else
    echo -e "\nPacotes não instalados: $pkg_missing\n"
    # Lista dos pacotes essenciais para o apt...
    pkg_essentials_list=$(sed "s/'//g; s/ /\n/; /^\s*$/d" <<< $pkg_missing)
    pkg_essentials_apti=$(tr "\n" " " <<< $pkg_essentials_list)
    read -p "Tecle 'enter' para continuar... " segue
fi

# Instalação dos pacotes essenciais...
clear

echo "$line
PÓS-INSTALAÇÃO - AMBIENTE: ${ambiente^^} - RELEASE: ${release^^}
$line

Precisamos instalar alguns pacotes essenciais para continuarmos:

$pkg_essentials_list
"

confirmar

echo "$instalando"

sudo apt install -y $testing $pkg_essentials_apti

if (($?)); then
    echo "$error_msg"
    exit 1
else
    echo -e "\n$line\nSucesso!\n$line\n"
    read -p "Tecle 'enter' para continuar... " segue
    source main-menu.sh
    exit
fi

