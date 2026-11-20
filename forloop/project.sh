
#!/bin/bash

<<task
deploy a django app
and handle the code for errors
task

code_clone(){
echo "cloning the django app..."
git clone repoip
}

install_requirements(){
echo "installing dependencies"
sudo apt-get install docker.io nginx -y
}

required_restarts(){
sudo systemctl enable docker
sudo systemctl enable nginx
sudo chown $USER /var/run/docker.sock
sudo systemctl restart docker
}

deploy() {
docker build -t notes-app .
docker run -d -p 8000:8000 notes-app:latest
}

echo "************deployment started*************"

if ! code_clone ; then
echo "the code directory exists"
cd django-notes-app
fi

if ! install_requirements ; then
echo "install failed"
exit 1
fi

if ! required_restarts; then
echo "system fault"
exit 1
fi

deploy

echo "*****************deployment done***************"
