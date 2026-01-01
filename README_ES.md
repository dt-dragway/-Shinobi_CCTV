# 🎥 Shinobi CCTV - Sistema de Videovigilancia

![Node.js](https://img.shields.io/badge/node-v20.19.5-green) ![MariaDB](https://img.shields.io/badge/MariaDB-11.8.3-blue) ![FFmpeg](https://img.shields.io/badge/FFmpeg-7.1.2-orange)

Sistema CCTV/NVR (Network Video Recorder) de código abierto basado en [Shinobi](https://shinobi.video), escrito en Node.js. Diseñado para grabar y monitorear cámaras IP y cámaras locales con soporte para múltiples usuarios.

---

## 📋 Características

- ✅ **Grabación continua** de cámaras IP y locales
- ✅ **Streaming en vivo** mediante WebSocket
- ✅ **Detección de movimiento** con regiones configurables
- ✅ **Multi-usuario** con permisos personalizables
- ✅ **Almacenamiento en la nube** (AWS S3, Backblaze B2)
- ✅ **Notificaciones** por email, Discord, MQTT
- ✅ **API REST** completa para integración
- ✅ **Soporte ONVIF** para cámaras compatibles
- ✅ **Timelapses** automáticos
- ✅ **Interfaz web responsive**

---

## 🖥️ Requisitos del Sistema

### Software Necesario

| Componente | Versión Instalada | Mínimo Requerido |
|------------|-------------------|------------------|
| **Node.js** | v20.19.5 | v8.11+ |
| **MariaDB/MySQL** | 11.8.3 | 15.1+ |
| **FFmpeg** | 7.1.2 | 3.3.3+ |
| **PM2** | Instalado | Recomendado |

### Hardware Recomendado

- **CPU:** 2+ cores (4+ recomendado para múltiples cámaras)
- **RAM:** 4GB mínimo (8GB+ recomendado)
- **Disco:** SSD recomendado para grabaciones
- **Red:** 100Mbps+ para streaming fluido

---

## 🚀 Instalación

### 1. Clonar el Repositorio

```bash
git clone https://github.com/dt-dragway/-Shinobi_CCTV.git
cd -Shinobi_CCTV
```

### 2. Instalar Dependencias

```bash
npm install
```

### 3. Configurar Base de Datos

#### Crear Base de Datos y Usuario

```bash
mysql -u root -p < sql/user.sql
mysql -u root -p < sql/framework.sql
```

O manualmente:

```sql
CREATE DATABASE IF NOT EXISTS ccio;
CREATE USER 'majesticflame'@'127.0.0.1' IDENTIFIED BY '';
GRANT ALL PRIVILEGES ON ccio.* TO 'majesticflame'@'127.0.0.1';
FLUSH PRIVILEGES;
```

### 4. Configurar Shinobi

#### Crear archivo de configuración

```bash
cp conf.sample.json conf.json
```

#### Editar configuración (opcional)

```bash
nano conf.json
```

Configuración básica:
```json
{
  "port": 8080,
  "db": {
    "host": "127.0.0.1",
    "user": "majesticflame",
    "password": "",
    "database": "ccio",
    "port": 3306
  }
}
```

### 5. Habilitar Interfaz de Superusuario

```bash
cp super.sample.json super.json
```

### 6. Iniciar Shinobi

#### Opción A: Con PM2 (Recomendado)

```bash
pm2 start camera.js --name camera
pm2 start cron.js --name cron
pm2 save
pm2 startup
```

#### Opción B: Modo Desarrollo

```bash
# Terminal 1
node camera.js

# Terminal 2
node cron.js
```

---

## 🔐 Acceso Inicial

### Interfaz de Superusuario

**URL:** http://localhost:8080/super

**Credenciales por defecto:**
- Email: `admin@shinobi.video`
- Contraseña: `admin`

> ⚠️ **Importante:** Cambia estas credenciales después del primer acceso.

### Crear Usuario Regular

1. Accede a http://localhost:8080/super
2. Inicia sesión con las credenciales de superusuario
3. Crea un nuevo usuario desde el panel
4. Cierra sesión y accede con el nuevo usuario en http://localhost:8080

---

## 📹 Agregar Cámaras

### Requisitos de la Cámara

Tu cámara debe soportar al menos uno de estos protocolos:
- **RTSP** (Recomendado)
- **ONVIF**
- **MJPEG**
- **HTTP/HTTPS**

### Configuración Básica

1. Accede al panel de usuario: http://localhost:8080
2. Haz clic en "Monitors" → "Add Monitor"
3. Completa la información:
   - **Name:** Nombre de la cámara
   - **Type:** RTSP, MJPEG, etc.
   - **Host:** IP de la cámara
   - **Port:** Puerto (usualmente 554 para RTSP)
   - **Path:** Ruta del stream
   - **Username/Password:** Credenciales de la cámara

### Ejemplo de URL RTSP

```
rtsp://usuario:contraseña@192.168.1.100:554/stream1
```

---

## ⚙️ Configuración Avanzada

### Almacenamiento Adicional

Edita `conf.json`:

```json
{
  "addStorage": [
    {
      "name": "segundo",
      "path": "/ruta/al/almacenamiento"
    }
  ]
}
```

### Notificaciones por Email

```json
{
  "mail": {
    "service": "gmail",
    "auth": {
      "user": "tu_email@gmail.com",
      "pass": "tu_contraseña_de_aplicacion"
    }
  }
}
```

### Almacenamiento en la Nube (AWS S3)

Configura desde el panel web en "Cloud Storage Settings".

---

## 🛠️ Comandos Útiles

### Gestión con PM2

```bash
# Ver procesos
pm2 list

# Ver logs
pm2 logs camera
pm2 logs cron

# Reiniciar
pm2 restart camera
pm2 restart cron

# Detener
pm2 stop camera
pm2 stop cron

# Eliminar
pm2 delete camera
pm2 delete cron
```

### Base de Datos

```bash
# Acceder a MySQL
mysql -u majesticflame -h 127.0.0.1 ccio

# Ver usuarios
SELECT * FROM Users;

# Ver monitores
SELECT * FROM Monitors;

# Ver videos
SELECT * FROM Videos ORDER BY time DESC LIMIT 10;
```

---

## 📁 Estructura del Proyecto

```
-Shinobi_CCTV/
├── camera.js           # Proceso principal del servidor
├── cron.js             # Tareas programadas
├── conf.json           # Configuración (no en git)
├── super.json          # Superusuario (no en git)
├── libs/               # Librerías del sistema
├── web/                # Interfaz web
│   ├── assets/         # CSS, JS, imágenes
│   ├── pages/          # Páginas HTML
│   └── libs/           # Librerías frontend
├── plugins/            # Plugins del sistema
├── sql/                # Scripts de base de datos
├── videos/             # Almacenamiento de videos
├── languages/          # Archivos de idioma
└── node_modules/       # Dependencias npm
```

---

## 🔧 Solución de Problemas

### El servidor no inicia

```bash
# Verificar que el puerto 8080 esté libre
sudo netstat -tulpn | grep 8080

# Verificar logs
pm2 logs camera
```

### No se conecta a la base de datos

```bash
# Verificar que MySQL esté corriendo
sudo systemctl status mysql

# Probar conexión
mysql -u majesticflame -h 127.0.0.1 ccio
```

### La cámara no se conecta

1. Verifica que la URL RTSP sea correcta
2. Prueba la URL en VLC Player
3. Revisa los logs: `pm2 logs camera`
4. Verifica que FFmpeg esté instalado: `ffmpeg -version`

### Problemas de permisos

```bash
# Dar permisos a las carpetas de videos
chmod -R 755 videos/
chmod -R 755 videos2/
```

---

## 📚 Documentación Adicional

- **Documentación Oficial:** http://shinobi.video/docs
- **Configuración de Cámaras:** http://shinobi.video/docs/cameras
- **API REST:** http://shinobi.video/docs/api
- **Comunidad:** https://shinobi.community
- **Discord:** https://discordapp.com/invite/mdhmvuH

---

## 🤝 Contribuir

Este es un fork personal del proyecto Shinobi. Para contribuir al proyecto original:

- **Repositorio Original:** https://gitlab.com/Shinobi-Systems/Shinobi
- **Guía de Contribución:** [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📄 Licencia

Este proyecto está basado en Shinobi y mantiene su licencia original.

Ver [LICENSE.md](LICENSE.md) y [COPYING.md](COPYING.md) para más detalles.

---

## 👨‍💻 Autor

**Fork mantenido por:** [@dt-dragway](https://github.com/dt-dragway)

**Proyecto Original:** Moe Alam, Shinobi Systems

---

## 🌟 Agradecimientos

- Al equipo de Shinobi Systems por crear este increíble software
- A la comunidad de código abierto
- A todos los contribuidores del proyecto original

---

## 📞 Soporte

- **Issues:** https://github.com/dt-dragway/-Shinobi_CCTV/issues
- **Documentación:** http://shinobi.video/docs
- **Comunidad:** https://shinobi.community

---

**¡Disfruta de tu sistema de videovigilancia!** 🎥✨
