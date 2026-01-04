#!/bin/bash

# Script de Auto-Activación de Cámaras en Shinobi
# Activa automáticamente todas las cámaras en modo record al iniciar
# Autor: Configuración automática
# Fecha: 2026-01-04

# Configuración
SHINOBI_HOST="localhost"
SHINOBI_PORT="8080"
DB_USER="majesticflame"
DB_HOST="127.0.0.1"
DB_NAME="ccio"
LOG_DIR="/home/dragwaysk/Shinobi/logs"
LOG_FILE="$LOG_DIR/auto-enable-cameras.log"
MAX_WAIT_TIME=60  # Segundos máximos para esperar a que Shinobi inicie

# Crear directorio de logs si no existe
mkdir -p "$LOG_DIR"

# Función de logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Inicio del script
log "========================================="
log "Iniciando auto-activación de cámaras"
log "========================================="

# Esperar a que Shinobi esté disponible
log "Esperando a que Shinobi esté disponible en puerto $SHINOBI_PORT..."
WAIT_COUNT=0
while ! nc -z $SHINOBI_HOST $SHINOBI_PORT 2>/dev/null; do
    sleep 1
    WAIT_COUNT=$((WAIT_COUNT + 1))
    if [ $WAIT_COUNT -ge $MAX_WAIT_TIME ]; then
        log "ERROR: Shinobi no respondió después de $MAX_WAIT_TIME segundos"
        exit 1
    fi
done

# Esperar 5 segundos adicionales para que Shinobi termine de inicializar
log "Shinobi detectado, esperando 5 segundos para inicialización completa..."
sleep 5

# Obtener información de autenticación y monitores desde la base de datos
log "Consultando base de datos para obtener monitores..."

# Consultar usuarios y monitores
QUERY_RESULT=$(mysql -u $DB_USER -h $DB_HOST $DB_NAME -N -e "
    SELECT u.auth, u.ke, m.mid, m.name 
    FROM Users u 
    JOIN Monitors m ON u.ke = m.ke 
    ORDER BY u.uid, m.mid;
" 2>&1)

if [ $? -ne 0 ]; then
    log "ERROR: No se pudo consultar la base de datos"
    log "$QUERY_RESULT"
    exit 1
fi

# Verificar que hay monitores
if [ -z "$QUERY_RESULT" ]; then
    log "ADVERTENCIA: No se encontraron monitores en la base de datos"
    exit 0
fi

# Procesar cada monitor
TOTAL_CAMERAS=0
ACTIVATED_CAMERAS=0
FAILED_CAMERAS=0

while IFS=$'\t' read -r AUTH_TOKEN GROUP_KEY MONITOR_ID MONITOR_NAME; do
    TOTAL_CAMERAS=$((TOTAL_CAMERAS + 1))
    
    log "Activando cámara: $MONITOR_NAME (ID: $MONITOR_ID)"
    
    # Construir URL de la API con parámetro reset para forzar el cambio
    # Formato: /:auth/monitor/:ke/:id/:mode?reset=1
    API_URL="http://$SHINOBI_HOST:$SHINOBI_PORT/$AUTH_TOKEN/monitor/$GROUP_KEY/$MONITOR_ID/record?reset=1"
    
    # Hacer la petición a la API
    RESPONSE=$(curl -s -w "\n%{http_code}" "$API_URL" 2>&1)
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    RESPONSE_BODY=$(echo "$RESPONSE" | head -n-1)
    
    if [ "$HTTP_CODE" = "200" ]; then
        # Verificar si la respuesta indica éxito
        if echo "$RESPONSE_BODY" | grep -q '"ok":true'; then
            # Verificar el mensaje específico
            if echo "$RESPONSE_BODY" | grep -Eq "cambiado|changed"; then
                log "✓ Cámara activada exitosamente: $MONITOR_NAME"
                ACTIVATED_CAMERAS=$((ACTIVATED_CAMERAS + 1))
            elif echo "$RESPONSE_BODY" | grep -Eq "ya es|already"; then
                # El monitor ya estaba en el modo correcto
                log "✓ Cámara ya estaba activa: $MONITOR_NAME"
                ACTIVATED_CAMERAS=$((ACTIVATED_CAMERAS + 1))
            else
                log "✓ Cámara procesada: $MONITOR_NAME"
                ACTIVATED_CAMERAS=$((ACTIVATED_CAMERAS + 1))
            fi
        else
            log "⚠ Respuesta inesperada para $MONITOR_NAME: $RESPONSE_BODY"
            FAILED_CAMERAS=$((FAILED_CAMERAS + 1))
        fi
    else
        log "✗ Error al activar $MONITOR_NAME (HTTP $HTTP_CODE)"
        log "   Respuesta: $RESPONSE_BODY"
        FAILED_CAMERAS=$((FAILED_CAMERAS + 1))
    fi
    
    # Pequeña pausa entre peticiones
    sleep 0.5
    
done <<< "$QUERY_RESULT"

# Resumen final
log "========================================="
log "Resumen de activación:"
log "  Total de cámaras: $TOTAL_CAMERAS"
log "  Activadas exitosamente: $ACTIVATED_CAMERAS"
log "  Fallidas: $FAILED_CAMERAS"
log "========================================="

# Verificar estado final en la base de datos
log "Verificando estado final en base de datos..."
FINAL_STATE=$(mysql -u $DB_USER -h $DB_HOST $DB_NAME -N -e "
    SELECT name, mode 
    FROM Monitors 
    ORDER BY mid;
" 2>&1)

log "Estado de monitores:"
while IFS=$'\t' read -r NAME MODE; do
    log "  - $NAME: $MODE"
done <<< "$FINAL_STATE"

log "========================================="
log "Auto-activación completada"
log "========================================="

exit 0
