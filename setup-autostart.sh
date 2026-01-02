#!/bin/bash
# Script para configurar el inicio automático de Shinobi

echo "Configurando inicio automático de Shinobi..."
echo "=============================================="

# Verificar si PM2 está instalado
if ! command -v pm2 &> /dev/null; then
    echo "Error: PM2 no está instalado"
    echo "Instálalo con: npm install -g pm2"
    exit 1
fi

# Cambiar al directorio de Shinobi
cd /home/dragwaysk/Shinobi

# Detener cualquier instancia previa
echo "1. Limpiando instancias previas..."
pm2 delete shinobi 2>/dev/null || true

# Iniciar Shinobi con PM2
echo "2. Iniciando Shinobi..."
pm2 start camera.js --name shinobi

# Guardar la configuración de PM2
echo "3. Guardando configuración de PM2..."
pm2 save

# Configurar PM2 para que inicie al arrancar el sistema
echo "4. Configurando inicio automático..."
pm2 startup

echo ""
echo "=============================================="
echo "IMPORTANTE: Copia y ejecuta el comando que aparece arriba"
echo "(el que empieza con 'sudo env PATH=...')"
echo ""
echo "Después de ejecutar ese comando, Shinobi se iniciará"
echo "automáticamente cada vez que arranque el sistema."
echo "=============================================="
