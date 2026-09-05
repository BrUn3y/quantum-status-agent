# 🚀 Quick Start Guide - Quantum Status Agent

## ⚡ Fast Setup (5 minutes)

### 1. Prerequisites
```bash
# Install uv (if not installed)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Verify installation
uv --version
```

### 2. Clone & Configure
```bash
# Navigate to the project
cd quantum-status-agent

# Copy environment template
cp .env.example .env

# Edit .env with your credentials
nano .env  # or use your preferred editor
```

### 3. Required Environment Variables
```env
# IBM Quantum Token (REQUIRED)
QISKIT_IBM_TOKEN=your_ibm_quantum_token_here

# Watsonx Credentials (REQUIRED)
WATSONX_API_KEY=your_api_key_here
WATSONX_PROJECT_ID=your_project_id_here

# Local Granite model
OLLAMA_API_BASE=http://127.0.0.1:11434
STATUS_MODEL=ollama:granite4.2:8b
STATUS_HOST=127.0.0.1
STATUS_PORT=8002
```

### 4. Run the Agent

**Option A: Using start script (Recommended)**
```bash
chmod +x start.sh
./start.sh
```

**Option B: Using uv directly**
```bash
uv run server
```

**Option C: Using Python**
```bash
uv sync
python -m quantum_status_agent.agent
```

### 5. Verify Agent is Running
```bash
# Check agent card
curl http://localhost:8002/.well-known/agent-card.json

# Test with a simple request
curl -X POST http://localhost:8002 \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{
      "role": "user",
      "content": "What quantum computers are available?"
    }]
  }'
```

## 🐳 Docker Quick Start

```bash
# Build
docker build -t quantum-status-agent .

# Run
docker run -p 8002:8002 --env-file .env quantum-status-agent

# Run in background
docker run -d -p 8002:8002 --env-file .env --name quantum-status quantum-status-agent
```

## 📝 Usage Examples

### List Available Backends
```bash
curl -X POST http://localhost:8002 \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{
      "role": "user",
      "content": "What quantum computers are available?"
    }]
  }'
```

### Get Backend Details
```bash
curl -X POST http://localhost:8002 \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{
      "role": "user",
      "content": "Give me detailed information about ibm_brisbane"
    }]
  }'
```

### Check Job Status
```bash
curl -X POST http://localhost:8002 \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{
      "role": "user",
      "content": "What is the status of job d671cklbujdc73cvbp30?"
    }]
  }'
```

### List Recent Jobs
```bash
curl -X POST http://localhost:8002 \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{
      "role": "user",
      "content": "Show me my recent jobs"
    }]
  }'
```

### Compare Multiple Jobs
```bash
curl -X POST http://localhost:8002 \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{
      "role": "user",
      "content": "Compare the results of jobs d6cd297g4t5c7385dh4g and d6cd2bknsg9c739a32p0"
    }]
  }'
```

## 🔧 Troubleshooting

### Port Already in Use
```bash
# Find process using port 8002
lsof -i :8002

# Kill the process
kill -9 <PID>
```

### Missing Dependencies
```bash
# Reinstall all dependencies
uv sync --reinstall
```

### IBM Quantum Connection Errors
- Verify your IBM Quantum token is correct
- Check you have access to IBM Quantum services
- Test connection: `python -c "from qiskit_ibm_runtime import QiskitRuntimeService; print(QiskitRuntimeService(token='YOUR_TOKEN').backends())"`

### Watsonx API Errors
- Verify your API key is correct
- Check project ID matches your Watsonx project
- For local inference, run `ollama pull granite4.2:8b`
- Check Watsonx service status

## 📚 What This Agent Does

✅ **Queries backend status** - Lists all available quantum computers
✅ **Gets technical info** - Detailed backend properties (qubits, errors, topology)
✅ **Checks job status** - Queries individual job status and results
✅ **Lists user jobs** - Shows recent, running, or completed jobs
✅ **Compares jobs** - Side-by-side comparison of multiple job results
✅ **Generates visualizations** - Automatic histogram generation for results

## 🔗 Integration

This agent can work:
- **Standalone**: Direct HTTP requests
- **A2A Protocol**: Agent-to-Agent communication
- **Part of Quantum Lab System**: Orchestrated by main agent

## 🛠️ Available Tools

1. **ibm_quantum_status** - List quantum computers with status
2. **ibm_quantum_info** - Get detailed backend information
3. **ibm_quantum_job** - Query job status and results
4. **ibm_quantum_job_comparison** - Compare multiple jobs

## 📖 Full Documentation

See [README.md](README.md) for complete documentation.

---

**Made with ❤️ using BeeAI, Granite, Ollama, and IBM Quantum**
