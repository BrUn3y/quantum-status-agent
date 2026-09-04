#!/bin/bash

# Script para probar el Status Agent directamente
# Verifica si está trayendo correctamente los datos del job

PORT="${STATUS_PORT:-8002}"
HOST="${STATUS_HOST:-localhost}"

echo "=========================================="
echo "🧪 Probando Status Agent (puerto $PORT)"
echo "=========================================="
echo ""

# Verificar si el Status Agent está activo (agent card real, no /health)
echo "1️⃣ Verificando si el Status Agent está activo..."
if ! curl -s "http://$HOST:$PORT/.well-known/agent-card.json" > /dev/null 2>&1; then
    echo "❌ El Status Agent no está corriendo en puerto $PORT"
    echo "   Inicia el servidor con: uv run python -m quantum_status_agent.agent"
    exit 1
fi
echo "✅ Status Agent está activo"
echo ""

# Probar consulta del job específico vía JSON-RPC message/send en /jsonrpc/
echo "2️⃣ Consultando job d7nu2dak4prs73dsold0..."
echo ""

RESPONSE=$(curl -s -X POST "http://$HOST:$PORT/jsonrpc/" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": "1",
    "method": "message/send",
    "params": {
      "message": {
        "kind": "message",
        "messageId": "22222222-2222-2222-2222-222222222222",
        "role": "user",
        "parts": [{"kind": "text", "text": "Muestra los resultados del job d7nu2dak4prs73dsold0"}]
      }
    }
  }')

# La respuesta final está en el último mensaje de result.history (o
# result.status.message si la task terminó en estado "failed")
FINAL_TEXT=$(echo "$RESPONSE" | jq -r '
  (.result.history[-1].parts[0].text // .result.status.message.parts[0].text // .error.message // .)
' 2>/dev/null)

echo "📋 Respuesta del Status Agent:"
echo "=========================================="
echo "$FINAL_TEXT"
echo "=========================================="
echo ""

# Verificar si hay errores en la respuesta
if echo "$FINAL_TEXT" | grep -q "contact IBM Quantum support"; then
    echo "⚠️  PROBLEMA DETECTADO: Mensaje genérico encontrado"
    echo "   El Status Agent no está retornando los datos reales del job"
elif echo "$FINAL_TEXT" | grep -qi "error"; then
    echo "❌ Error en la respuesta"
elif echo "$FINAL_TEXT" | grep -q "Job ID"; then
    echo "✅ Respuesta parece correcta (contiene información del job)"
else
    echo "⚠️  Respuesta inesperada"
fi

echo ""
echo "=========================================="
echo "💡 Tip: Revisa los logs del Status Agent"
echo "   en la terminal donde lo ejecutaste"
echo "=========================================="
