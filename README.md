
# Tmux Keyboard Type plugin

Plugin that shows current keyboard layout. Since there is already a plugin called tmux-keyboard-layout, I used a different name for this one. Personally I think this one does a better job :) Anyhow that one motivated me to do this one, so kudos to it for giving me inspiration to improve on that concept!

## Screenshots

Here both aliasing and hidden features are displayed.

Display|Description
-|-
![disconnected_default](/assets/Screenshot-us.png) | US keyboard, with an alias for compact display.
![disconnected_no_bg](/assets/Screenshot-swe.png) | Swedish keyboard, with an alias for compact display.
![connecting](/assets/Screenshot-hidden.png) | US keyboard, defined as hidden.


### Usage

```tmux.conf
set -g status-right '#{keyboard_type}'
```

### Installation with Tmux Plugin Manager (recommended)

Add plugin to the list of TPM plugins:

```tmux.conf
set -g @plugin 'jaclu/tmux-keyboard-type'
```

Press prefix + I to install it.

### Manual Installation

Clone the repo:

```bash
$ git clone https://github.com/jaclu/tmux-keyboard-type.git ~/clone/path
```

Add this line to your .tmux.conf:

```tmux.conf
run-shell ~/clone/path/keyboard-type.tmux
```

Reload TMUX environment with:

```bash
$ tmux source-file ~/.tmux.conf
```

### Configurations

## Variables that can be set

To disable a setting, set it to " ", spaces will be trimmed and thus nothing will end up being printed, if you set it to "" it will be ignored and the default value will be used.
The exception is prefix/suffix, they will honour "" as dont show anything.
Variable|My settings|Purpose
-|-|-
@keyboard_type_hidden | "U.S."<br><br> If you want to give multiple values, use \| as item separator. | I mosly use US keyboard, occationally switching to Swedish or Dutch, so in my case I only want to be notified if I am not using the US one.
@keyboard_type_aliases | "Sv=Swedish-Pro\|US=U.S."<br><br> If you want to give multiple values, use \| as item separator. Each item should be alias=match_str | Use aliases for display.
@keyboard_type_fg      |          | Sets color 
@keyboard_type_bg      | "green"  | Sets color
@keyboard_type_prefix  | ""      | Give it some space when displayed. Saves you from putting permanent spacers in your status line, especially if you hide some keyboards it avoids spacers arround not displayed items.
@keyboard_type_suffix  | " "      | 


### License

[MIT](LICENSE)
