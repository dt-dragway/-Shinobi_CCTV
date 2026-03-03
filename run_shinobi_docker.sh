#!/bin/bash
# Script para lanzar Shinobi en Docker sin requerir docker-compose
docker stop shinobi
docker rm shinobi

docker run -d --name shinobi \
  --restart unless-stopped \
  --network host \
  --privileged \
  --device /dev/dri:/dev/dri \
  -v $(pwd)/conf.json:/home/Shinobi/conf.json \
  -v $(pwd)/super.json:/home/Shinobi/super.json \
  -v /media/Jesus-Aroldo/Anexo/centibot_scripts/data/shinobi_videos:/home/Shinobi/videos \
  -v $(pwd)/plugins:/home/Shinobi/plugins \
  -e NODE_ENV=production \
  -e TZ=America/Caracas \
  --entrypoint "/usr/local/bin/node" \
  shinobisystems/shinobi:latest \
  camera.js

echo "Shinobi corriendo en Docker..."
