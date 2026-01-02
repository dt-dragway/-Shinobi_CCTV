#!/bin/bash
# Script para ver el estado de Shinobi

echo "Estado de Shinobi:"
echo "=================="

# Mostrar el estado de PM2
pm2 list

echo ""
echo "Para ver los logs en tiempo real, usa: pm2 logs shinobi"
