#!/bin/bash

# Script para probar el Status Agent directamente
# Verifica si está trayendo correctamente los datos del job

echo "=========================================="
echo "🧪 Probando Status Agent (puerto 8002)"
echo "=========================================="
echo ""

# Verificar si el Status Agent está corriendo
echo "1️⃣ Verificando si el Status Agent está activo..."
if ! curl -s http://localhost:8002/health > /dev/null 2>&1; then
    echo "❌ El Status Agent no está corriendo en puerto 8002"
    echo "   Inicia el servidor con: python -m quantum_status_agent.agent"
    exit 1
fi
echo "✅ Status Agent está activo"
echo ""

# Probar consulta del job específico
echo "2️⃣ Consultando job d7nu2dak4prs73dsold0..."
echo ""

RESPONSE=$(curl -s -X POST http://localhost:8002/agent \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Muestra los resultados del job d7nu2dak4prs73dsold0"
  }')

echo "📋 Respuesta del Status Agent:"
echo "=========================================="
echo "$RESPONSE" | jq -r '.response // .message // .' 2>/dev/null || echo "$RESPONSE"
echo "=========================================="
echo ""

# Verificar si hay errores en la respuesta
if echo "$RESPONSE" | grep -q "contact IBM Quantum support"; then
    echo "⚠️  PROBLEMA DETECTADO: Mensaje genérico encontrado"
    echo "   El Status Agent no está retornando los datos reales del job"
elif echo "$RESPONSE" | grep -q "Error"; then
    echo "❌ Error en la respuesta"
elif echo "$RESPONSE" | grep -q "Job ID"; then
    echo "✅ Respuesta parece correcta (contiene información del job)"
else
    echo "⚠️  Respuesta inesperada"
fi

echo ""
echo "=========================================="
echo "💡 Tip: Revisa los logs del Status Agent"
echo "   en la terminal donde lo ejecutaste"
echo "=========================================="
