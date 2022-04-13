#!/usr/bin/env bash
#
#   Copyright (c) 2022: Jacob.Lundqvist@gmail.com
#   License: MIT
#
#   Part of https://github.com/jaclu/tmux-keyboard-type
#
#   Version: 1.1.0 2022-04-13
#

set -euo pipefail

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shellcheck disable=SC1091
source "$CURRENT_DIR/scripts/helpers.sh"

keyboard_interpolation=(
    "\#{keyboard_type}"
)

keyboard_commands=(
    "#($CURRENT_DIR/scripts/layout.sh)"
)


do_interpolation() {
    local all_interpolated="$1"
    for ((i=0; i<${#keyboard_commands[@]}; i++)); do
        all_interpolated=${all_interpolated//${keyboard_interpolation[$i]}/${keyboard_commands[$i]}}
    done
    echo "$all_interpolated"
}


update_tmux_option() {
    local option="$1"
    local option_value
    local new_option_value

    option_value="$(get_tmux_option "$option")"
    new_option_value="$(do_interpolation "$option_value")"
    set_tmux_option "$option" "$new_option_value"
}


main() {
    update_tmux_option "status-right"
    update_tmux_option "status-left"
}


main
