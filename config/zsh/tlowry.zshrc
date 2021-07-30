. ~/.config/shell/shellrc
export PS1="[%n@%M %.]\$ "

bindkey -v
bindkey -s '^xf' 'fzf^M'
bindkey -s '^xc' 'fuzz_cd^M'
bindkey -s '^xv' 'fuzz_edit^M'
bindkey -s '^xr' 'shell_reload^M'
bindkey -s '^xg' 'reset^M'
bindkey -s '^xs' 'tes^M'
