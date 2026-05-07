#!/bin/bash

# Cache the layout so we don't query X11 on every single line
# It will only update when i3status outputs a full status block
current_kb="US"

i3status -c ~/.config/i3status/config | while read line
do
    if [[ "$line" == ,[* ]] || { [[ "$line" == [* ]] && [[ "$line" != "[" ]]; }; then
        # Check layout once per status update (fast)
        layout=$(xkb-switch -p 2>/dev/null || echo "us")
        if [[ "$layout" == *"intl"* ]] || [[ "$layout" == *"us("* ]]; then
            current_kb="US-INTL"
        else
            current_kb="US"
        fi
        
        # Inject right before tztime
        echo "${line/\{\"name\":\"tztime\"/\{\"name\":\"kb\",\"full_text\":\"⌨ $current_kb\"\},\{\"name\":\"tztime\"}"
    else
        # Pass headers normally
        echo "$line"
    fi
done
