#!/bin/bash

# Script para probar los endpoints reales del AgentStack A2A server
# (agent card + JSON-RPC message/send en /jsonrpc/)

PORT="${STATUS_PORT:-8002}"
HOST="${STATUS_HOST:-localhost}"

echo "=========================================="
echo "🧪 Probando endpoints de AgentStack (puerto $PORT)"
echo "=========================================="
echo ""

echo "1️⃣ Probando /.well-known/agent-card.json..."
curl -s "http://$HOST:$PORT/.well-known/agent-card.json" | jq '.' 2>/dev/null || echo "No disponible"
echo ""

echo "2️⃣ Probando JSON-RPC message/send en /jsonrpc/..."
curl -s -X POST "http://$HOST:$PORT/jsonrpc/" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": "1",
    "method": "message/send",
    "params": {
      "message": {
        "kind": "message",
        "messageId": "11111111-1111-1111-1111-111111111111",
        "role": "user",
        "parts": [{"kind": "text", "text": "Muestra los resultados del job d7nu2dak4prs73dsold0"}]
      }
    }
  }' | jq '.' 2>/dev/null || echo "No disponible"
echo ""

echo "=========================================="
echo "✅ Pruebas completadas"
echo "=========================================="
