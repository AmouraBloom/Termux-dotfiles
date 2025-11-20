alias cls='clear'
alias vim='nvim'
alias ls='eza -al --header --color=always --icons --group-directories-first'
alias lt='eza -aT --color=always --icons --group-directories-first' # tree listing
alias l.='eza -a | egrep "^\."'

#app management
alias update='pkg update && pkg upgrade -y'
alias autoclean='apt autoclean -y'
alias autoremove='apt autoremove -y'
alias search='pkg search'

##Prompt
eval "$(starship init bash)"

#Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

