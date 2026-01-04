#!/bin/bash

# Script de Sincronización de Videos de Shinobi a Google Drive
# Autor: Configuración automática
# Fecha: 2026-01-03

# Configuración
SOURCE_DIR="/mnt/anexo1/Grab"
GDRIVE_REMOTE="gdrive:Shinobi-Videos"
LOG_DIR="/home/dragwaysk/Shinobi/logs"
LOG_FILE="$LOG_DIR/sync-gdrive-$(date +%Y%m%d).log"

# Crear directorio de logs si no existe
mkdir -p "$LOG_DIR"

# Función de logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Inicio del script
log "========================================="
log "Iniciando sincronización a Google Drive"
log "========================================="

# Verificar que rclone esté instalado
if ! command -v rclone &> /dev/null; then
    log "ERROR: rclone no está instalado"
    exit 1
fi

# Verificar que el directorio de origen existe
if [ ! -d "$SOURCE_DIR" ]; then
    log "ERROR: El directorio de origen no existe: $SOURCE_DIR"
    exit 1
fi

# Verificar que el remote de Google Drive está configurado
if ! rclone listremotes | grep -q "^gdrive:$"; then
    log "ERROR: El remote 'gdrive' no está configurado"
    log "Por favor ejecuta: rclone config"
    exit 1
fi

# Sincronizar archivos
log "Sincronizando desde: $SOURCE_DIR"
log "Hacia: $GDRIVE_REMOTE"

# Opciones de rclone:
# --update: solo copia archivos más nuevos
# --verbose: modo detallado
# --transfers 4: número de transferencias paralelas
# --checkers 8: número de verificadores paralelos
# --contimeout 60s: timeout de conexión
# --timeout 300s: timeout de operación
# --retries 3: número de reintentos
# --low-level-retries 10: reintentos de bajo nivel
# --stats 1m: mostrar estadísticas cada minuto
# --exclude: excluir archivos temporales y ocultos

rclone sync "$SOURCE_DIR" "$GDRIVE_REMOTE" \
    --update \
    --transfers 4 \
    --checkers 8 \
    --contimeout 60s \
    --timeout 300s \
    --retries 3 \
    --low-level-retries 10 \
    --stats 1m \
    --exclude ".*" \
    --exclude "*.tmp" \
    --exclude "*.temp" \
    --log-file="$LOG_FILE" \
    --log-level INFO

# Verificar el resultado
if [ $? -eq 0 ]; then
    log "✓ Sincronización completada exitosamente"
else
    log "✗ Error durante la sincronización"
    exit 1
fi

# Mostrar estadísticas
log "========================================="
log "Estadísticas de sincronización:"
TOTAL_SIZE=$(du -sh "$SOURCE_DIR" | cut -f1)
log "Tamaño total del directorio: $TOTAL_SIZE"
log "========================================="

exit 0
