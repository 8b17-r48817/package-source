# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.zshrc'

alias shopt='/usr/bin/shopt'

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit
# End of lines added by compinstall
source ~/.bash_aliases
PROMPT="%F{46}┌──[HQ🚀🌐%F{201}$(ip -4 addr | grep -v '127.0.0.1' | grep -v 'secondary' | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | sed -z 's/\n/|/g;s/|\$/\n/' | rev | cut -c 2- | rev)🔥%n%F{46}]"$'\n'"└──╼[👾]%F{44}%~ $%f "
precmd() { eval "$PROMPT_COMMAND" }
export PROMPT_COMMAND='source ~/.zshrc'
