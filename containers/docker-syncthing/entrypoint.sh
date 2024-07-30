#!/bin/sh

generate_script() {
    cat << 'EOF' > syncthing_logger.sh
#!/bin/sh

# Start Syncthing and capture its stdout
syncthing > >(while IFS= read -r line; do
    echo "$line" | logger -t syncthing
done) 2>&1 &

# Keep the script running
while true; do
    sleep 1
done
EOF
}

# Generate and run the script
generate_script
chmod +x syncthing_logger.sh
./syncthing_logger.sh &

# Execute /init
exec /init

