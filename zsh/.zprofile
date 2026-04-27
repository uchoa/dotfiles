if [ ! -d "$XDG_RUNTIME_DIR" ]; then
    # If /run/user/1000 doesn't exist, create it or fallback to /tmp
    sudo mkdir -p "$XDG_RUNTIME_DIR"
    sudo chown "$USER:$USER" "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
fi

if [ -e "$XDG_RUNTIME_DIR/bus" ]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
fi

