#!/bin/bash

# Configuración
MAX_SIZE_GB=30
STORAGE_DIR="/mnt/anexo1/Grab"
LOG_FILE="/home/dragwaysk/Shinobi/logs/storage-monitor.log"

# Crear directorio de logs si no existe
mkdir -p "$(dirname "$LOG_FILE")"

# Obtener tamaño actual en GB
CURRENT_SIZE=$(du -s "$STORAGE_DIR" 2>/dev/null | awk '{print $1}')
CURRENT_SIZE_GB=$((CURRENT_SIZE / 1024 / 1024))

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Tamaño actual: ${CURRENT_SIZE_GB} GB" >> "$LOG_FILE"

# Si supera el límite, eliminar videos antiguos
if [ $CURRENT_SIZE_GB -gt $MAX_SIZE_GB ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ⚠️  Límite excedido (${CURRENT_SIZE_GB} GB > ${MAX_SIZE_GB} GB). Eliminando videos antiguos..." >> "$LOG_FILE"
    
    DELETED_COUNT=0
    
    # Encontrar y eliminar videos más antiguos
    find "$STORAGE_DIR" -name "*.mp4" -type f -printf '%T+ %p\n' 2>/dev/null | \
        sort | \
        head -n 100 | \
        awk '{print $2}' | \
        while read file; do
            if [ -f "$file" ]; then
                FILE_SIZE=$(du -k "$file" | awk '{print $1}')
                rm -f "$file"
                DELETED_COUNT=$((DELETED_COUNT + 1))
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] Eliminado: $file (${FILE_SIZE} KB)" >> "$LOG_FILE"
                
                # Verificar si ya estamos bajo el límite
                NEW_SIZE=$(du -s "$STORAGE_DIR" 2>/dev/null | awk '{print $1}')
                NEW_SIZE_GB=$((NEW_SIZE / 1024 / 1024))
                
                if [ $NEW_SIZE_GB -le $((MAX_SIZE_GB - 2)) ]; then
                    echo "[$(date '+%Y-%m-% %H:%M:%S')] ✓ Límite alcanzado. Tamaño final: ${NEW_SIZE_GB} GB. Videos eliminados: ${DELETED_COUNT}" >> "$LOG_FILE"
                    break
                fi
            fi
        done
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✓ Dentro del límite (${CURRENT_SIZE_GB} GB / ${MAX_SIZE_GB} GB)" >> "$LOG_FILE"
fi
