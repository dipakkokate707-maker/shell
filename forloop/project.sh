#!/bin/bash

# Deploy a Django app and handle errors
set -u

code_clone() {
    echo "Cloning the Django app..."
    if [ -d "django-notes-app" ]; then
        echo "The code directory already exists. Skipping clone."
    else
        git clone https://github.com/LondheShubham153/django-notes-app.git || {
            echo "Failed to clone the code."
            return 1
        }
    fi
}

install_requirements() {
    echo "Installing dependencies..."
    sudo apt-get update && sudo apt-get install -y docker.io nginx docker-compose-v2 || {
        echo "Failed to install dependencies."
        return 1
    }
}

required_restarts() {
    echo "Performing required restarts..."
    sudo chown "$USER" /var/run/docker.sock || {
        echo "Failed to change ownership of docker.sock."
        return 1
    }

    # sudo systemctl enable docker
    # sudo systemctl enable nginx
    # sudo systemctl restart docker
}

deploy() {
    echo "Building and deploying the Django app..."
    docker build -t notes-app . && docker compose up -d || {
        echo "Failed to build and deploy the app."
        return 1
    }
}

echo "********** DEPLOYMENT STARTED *********"

# Clone the code; stop if it fails
if ! code_clone; then
    exit 1
fi

# Move into the repo so Dockerfile and docker-compose.yml are found
cd django-notes-app || exit 1

if ! install_requirements; then
    exit 1
fi

if ! required_restarts; then
    exit 1
fi

if ! deploy; then
    echo "Deployment failed. Mailing the admin..."
    # Add your sendmail or notification logic here
    exit 1
fi

echo "********** DEPLOYMENT DONE *********"
