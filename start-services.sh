#!/bin/bash
# Script de inicio de servicios Jupyter y Hue
# Para el contenedor Cloudera Hadoop quickstart
# Autor: Generado automáticamente para práctica SBD

set -e  # Sale si hay errores

echo "═══════════════════════════════════════════════════════════"
echo "  🚀 Iniciando servicios Jupyter y Hue"
echo "═══════════════════════════════════════════════════════════"
echo ""

# ============================================================
# Función: Iniciar Hue
# ============================================================
start_hue() {
    echo "🎨 Iniciando Hue..."
    service hue start
    sleep 2
    
    if service hue status | grep -q "running"; then
        echo "  ✅ Hue iniciado correctamente"
    else
        echo "  ⚠️  Hue puede no haber iniciado correctamente"
    fi
}

# ============================================================
# Función: Iniciar Jupyter
# ============================================================
start_jupyter() {
    echo ""
    echo "📓 Iniciando Jupyter Notebook..."
    
    # Matar cualquier proceso jupyter existente
    pkill -f jupyter 2>/dev/null || true
    sleep 1
    
    # Iniciar Jupyter (SIN --allow-root porque no es compatible con esta versión)
    nohup /opt/anaconda/bin/jupyter notebook \
        --ip=0.0.0.0 \
        --port=8889 \
        --no-browser \
        --notebook-dir=/root \
        > /var/log/jupyter.log 2>&1 &
    
    sleep 3
    
    # Verificar que está corriendo
    if ps aux | grep -v grep | grep jupyter > /dev/null; then
        echo "  ✅ Jupyter iniciado correctamente"
    else
        echo "  ❌ Error al iniciar Jupyter"
        echo "  📋 Ver logs: cat /var/log/jupyter.log"
    fi
}

# ============================================================
# Función: Verificar servicios
# ============================================================
verify_services() {
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "  🔍 Verificación de servicios"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    
    echo "📊 Procesos activos:"
    ps aux | grep -E "jupyter|hue" | grep -v grep || echo "  ⚠️  No se encontraron procesos"
    
    echo ""
    echo "🔌 Puertos escuchando:"
    netstat -tuln | grep -E "8888|8889" || echo "  ⚠️  Puertos no están escuchando aún"
    
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "  🌐 URLs de acceso"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "  📓 Jupyter: http://localhost:8889"
    echo "  🎨 Hue:     http://localhost:8887 (cloudera/cloudera)"
    echo ""
    echo "💡 Si los servicios no responden, espera 1-2 minutos más"
    echo ""
}

# ============================================================
# Ejecución principal
# ============================================================
main() {
    start_hue
    start_jupyter
    verify_services
    
    echo "✅ Inicialización completada"
    echo ""
}

# Ejecutar
main
