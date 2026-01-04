#!/bin/bash

# Script de Configuración de Google Drive para Rclone
# Este script te guiará en la configuración de Google Drive

echo "========================================="
echo "Configuración de Google Drive en Rclone"
echo "========================================="
echo ""
echo "Este script te ayudará a configurar Google Drive."
echo "Necesitarás:"
echo "  1. Una cuenta de Google"
echo "  2. Acceso a un navegador web"
echo ""
echo "Presiona ENTER para continuar..."
read

# Iniciar configuración de rclone
rclone config

echo ""
echo "========================================="
echo "Configuración completada"
echo "========================================="
echo ""
echo "Para probar la conexión, ejecuta:"
echo "  rclone lsd gdrive:"
echo ""
echo "Para sincronizar manualmente, ejecuta:"
echo "  ./sync-to-gdrive.sh"
echo ""
