#!/bin/bash
# Script para detener Shinobi

echo "Deteniendo Shinobi..."

# Cambiar al directorio de Shinobi
cd /home/dragwaysk/Shinobi

# Detener el servicio con PM2
pm2 stop shinobi

# Mostrar el estado
pm2 list

echo "Shinobi detenido correctamente"
