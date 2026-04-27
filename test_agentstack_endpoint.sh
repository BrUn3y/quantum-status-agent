#!/bin/bash

# Script para probar los endpoints correctos de AgentStack

echo "=========================================="
echo "🧪 Probando endpoints de AgentStack"
echo "=========================================="
echo ""

# 1. Verificar health endpoint
echo "1️⃣ Probando /health..."
curl -s http://localhost:8002/health | jq '.' 2>/dev/null || echo "No disponible"
echo ""

# 2. Listar agentes disponibles
echo "2️⃣ Probando /agents (lista de agentes)..."
curl -s http://localhost:8002/agents | jq '.' 2>/dev/null || echo "No disponible"
echo ""

# 3. Probar endpoint A2A (Agent-to-Agent)
echo "3️⃣ Probando endpoint A2A /a2a/..."
curl -s -X POST http://localhost:8002/a2a/quantum_status_agent \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {
        "role": "user",
        "content": "Muestra los resultados del job d7nu2dak4prs73dsold0"
      }
    ]
  }' | jq '.' 2>/dev/null || echo "No disponible"
echo ""

# 4. Probar endpoint de chat directo
echo "4️⃣ Probando /chat..."
curl -s -X POST http://localhost:8002/chat \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Muestra los resultados del job d7nu2dak4prs73dsold0"
  }' | jq '.' 2>/dev/null || echo "No disponible"
echo ""

# 5. Listar todos los endpoints disponibles
echo "5️⃣ Probando /openapi.json (documentación de API)..."
curl -s http://localhost:8002/openapi.json | jq '.paths | keys' 2>/dev/null || echo "No disponible"
echo ""

echo "=========================================="
echo "✅ Pruebas completadas"
echo "=========================================="
