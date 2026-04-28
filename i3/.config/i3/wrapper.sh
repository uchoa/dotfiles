#!/bin/bash

i3status -c ~/.config/i3status/config | while read line
do
    if [[ "$line" == [* ]] && [[ "$line" != "[" ]]; then
        layout=$(xkb-switch -p 2>/dev/null || echo "us")
        if [[ "$layout" == *"intl"* ]] || [[ "$layout" == *"us("* ]]; then
            kb="US-INTL"
        else
            kb="US"
        fi
        echo "[{\"name\":\"kb\",\"full_text\":\"⌨ $kb\"},${line:1}"
    elif [[ "$line" == ,[* ]]; then
        layout=$(xkb-switch -p 2>/dev/null || echo "us")
        if [[ "$layout" == *"intl"* ]] || [[ "$layout" == *"us("* ]]; then
            kb="US-INTL"
        else
            kb="US"
        fi
        echo ",[{\"name\":\"kb\",\"full_text\":\"⌨ $kb\"},${line:2}"
    else
        echo "$line"
    fi
done
