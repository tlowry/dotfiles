#!/bin/bash

# find the current location of this script
SCRIPT_DIR=`dirname ${BASH_SOURCE[0]-$0}`
DOT_LOC=`cd $SCRIPT_DIR && pwd`

MAIN_CONFS=( 
    i3/config               alacritty/alacritty.yml 
    mpv/mpv.conf            input/tlowry.inputrc 
    sxhkd/sxhkdrc           tmux/tmux.conf
    polybar/config          ncmpcpp/config
    qutebrowser/config.py   lf/lfrc               
    newsboat/config         shell/shellrc   
    openbox/rc.xml          openbox/menu.xml
    openbox/environment     openbox/autostart
    git/config              git/ignore
    bash/tlowry.bashrc      zsh/tlowry.zshrc 
    mpd/mpd.conf            vim/tlowry.vimrc 
    mimeapps.list           X11/Xresources
    gdb/init                redshift/redshift.conf
    elinks/elinks.conf      gtk-3.0/settings.ini
    mutt/muttrc             mutt/mailcap
    mutt/neomuttrc          speech-dispatcher/speechd.conf
    mutt/theme              irssi/default.theme
    gtk-2.0/gtkrc-2.0       gtk-2.0/gtkfilechooser.ini
    wal/colorschemes/dark/supertango.json
    wal/colorschemes/dark/grey.json
)

ARCH_CONFS=(
    sxhkd/bspwm             sxhkd/sxhkdrc
    bspwm/bspwmrc           bspwm/terminals
    spectrwm/spectrwm.conf  spectrwm/keys.conf
)

ul () { [ -L "$1" ] && unlink "$1" ;}

# only unlink if it belongs to us
ul_ours () { [ -L "$1" ] && readlink -f "$1" | grep -q "$DOT_LOC" && unlink "$1" ;}

create_and_append(){
 touch -c "$2"
 $DOT_LOC/bin/append_if_missing "$1" "$2"
}

make_link () {
    dest_dir=`dirname $2` 2> /dev/null
    [ -d "$dest_dir" ] || mkdir -p "$dest_dir"
    [ -L "$2" ] && ul "$2"
    ln -s "$1" "$2"
}

# Remove a literal line from a file (no regex)
# e.g del_lit_line "hello" hello.txt - creates hello.txt.bak
del_lit_line () {
    num=`fgrep -n "$1" "$2" | cut -d':' -f1`
    [ -z "$num" ] || sed -i.bak -e "$num"d "$2"
}

ul_bin () {
    bin_dir="$HOME/.local/bin"
    dots_bin="$DOT_LOC/bin"
    for file in $bin_dir/*;do
        readlink -f "$file" | grep -q "$dots_bin" && ul "$bin_dir/$file"
    done
}

# make user scripts available system wide
ln_bin () {
    
    bin_dir="$HOME/.local/bin"
    mkdir -p "$bin_dir" 2> /dev/null
    
    if [ `ls -lA $DOT_LOC/bin | wc -l` -gt 3 ]; then
        for file in $DOT_LOC/bin/*;do
            dest_file="$bin_dir/"`basename $file`
            make_link "$file" "$dest_file"
        done

        make_link "$DOT_LOC"/bin/lib "$bin_dir"/lib
    else
        echo "no binaries to link"
    fi
}

ul_apps () {
    app_dir="$XDG_DATA_HOME/applications"
    dot_apps="$DOT_LOC/share/applications"
    for file in $app_dir/*;do
        ul_ours "$file"
    done
}

# install apps
ln_apps () {

    app_dir="$XDG_DATA_HOME/applications"
    mkdir -p "$app_dir" 2> /dev/null

    if [ `ls -lA $DOT_LOC/share/applications | wc -l` -gt 3 ]; then
        for file in $DOT_LOC/share/applications/*
        do
            dest_file="$app_dir/"`basename $file`
            ul "$dest_file"
            make_link "$file" "$dest_file"
        done
    else
        echo "no applications to link"
    fi
}

ln_conf () {
    dest=`echo $1 | sed 's/.*\/config\///g'`
    dest=$XDG_CONFIG_HOME/$dest
    make_link "$1" "$dest"
}

ul_conf () {
    dest=`echo $1 | sed 's/.*\/config\///g'`
    dest=$XDG_CONFIG_HOME/$dest
    ul "$dest"
}

# common install for all platforms
install_base () {
    echo "install base"

    # pull down any plugins stored as submodules
    git submodule update --init

    # Don't overwrite existing config (create if missing and source)
    create_and_append ". $HOME/.config/bash/tlowry.bashrc" ~/.bashrc
    create_and_append ". $HOME/.config/zsh/tlowry.zshrc" ~/.zshrc
    create_and_append ":so $HOME/.config/vim/tlowry.vimrc" ~/.vimrc 
    create_and_append "\$include $HOME/.config/input/tlowry.inputrc" ~/.inputrc

    # soft link config to standard location
    [ -f ~/.bash_profile ] || make_link $DOT_LOC/config/bash/bash_profile ~/.bash_profile
    [ -f ~/.zprofile ] || make_link $DOT_LOC/config/zsh/zprofile ~/.zprofile
    make_link $DOT_LOC/config/vim/colors/codedark.vim ~/.vim/colors/codedark.vim
    make_link $DOT_LOC/config/vim/colors/wal.vim ~/.vim/colors/wal.vim
    make_link $DOT_LOC/config/vim/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim

    # vim pathogen plugins
    #mkdir -p ~/.vim/bundle
   
    # link any installed plugins
    for dir in config/vim/bundle/*
    do
        make_link "$DOT_LOC/$dir" ~/.vim/bundle/"${dir##*/}"
    done
    
    # more straightforward directory mapped configs
    for x in ${MAIN_CONFS[@]};do
        ln_conf "$DOT_LOC/config/$x"
    done
    
    ln_bin
    ln_apps

    distro=`cat /etc/os-release` ; echo "$distro" | grep -q "ID=arch" && install_arch
}

ul_vim () {
    ul ~/.vim/autoload/pathogen.vim

    # unlink any installed plugins
    for f in ~/.vim/bundle/*;do
      ul "$f"
    done
    # unlink any installed colors 
    for f in ~/.vim/colors/*;do
      ul "$f"
    done
}

uninstall () {
    echo "uninstall"
    del_lit_line ". $HOME/.config/bash/tlowry.bashrc" ~/.bashrc
    del_lit_line ". $HOME/.config/zsh/tlowry.zshrc" ~/.zshrc
    del_lit_line ":so $HOME/.config/vim/tlowry.vimrc" ~/.vimrc 
    del_lit_line "\$include $HOME/input/tlowry.inputrc" ~/.inputrc
    
    for x in ${MAIN_CONFS[@]};do
        ul_conf "$x"
    done

    ul_bin
    ul_apps
    ul_vim

    distro=`uname -a | cut -d " " -f 2` ; echo $distro | grep -q "arch" && uninstall_arch
}

# arch/manjaro specific
install_arch() {
    echo "install arch"
    make_link $DOT_LOC/config/X11/xinitrc ~/.xinitrc

    for x in ${ARCH_CONFS[@]};do
        ln_conf "$DOT_LOC/config/$x"
    done
    #systemctl -q is-active stor.mount || sudo inst_sysd config/systemd/stor.mount
}

# arch/manjaro specific
uninstall_arch () {
    echo "uninstall arch"
    ul ~/.xinitrc

    # more straightforward directory mapped configs
    for x in ${arch_confs[@]};do
        ul_conf "$x"
    done
}

usage () {
    echo "use: install.sh  < -r optional to uninstall >"
}

while [ "$1" != "" ]; do
    case $1 in
        -r | --remove )         REMOVE=1 ;;
        -h | --help )           usage;exit 0 ;;
        * )                     usage;exit 1 ;;
    esac
    shift
done

# sudo/su workaround
if [[ "$USER" != "root" ]] && echo "$XDG_CONFIG_HOME" | grep -q "root"
then
	export XDG_CONFIG_HOME=~/.config
	export XDG_DATA_HOME="$HOME/.local/share"
	export XDG_CACHE_HOME="$HOME/.cache"
	export XDG_BIN_HOME="$HOME/.local/bin"
else
    [ -z "$XDG_CONFIG_HOME" ] && export XDG_CONFIG_HOME="$HOME/.config"
	[ -z "$XDG_DATA_HOME" ] && export XDG_DATA_HOME="$HOME/.local/share"
	[ -z "$XDG_CACHE_HOME" ] && export XDG_CACHE_HOME="$HOME/.cache"
	[ -z "$XDG_BIN_HOME" ] && export XDG_BIN_HOME="$HOME/.local/bin"
fi

[ -d "$XDG_CONFIG_HOME" ] || mkdir -p "$XDG_CONFIG_HOME"
[ -d "$XDG_DATA_HOME/applications" ] || mkdir -p "$XDG_DATA_HOME/applications"
[ -d "$XDG_CACHE_HOME" ] || mkdir -p "$XDG_CACHE_HOME"
[ -d "$XDG_BIN_HOME" ] || mkdir -p "$XDG_BIN_HOME"

if [ -z "$REMOVE" ]; then install_base ; else uninstall ; fi
