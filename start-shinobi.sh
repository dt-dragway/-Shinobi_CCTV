#!/bin/bash
# Script para iniciar Shinobi

echo "Iniciando Shinobi..."

# Cambiar al directorio de Shinobi
cd /home/dragwaysk/Shinobi

# Iniciar el servicio con PM2
pm2 start camera.js --name shinobi

# Guardar la configuración de PM2
pm2 save

# Mostrar el estado
pm2 list

echo "Shinobi iniciado correctamente"
echo "Accede a: http://localhost:8080"
