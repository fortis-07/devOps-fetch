#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: devopsfetch [OPTION]... [ARGUMENT]..."
    echo "Retrieve and display system information for DevOps purposes."
    echo
    echo "Options:"
    echo "  -p, --port [PORT]    Display active ports or specific port info"
    echo "  -d, --docker [CONTAINER] List Docker images/containers or specific container info"
    echo "  -n, --nginx [DOMAIN] Display Nginx domains/ports or specific domain config"
    echo "  -u, --users [USER]   List users and last login times or specific user info"
    echo "  -t, --time START END Display activities within a time range"
    echo "  -h, --help           Display this help message"
    exit 1
}

# Function to format output as a table
format_table() {
    column -t -s $'\t' | sed 's/^/  /'
}

# Function to get port information
get_port_info() {
    if [ -z "$1" ]; then
        echo "Active Ports and Services:"
        echo -e "Port\tService" | format_table
        ss -tuln | awk 'NR>1 {print $5}' | awk -F: '{print $NF}' | sort -n | uniq | \
        while read port; do
            service=$(grep -w "$port" /etc/services | awk '{print $1}' | head -1)
            printf "%s\t%s\n" "$port" "${service:-N/A}"
        done | sort -u | format_table
    else
        echo "Information for port $1:"
        echo -e "State\tRecv-Q\tSend-Q\tLocal Address:Port\tPeer Address:Port\tProcess" | format_table
        ss -tlnp | grep ":$1 " | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6}' | format_table
    fi
}

# Function to get Docker information
get_docker_info() {
    if [ -z "$1" ]; then
        echo "Docker Images:"
        docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}" | sed 's/^/  /'
        echo -e "\nDocker Containers:"
        docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | sed 's/^/  /'
    else
        echo "Information for container $1:"
        docker inspect "$1" | jq '.[0] | {Name: .Name, Image: .Config.Image, State: .State.Status, Ports: .NetworkSettings.Ports}' | sed 's/^/  /'
    fi
}

# Function to get Nginx information
get_nginx_info() {
    if [ -z "$1" ]; then
        echo "Nginx Domains and Ports:"
        echo -e "Domain\tPort" | format_table
        grep -h server_name /etc/nginx/sites-enabled/* | awk '{print $2}' | sed 's/;$//' | sort -u | \
        while read domain; do
            port=$(grep -h "listen .* default_server" /etc/nginx/sites-enabled/* | grep -v "#" | awk '{print $2}' | sed 's/;$//' | head -1)
            printf "%s\t%s\n" "$domain" "${port:-80}"
        done | format_table
    else
        echo "Configuration for domain $1:"
        grep -rl "server_name.*$1" /etc/nginx/sites-enabled | xargs cat | sed 's/^/  /'
    fi
}

# Function to get user information
get_user_info() {
    if [ -z "$1" ]; then
        echo "Users and Last Login Times:"
        echo -e "User\tLast Login" | format_table
        last -w | awk '!seen[$1]++ {print $1 "\t" $3 " " $4 " " $5 " " $6}' | sort | format_table
    else
        echo "Information for user $1:"
        id "$1" | sed 's/^/  /'
        echo "Last login:"
        last "$1" -1 | sed 's/^/  /'
    fi
}

# Function to get activities within a time range
get_time_range_activities() {
     local start_time="$1"
    local end_time="$2"
    if [ -z "$end_time" ]; then
        end_time="$(date +"%Y-%m-%d %H:%M:%S")"
    fi
    echo "Activities from $start_time to $end_time:"
    journalctl --since "$start_time" --until "$end_time"
}

# Main script logic
case "$1" in
    -p|--port)
        get_port_info "$2"
        ;;
    -d|--docker)
        get_docker_info "$2"
        ;;
    -n|--nginx)
        get_nginx_info "$2"
        ;;
    -u|--users)
        get_user_info "$2"
        ;;
    -t|--time)
        if [ -n "$2" ] && [ -n "$3" ]; then
            display_time_range "$2" "$3"
        else
            echo "Error: Both START and END times must be provided for the -t option."
            usage
        fi
        ;;
    -h|--help)
        usage
        ;;
    *)
        echo "Invalid option. Use -h or --help for usage information."
        exit 1
        ;;
esac
