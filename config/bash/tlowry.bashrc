. ~/.config/shell/shellrc

# enable vi mode editing in bash
set -o vi
shopt -s cdspell
shopt -s dirspell 
export PS1="[\u@\h \W]\$ "

# key bindings
bind -x '"\C-xf": fzf'
bind -x '"\C-xc": fuzz_cd'
bind -x '"\C-xv": fuzz_edit'
bind -x '"\C-xr": shell_reload'
bind -x '"\C-xg": reset'
bind -x '"\C-xs": tes'
