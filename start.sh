#!/bin/bash

# Quantum Status Agent Startup Script
# This script starts the Quantum Status Agent server

echo "=========================================="
echo "🚀 Starting Quantum Status Agent"
echo "=========================================="

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  Warning: .env file not found"
    echo "📝 Creating .env from .env.example..."
    cp .env.example .env
    echo "✅ .env file created. Please edit it with your credentials."
    echo ""
    echo "Required credentials:"
    echo "  - QISKIT_IBM_TOKEN"
    echo "  - Ollama with granite4:small-h"
    echo ""
    exit 1
fi

# Load environment variables
export $(cat .env | grep -v '^#' | xargs)

# Check required environment variables
if [ -z "$QISKIT_IBM_TOKEN" ]; then
    echo "❌ Error: QISKIT_IBM_TOKEN not set in .env"
    exit 1
fi

echo "✅ Environment variables loaded"
echo "🤖 Model: Granite 4 Small H (Ollama)"
echo ""

# Start the agent with uv
echo "🚀 Starting Quantum Status Agent on port ${STATUS_PORT:-8002}..."
echo "📦 Using uv to run the agent..."
echo ""
uv run server
