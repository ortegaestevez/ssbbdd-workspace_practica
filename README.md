# Cloudera Hadoop + Jupyter + Hue - Entorno para Práctica SBD

Configuración completamente funcional del contenedor Cloudera Hadoop con Jupyter Notebook y Hue iniciándose automáticamente.

## 🚀 Inicio Rápido

```bash
# 1. Iniciar el contenedor (primera vez descarga ~5-10 GB)
make up

# 2. Esperar 2-5 minutos para la inicialización completa

# 3. Verificar que los servicios están activos
make services

# 4. Abrir Jupyter en el navegador
make jupyter

# 5. Abrir Hue (opcional)
make hue
```

## 📋 Requisitos

- Docker instalado y corriendo
- Docker Compose v2
- 8 GB RAM disponible (mínimo 4 GB)
- ~10 GB espacio en disco

## 🌐 URLs de Acceso

Una vez iniciado el contenedor:

- **Jupyter Notebook**: http://localhost:8889
- **Hue**: http://localhost:8887
  - Usuario: `cloudera`
  - Password: `cloudera`
- **HDFS NameNode UI**: http://localhost:50070
- **YARN ResourceManager**: http://localhost:8088

## 📚 Comandos Principales

### Gestión del Contenedor

```bash
make up          # Inicia el contenedor con todos los servicios
make down        # Para el contenedor (mantiene datos)
make restart     # Reinicia el contenedor completo
make logs        # Ver logs en tiempo real
make exec        # Conectar terminal bash al contenedor
make status      # Ver estado del contenedor
```

### Gestión de Servicios

```bash
make services        # Verificar estado de Jupyter y Hue
make restart-jupyter # Reiniciar solo Jupyter
make restart-hue     # Reiniciar solo Hue
make restart-all     # Reiniciar ambos servicios web
```

### Acceso Web

```bash
make jupyter         # Abrir Jupyter en navegador
make hue             # Abrir Hue en navegador
make jupyter-logs    # Ver logs de Jupyter
make jupyter-token   # Mostrar token de Jupyter (si aplica)
```

### Ayuda

```bash
make help           # Ver todos los comandos disponibles
make info           # Información del sistema
```

## 🔧 Solución de Problemas

### Servicios no inician automáticamente

Si después de 5 minutos los servicios no están activos:

```bash
# Reiniciar servicios manualmente
make restart-all

# Verificar estado
make services
```

### Jupyter no responde

```bash
# Ver logs de Jupyter
make jupyter-logs

# Reiniciar Jupyter específicamente
make restart-jupyter
```

### Hue no responde

```bash
# Verificar estado
docker exec mids-cloudera-hadoop-quickstart service hue status

# Reiniciar Hue
make restart-hue
```

### Puerto ya en uso

Si recibes error de puerto ocupado:

```bash
# Ver qué está usando el puerto 8889 (Jupyter)
sudo lsof -i :8889

# Ver qué está usando el puerto 8887 (Hue)
sudo lsof -i :8887

# Modificar puertos en docker-compose.yml si es necesario
```

### Contenedor no inicia

```bash
# Ver logs del contenedor
make logs

# Verificar recursos disponibles
docker stats

# Reiniciar Docker daemon
sudo systemctl restart docker
```

## 📁 Estructura del Proyecto

```
mids-cloudera-hadoop/
├── docker-compose.yml      # Configuración del contenedor
├── Makefile                # Comandos de gestión
├── start-services.sh       # Script auxiliar de inicio
├── README.md              # Este archivo
└── workspace/             # Tu workspace para notebooks y datos
    ├── notebooks/         # Jupyter notebooks
    └── data/             # Datos para prácticas
```

## 🔍 Verificación Post-Instalación

Después de iniciar el contenedor por primera vez:

```bash
# 1. Verificar que el contenedor está corriendo
make status

# 2. Esperar 2-5 minutos para inicialización completa

# 3. Verificar servicios web
make services

# Deberías ver:
# ✅ Jupyter: Proceso corriendo, Puerto 8889 escuchando
# ✅ Hue: Servicio corriendo, Puerto 8888 escuchando
```

## 💾 Persistencia de Datos

Los datos se guardan en:

- **Notebooks**: `./workspace/` (montado desde tu máquina local)
- **HDFS data**: Volúmenes Docker nombrados (persisten entre reinicios)

Para eliminar TODO (incluyendo datos):

```bash
make prune  # ⚠️ CUIDADO: Esto borra TODOS los datos
```

## 🎓 Uso para Práctica SBD

### Acceder al contenedor

```bash
make exec
# Ahora estás dentro del contenedor con acceso a Hadoop
```

### Comandos Hadoop útiles

```bash
# Ver archivos en HDFS
hdfs dfs -ls /

# Ver estado del cluster
hdfs dfsadmin -report

# Crear directorio en HDFS
hdfs dfs -mkdir /user/cloudera/test

# Copiar archivo a HDFS
hdfs dfs -put archivo.txt /user/cloudera/

# Ver estado de YARN
yarn node -list
```

### Usar Hive

```bash
# Entrar a Hive CLI
hive

# O usar Beeline (recomendado)
beeline -u jdbc:hive2://localhost:10000
```

### Crear Notebook Jupyter

1. Acceder a http://localhost:8889
2. New → Python 2 (o Python 3 si disponible)
3. Tu notebook se guardará automáticamente en `workspace/`

## 📝 Notas Importantes

1. **Tiempo de inicio**: El contenedor tarda 2-5 minutos en estar completamente operativo
2. **Memoria**: Asegurar al menos 4 GB RAM disponible (8 GB recomendado)
3. **Token Jupyter**: Configurado sin token (acceso directo), ver `Dockerfile` para cambiar
4. **Hue credentials**: `cloudera` / `cloudera`
5. **Jupyter sin --allow-root**: La versión de Jupyter en el contenedor NO soporta este flag

## 🆘 Soporte

Si encuentras problemas:

1. Verifica logs: `make logs`
2. Verifica estado: `make services`
3. Reinicia servicios: `make restart-all`
4. Reinicia contenedor: `make restart`

## 🔗 Enlaces Útiles

- [Documentación Cloudera](https://docs.cloudera.com/)
- [Guía Jupyter Notebook](https://jupyter-notebook.readthedocs.io/)
- [Hue User Guide](https://docs.gethue.com/)
- [Apache Hadoop](https://hadoop.apache.org/)

---

**Creado para**: Práctica de Sistemas de Bases de Datos (SBD)  
**Última actualización**: 2025-11-07
