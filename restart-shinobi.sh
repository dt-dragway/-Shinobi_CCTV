#!/bin/bash
# Script para reiniciar Shinobi

echo "Reiniciando Shinobi..."

# Cambiar al directorio de Shinobi
cd /home/dragwaysk/Shinobi

# Reiniciar el servicio con PM2
pm2 restart shinobi

# Mostrar el estado
pm2 list

echo "Shinobi reiniciado correctamente"
echo "Accede a: http://localhost:8080"
