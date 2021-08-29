#!/bin/bash

function plankConfig {
  echo 'Configurando plank...'
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ icon-size "84"
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ theme "Teleport-theme-Light-Blue"
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ zoom-enabled "true"
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ zoom-percent "150"
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ alignment 'center'
  gsettings set net.launchpad.plank.dock.settings:/net/launchpad/plank/docks/dock1/ position 'bottom'
  echo 'Done.'
}

function plankDockItems {
  echo 'Instalando launchers...'
  echo 'Instalando launchpad..'
  touch $HOME/.config/plank/dock1/launchers/launchpad.dockitem | printf "[PlankDockItemPreferences]\nLauncher=file:///home/juandn/.local/share/applications/launchpad.desktop" > $HOME/.config/plank/dock1/launchers/launchpad.dockitem
  echo 'Done.' 
  launchers=('firefox' 'org.gnome.gedit' 'org.gnome.Nautilus' 'org.gnome.Terminal')
  for i in "${launchers[@]}"
  do
    echo "Instalando launcher para [$i]..."
    if [[  -f "/usr/share/applications/$i.desktop" ]]; then
      touch $HOME/.config/plank/dock1/launchers/$i.dockitem | printf "[PlankDockItemPreferences]\nLauncher=file:///usr/share/applications/$i.desktop" > $HOME/.config/plank/dock1/launchers/$i.dockitem
      echo "Done."
    fi
  done
  echo 'Done.'
}

function plankInstallThemes {
  echo 'Instalando tema Teleport...'
  mkdir /var/tmp/plankThemeInstall
  git clone https://github.com/horberlan/Teleport-theme.git  /var/tmp/plankThemeInstall/.
  mkdir -p $HOME/.local/share/plank/themes
  cp -Ri /var/tmp/plankThemeInstall/Teleport-theme-Dark-red $HOME/.local/share/plank/themes/. &&
  cp -Ri /var/tmp/plankThemeInstall/Teleport-theme-Light-Blue $HOME/.local/share/plank/themes/. &&
  cp -Ri /var/tmp/plankThemeInstall/Teleport-theme-Pink $HOME/.local/share/plank/themes/.
  echo 'Done.'
}

function plankInstall {
  if [[ ! -f "/usr/bin/plank" ]]; then
      echo 'Instalacion de plank no detectada, instalando...'
      sudo apt-get install plank -y
      echo 'Done.'
      echo 'Agregando a autostart...'
      mkdir -p $HOME/.config/autostart/
      touch $HOME/.config/autostart/plank.desktop
      desktopEntry="[Desktop Entry]\nType=Application\nExec=plank\nHidden=false\nNoDisplay=false\nX-GNOME-Autostart-enabled=true\nName[es_ES]=plank\nName=plank"
      printf "$desktopEntry" > $HOME/.config/autostart/plank.desktop
      echo 'Done.'
      mkdir -p $HOME/.config/plank/dock1/launchers/
      plankDockItems
      plankInstallThemes
      plankConfig
      plank &>/dev/null &
  else
      echo "plank se encuentra instalado."
      plankPID=`ps aux | grep plank | grep -v grep | xargs | cut -d' ' -f2` 
      echo "Parando instancia de plank con PID [${plankPID}]..."
      kill -9 ${plankPID}
      echo "Done."
      plankConfig
      echo "Lenatando plank de nuevo..."
      plank &>/dev/null &
      echo "Done."
  fi
}
 
echo "Bienvenido, ahora instalaremos Plank."
plankInstall
echo "Concluido."
