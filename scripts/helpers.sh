#!/usr/bin/env bash
#
#   Copyright (c) 2022: Jacob.Lundqvist@gmail.com
#   License: MIT
#
#   Part of https://github.com/jaclu/tmux-keyboard-type
#
#   Version: 1.1.0 2022-04-13
#

#
#  I use an env var TMUX_BIN to point at the current tmux, defined in my
#  tmux.conf, in order to pick the version matching the server running.
#  This is needed when checking backwards compatability with various versions.
#  If not found, it is set to whatever is in path, so should have no negative
#  impact. In all calls to tmux I use $TMUX_BIN instead in the rest of this
#  plugin.
#
[[ -z "$TMUX_BIN" ]] && TMUX_BIN="tmux"

get_tmux_option() {
    local option="$1"
    local default_value="${2-}"
    local option_value

    option_value="$($TMUX_BIN show-option -gqv "$option")"

    if [[ -z "$option_value" ]]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

set_tmux_option() {
    local option="$1"
    local value="$2"

    $TMUX_BIN set-option -gq "$option" "$value"
}

trim() {
    local txt="$*"

    # remove leading white space characters
    txt="${txt#"${txt%%[![:space:]]*}"}"

    # remove trailing white space characters
    txt="${txt%"${txt##*[![:space:]]}"}"

    echo "$txt"
}

#
#  Creates variable lst
#  This will be created from param one
#  Using separator defined in param 2
#
create_lst() {
    local txt="$1"
    local sepparator="$2"

    if [[ -z "$sepparator" ]]; then
        echo "ERROR: create_lst() param 2 not given!"
        exit 1
    fi

    lst=()
    [[ -z "$txt" ]] && return

    IFS=$sepparator
    # shellcheck disable=SC2034,SC2162
    read -a lst <<<"$txt"
    unset IFS
}

color_statement() {
    local fg
    local bg

    fg="$(trim "$1")"
    bg="$(trim "$2")"

    if [[ -n "$fg" ]] && [[ -n "$bg" ]]; then
        echo "#[fg=$fg,bg=$bg]"
    elif [[ -n "$fg" ]] && [[ -z "$bg" ]]; then
        echo "#[fg=$fg]"
    elif [[ -z "$fg" ]] && [[ -n "$bg" ]]; then
        echo "#[bg=$bg]"
    fi
}

#
#  If color is defined for current status, wrap text in a color statement
#  txt param should not be trimmed here, since it might intentionally contain
#  leading or trailing spaces
#
color_wrap() {
    txt="$1"

    [[ -z "$txt" ]] && return

    color_fg=$(get_tmux_option "@keyboard_type_fg")
    color_bg=$(get_tmux_option "@keyboard_type_bg")
    if [[ -z "$color_fg" ]] && [[ -z "$color_bg" ]]; then
        # if neither are set
        echo "$txt"
        return
    fi

    color_prefix=$(color_statement "$color_fg" "$color_bg")
    echo "${color_prefix}${txt}#[default]"
}

#
#  Wrap text in defined prefix and suffix
#
affix_wrap() {
    txt="$1"

    prefix=$(get_tmux_option "@keyboard_type_prefix")
    suffix=$(get_tmux_option "@keyboard_type_suffix")
    echo "${prefix}${txt}${suffix}"
}
