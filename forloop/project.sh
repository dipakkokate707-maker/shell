
#!/bin/bash

# Deploy Django application using Docker
# Install Docker and Nginx
# Handle errors during deployment

code_clone() {
    echo "Cloning the Django app..."

    if git clone https://github.com/dipakkokate707-maker/django-notes-app.git; then
        echo "Code cloned successfully"
    else
        echo "ERROR: Code cloning failed"
        exit 1
    fi
}

install_requirements() {
    echo "Installing dependencies..."

    echo "Cleaning APT cache..."
    sudo apt-get clean
    sudo rm -rf /var/lib/apt/lists/*

    echo "Updating package information..."

    if sudo apt-get update && sudo apt-get install docker.io nginx -y; then
        echo "Docker and Nginx installed successfully"
    else
        echo "ERROR: Dependency installation failed"
        exit 1
    fi
}

required_restarts() {
    echo "Starting Docker and Nginx..."

    if sudo systemctl enable --now docker && sudo systemctl enable --now nginx; then
        echo "Docker and Nginx started successfully"
    else
        echo "ERROR: Failed to start Docker or Nginx"
        exit 1
    fi
}

deploy() {
    echo "Building Docker image..."

    if docker build -t notes-app .; then
        echo "Docker image built successfully"
    else
        echo "ERROR: Docker image build failed"
        exit 1
    fi

    echo "Starting Docker container..."

    if docker run -d -p 8000:8000 --name notes-app-container notes-app:latest; then
        echo "Docker container started successfully"
    else
        echo "ERROR: Docker container failed to start"
        exit 1
    fi
}

echo "================================================"
echo "       DJANGO APP DEPLOYMENT STARTED"
echo "================================================"

code_clone

cd django-notes-app || {
    echo "ERROR: Django application directory not found"
    exit 1
}

install_requirements
required_restarts
deploy

echo "================================================"
echo "       DJANGO APP DEPLOYMENT COMPLETED"
echo "================================================"

echo "Application URL:"
echo "http://<EC2-PUBLIC-IP>:8000"
