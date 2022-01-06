#!/usr/bin/env bash


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/helpers.sh"


display_keyboard_type() {
    #
    #  Identify keyboard_type layout
    #
    os=$(uname -s)
    if [ "$os" = "Darwin" ]; then
        keyb_name="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -f 2 -d "=" | tr -d ' ;' | tr -d '"')"
    elif [ "$os" = "Linux" ]; then
        keyb_name="$(localectl status |grep Layout | awk '{ print $3 }')"
    else
        # Need to test this in Windows...
        keyb_name="Failed to detect OS"
    fi
    keyb_name="$(trim "$keyb_name")"

    #
    #  Skip ones we don't want displayed
    #
    #  Syntax: @keyboard_type_hidden="U.S.|Norwegian"
    #    separator: |
    #
    dont_show=$(get_tmux_option "@keyboard_type_hidden")

    create_lst "$dont_show" "|"
    if [[ " ${lst[*]} " =~ " ${keyb_name} " ]]; then
        return
    fi


    #
    #  Go through the list of keyboard_types with an alias and use that 
    #  if matched. This needs to match what your OS reports, so once you see
    #  a keyboard_type being displayed, that is the pattern you should give
    #  an alias to match.
    #
    #  Syntax: @keyboard_type_aliases="Sv=Swedish-Pro|US=U.S."
    #    separator: |
    #    display=For this match
    #  
    aliases=$(get_tmux_option "@keyboard_type_aliases")
    create_lst "$aliases" "|"

    for alias_pair in "${lst[@]}"; do
        alias_replace="${alias_pair%%=*}"  # upto first = excluding it
        alias_match="${alias_pair#*=}"     # after fist =
        if [ "$keyb_name" = "$alias_match" ]; then
            keyb_name="$alias_replace"
            break
        fi
    done


    #
    #  Wrap it in colors
    #  
    #  Config: @keyboard_type_fg=""
    #          @keyboard_type_bg="green"
    #
    #  "txt" -> "#[bg=green]txt#[default]""
    #
    keyb_display="$(color_wrap "$keyb_name")"


    #
    #  Include  prefix/suffix if given, otherwise this wont change anything
    #
    #  Config: @keyboard_type_prefix=" "
    #          @keyboard_type_suffix=" "
    #
    #  "#[bg=green]txt#[default]" -> " #[bg=green]txt#[default] "
    #
    affix_wrap "$keyb_display"
}


display_keyboard_type