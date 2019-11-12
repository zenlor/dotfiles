# Can be sourced by zsh/bash/sh scripts

export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_BIN_HOME=$HOME/.local/bin

for dir in "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_BIN_HOME" "$DOTFILES_DATA"; do
    [ -d "$dir" ] || mkdir -p "$dir"
done

## source osx path_helper
if [ -x /usr/libexec/path_helper ]; then
    eval $(/usr/libexec/path_helper -s)
fi

## source system profile
if [ -d /etc/profile.d ]; then
    for i in /etc/profile.d/*.sh; do
        . $i
    done
fi

# go: Set GOPATH for Go
if command -v go &> /dev/null; then
    [ -d "$HOME/lib" ] || mkdir "$HOME/lib"
    export GOPATH="$HOME/lib"
    export PATH="$PATH:$GOPATH/bin"
fi

# rust/cargo: Cargo/Rust PATH
if command -v cargo &> /dev/null; then
    [ -d "$HOME/.cargo" ] || mkdir -p "$HOME/.cargo/bin"
    export PATH="$PATH:$HOME/.cargo/bin"
fi

# Microsoft bugs: WSL
if uname -r|grep -q Microsoft;then
    export DISPLAY=:0
    export LIBGL_ALWAYS_INDIRECT=1

    # See https://github.com/Microsoft/BashOnWindows/issues/1887
    unsetopt BG_NICE
fi

# lua: luarocks PATH
if command -v luarocks &> /dev/null; then
    [ -d "$HOME/.luarocks/bin" ] || mkdir -p "$HOME/.luarocks/bin"
    export PATH="$PATH:$HOME/.luarocks/bin"
fi

## PATH
export PATH=$HOME/lib/n/bin:$HOME/lib/bin:$HOME/.local/bin:$PATH

## Library
_is_interactive() { [ $- == *i* ]; }

_is_running() {
  for prc in "$@"; do
    pgrep -x "$prc" >/dev/null || return 1
  done
}

_source() {
  [ -f $1 ] && source "$1"
}

## TDM
[ "$(tty)" = '/dev/tty1' ] &&\
    [ -z "$DISPLAY$SSH_TTY$(pgrep xinit)" ] &&\
    exec tdm

## GPG tty fix
export GPG_TTY=$(tty)

export LC_ALL=en_US.UTF-8

## Load local configuration
[ -f "$HOME/.profile.local" ] && source "$HOME/.profile.local" || true

# doom
[ -f "$HOME/.emacs.d/bin/doom" ] && export PATH="$PATH:$HOME/.emacs.d/bin" || true
# vim:ft=sh

export PATH="$HOME/.cargo/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# MacOSX pythong
[ -d "$HOME/Library/Python/3.7/bin" ] && export PATH="$PATH:$HOME/Library/Python/3.7/bin" || true

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
