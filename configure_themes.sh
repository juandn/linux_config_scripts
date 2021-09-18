#!/bin/bash

###
### Variables de configuración
### 

appTheme='Sweet-mars'
iconSet='Papirus-Dark'
gnomeShell='Sweet-mars'

wallpaper="abst-orange"

###
### Variables sistema
###
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

function installPapirus {
  echo "Instalando iconos..."
  sudo apt install papirus-icon-theme
  echo "Done."
  echo "Instalando papirus-folders app..."
  wget -qO- https://git.io/papirus-folders-install | sh
  echo "Done."
  echo "Configurando colores..."
  papirus-folders -C yaru --theme $iconSet
  echo "Done."
  echo "Configurando el set de iconos..."
  gsettings set org.gnome.desktop.interface icon-theme $iconSet
  echo "Done."
}

function installSweet-mars {
  echo "Creando el directorio de temas si no existe..."
  if [[ ! -d $HOME/.themes ]]; then
    mkdir $HOME/.themes
  fi
  echo "Done."
  echo "Descargando el tema $apptheme"
  wget -O $HOME/.themes/Sweet-mars.tar.xz https://github.com/EliverLara/Sweet/releases/download/2.0/Sweet-mars.tar.xz
  echo "Done."
  echo "Descomprimiendo destino..."
  tar -xvf $HOME/.themes/Sweet-mars.tar.xz --directory $HOME/.themes/
  rm -f $HOME/.themes/Sweet-mars.tar.xz
  echo "Done."
  echo "Configurando el tema elegido..." 
  gsettings set org.gnome.desktop.interface gtk-theme $appTheme
  gsettings set org.gnome.desktop.wm.preferences theme $appTheme
  echo "Done."
  echo "Configurado gnome-sheel al tema elegido..."
  gsettings set org.gnome.shell.extensions.user-theme name $gnomeShell  
  echo "Done."
}

function installTheme {
  case $appTheme in
    'Sweet-mars')
      installSweet-mars
      ;;
    *)
      echo "Tema no soportado" 
      ;;
  esac

}

function setWallpaper {
   case $LANG in
     es*) wallpaperDir="Fondos de escritorio" ;;
     en*) wallpaperDir="Wallpapers" ;;
   esac
   echo "lang path: $wallpaperDir"
   source $HOME/.config/user-dirs.dirs
   wallpaperURI="$XDG_PICTURES_DIR/$wallpaperDir/"
   echo "path: $wallpaperURI"
   if [[ ! -d "$wallpaperURI" ]] ; then
     mkdir -p "$wallpaperURI"
   fi
   
   cp -av "$SCRIPT_DIR/wallpapers"/* "$wallpaperURI"
   gsettings set org.gnome.desktop.background picture-uri "file://$wallpaperURI/$wallpaper.jpg"
}

function configGeneric {
  gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
  gsettings set org.gnome.desktop.interface clock-show-weekday true
}

echo "configuraremos la apariencia del escritorio..."
installPapirus
installTheme
configGeneric
setWallpaper
echo "Done."

