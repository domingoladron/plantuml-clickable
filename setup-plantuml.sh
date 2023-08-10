#!/bin/bash

echo "Firing up plantuml server"

plantumlRunning=$(docker ps | grep plantuml)
if [ -z "$plantumlRunning" ]
then
    docker container prune -f
else
    echo "kiling off running plantuml server" 
    docker stop plantuml
    docker container prune -f
fi

docker run -d -p 8080:8080 --name plantuml plantuml/plantuml-server:jetty

echo "If started sucessfully, you can access the plantuml webview at http://localhost:8080"