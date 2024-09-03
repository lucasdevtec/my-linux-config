#!/bin/bash
selected=$(echo " reiniciar
 desligar
fazer logout
bloquear tela
cancelar" | rofi -dmenu -p "MENU DA SESSÃO")
[[ -z $selected ]] && exit
case $selected in
" reiniciar")reboot;;
" desligar")shutdown now;;
"fazer logout")i3-msg exit;;
"bloquear tela")dm-tool lock;;
*)echo "Nada a fazer....";; 
esac
