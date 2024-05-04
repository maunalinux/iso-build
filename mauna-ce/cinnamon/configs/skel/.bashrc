# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

alias usage='du -sk * | sort -n | perl -ne '\''($s,$f)=split(m{\t});for (qw(K M G)) {if($s<1024) {printf("%.1f",$s);print "$_\t$f"; last};$s=$s/1024}'\'
alias ls="ls --color"

# Powerline
if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
    source /usr/share/powerline/bindings/bash/powerline.sh
fi

# Mauna Terminal
MLVER=$(awk '{print}' /etc/mlver)

echo -e "Seja Bem-vindo ao $MLVER ${USER}"
echo -e "Welcome to $MLVER ${USER}"
echo " "
date "+%A %d %B %Y, %T"
free -m | awk 'NR==2{printf "Uso de Memória/Memory Usage: %s/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
echo "Site - https://maunalinux.top/ (Right click, Open Link)"
echo "Suporte/Support - https://forum.maunalinux.top/ (Right click, Open Link)"
echo "Wiki - https://wiki.maunalinux.top/ (Right click, Open Link)"
echo " "


