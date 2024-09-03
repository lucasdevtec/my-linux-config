#Pomodoro
Sorry to hear you experienced this issue... If you prefer not compiling it on your system, you may download the source code for 0.22.1 https://github.com/gnome-po... and copy files from plugins/gnome/extension to /usr/share/gnome-shell/extensions/pomodoro@arun.codito.in/ . Files config.js and metadata.json need to be preserved. I'm working on providing a Flatpak, so updates will be easier in the future.

https://disq.us/url?url=https%3A%2F%2Fgithub.com%2Fgnome-pomodoro%2Fgnome-pomodoro%2Farchive%2Frefs%2Fheads%2Fgnome-42.zip%3AZZYXWpIosT70gbP_QYiEbgmXpoQ&cuid=3637432

#Ç sem funcionar
`sudo dpkg-reconfigure keyboard-configuration`
Escolha generic 105 ou 102 a depender do teclado.
Escolha a regiao do teclado
Escolha o Padrão do teclado
Siga o passo a passo
`sudo nano /etc/environment`
Adicione:

```
   GTK_IM_MODULE=cedilla
   QT_IM_MODULE=cedilla
```

Reinicie!

#Tela do LIGHTDM sem setar wallpapers e perfil personalizados
Acontece porque o LIGHTDM nao tem permisao para acessar /home
Copie os arquivos que deseja para /usr/local/share/PastaPersonalizada
