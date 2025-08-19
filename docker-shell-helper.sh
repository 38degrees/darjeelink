#!/bin/sh

#####################################
#     Docker Helper Script Usage    #
#####################################
#
# This script provides a menu-based interface to manage Docker containers
# for Ruby development. It allows you to:
#
# 1. Start a new container with Ruby 3.4.5 and your project files mounted
# 2. Commit changes made in the container to a new image or replace the current image
# 3. Start a new container from an existing image with your project files mounted
#
# To use this script:
#
# 1. Make sure you have Docker installed and configured correctly on your system.
# 2. Save this script with a `.sh` extension (e.g., `docker-shell-helper.sh`).
# 3. Make the script executable with the command: `chmod +x docker-shell-helper.sh`
# 4. Run the script with: `./docker-shell-helper.sh`
# 5. Follow the menu prompts to perform the desired actions.
#
# Note: Inside the container, you can run commands like `bundle install`,
# `bundle exec rspec`, and `bundle exec rails db:setup RAILS_ENV=test` as needed.
#

# Function to start a new container with the necessary Ruby version
start_container() {
    docker run -it --rm --name my-ruby-container -v "${PWD}:/app" -w /app ruby:3.4.5 bash
}

# Function to commit changes to a new image
commit_changes() {
    current_image=$(docker ps --latest --quiet --no-trunc)
    read -p "Enter a name for the new image (leave blank to replace the current image): " image_name

    if [ -z "$image_name" ]; then
        docker commit my-ruby-container "$current_image"
        echo "Current image replaced: $current_image"
    else
        docker commit my-ruby-container "$image_name"
        echo "New image created: $image_name"
    fi
}

# Function to start a container from an existing image
start_from_image() {
    read -p "Enter the name of the image: " image_name
    docker run -it --rm -v "${PWD}:/app" -w /app "$image_name" bash
}

# Function to display the available options
show_menu() {
    echo "Select an option:"
    echo "1. Start a new container"
    echo "2. Commit changes to a new image"
    echo "3. Start a container from an existing image"
    echo "4. Exit"
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice: " choice

    case $choice in
        1) start_container ;;
        2) commit_changes ;;
        3) start_from_image ;;
        4) exit ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done