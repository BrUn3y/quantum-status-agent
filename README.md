# 📊 Quantum Status Agent

Specialized agent for querying IBM Quantum backend status, technical information, and job results in real-time.

## 🎯 Overview

The Quantum Status Agent provides real-time IBM Quantum information using BeeAI with Granite 4.2 8B through Ollama (`ollama:granite4.2:8b`).

### Key Features

- 🔬 **Backend Status Queries**: Lists all available quantum computers with operational status
- ⚛️ **Technical Information**: Detailed backend properties (qubits, errors, topology)
- 🗺️ **Backend Canvas**: Live chip topology, readout errors, queue, calibration, and coherence summary
- 📈 **Job Results Canvas**: Opens freshly retrieved measurement histograms with the local query timestamp
- 📊 **Job Status & Results**: Queries individual job status and measurement results
- 🔄 **Job Comparison**: Side-by-side comparison of multiple quantum jobs
- 🖼️ **Visual Histograms**: Automatic generation of result visualizations
- 🤖 **A2A Protocol**: Can be invoked by other agents via Agent-to-Agent communication

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│     Quantum Status Agent (Port 8002)    │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │   ReActAgent (Granite 4.2 8B)  │ │
│  │   - Reasoning & Acting Pattern    │ │
│  │   - Tool Selection & Execution    │ │
│  └───────────────────────────────────┘ │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │         Query Tools               │ │
│  │  • IBMQuantumStatusTool           │ │
│  │  • IBMQuantumInfoTool             │ │
│  │  • IBMQuantumJobTool              │ │
│  │  • IBMQuantumJobComparisonTool    │ │
│  └───────────────────────────────────┘ │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │      IBM Quantum Service          │ │
│  │  • QiskitRuntimeService           │ │
│  │  • Backend queries                │ │
│  │  • Job retrieval                  │ │
│  └───────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

## 📋 Prerequisites

- Python 3.11 or higher

## 📦 Project Dependencies

### Main Dependencies (pyproject.toml)

```toml
[project]
requires-python = ">=3.11,<4.0"
dependencies = [
    "agentstack-sdk==0.4.0rc1",      # Framework for creating agents
    "beeai_framework>=0.1.76",        # BeeAI Framework for agents
    "qiskit>=1.0.0",                  # IBM Quantum SDK
    "qiskit-ibm-runtime>=0.20.0",    # IBM Quantum Runtime
    "python-dotenv>=1.0.0",           # Environment variable management
    "matplotlib>=3.7.0",              # Histogram generation
]
```

### System Dependencies

1. **Python 3.11+**
   ```bash
   python --version  # Must be 3.11 or higher
   ```

2. **uv** (Package Manager - Recommended)
   ```bash
   # Install uv
   curl -LsSf https://astral.sh/uv/install.sh | sh
   
   # Verify installation
   uv --version
   ```

3. **IBM Watsonx** (Credentials required)
   - Watsonx API Key
   - Watsonx Project ID
   - Get them at: https://cloud.ibm.com/

4. **IBM Quantum** (Credentials required)
   - IBM Quantum Token
   - Get it at: https://quantum.ibm.com/

## 🎯 Specific Purpose

This agent is the **status query specialist** of the multi-agent system:

**Responsibilities:**
- ✅ List available quantum backends (simulators and real hardware)
- ✅ Query technical backend information (qubits, errors, topology)
- ✅ Get individual job status
- ✅ Retrieve completed execution results
- ✅ Compare results from multiple jobs
- ✅ Generate measurement histograms
- ✅ Provide real-time information

**Does NOT:**
- ❌ Does not generate quantum code (use Developer Agent for that)
- ❌ Does not execute circuits (use Computing Agent for that)
- ❌ Only queries, does not modify or execute

**Communication:**
- Receives requests via A2A from Operations Agent (port 8000)
- Responds with tables, statuses, and formatted results
- Can be invoked directly on port 8002

**Available tools:**
1. `IBMQuantumStatusTool` - Lists available backends
2. `IBMQuantumInfoTool` - Detailed backend information
3. `IBMQuantumJobTool` - Job status and results
4. `IBMQuantumJobComparisonTool` - Multi-job comparison

- [uv](https://github.com/astral-sh/uv) package manager (recommended)
- IBM Quantum account with API token
- IBM Watsonx account with API key

## 🚀 Quick Start

### 1. Clone and Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd quantum-status-agent

# Copy environment template
cp .env.example .env
```

### 2. Configure Environment Variables

Edit `.env` with your credentials:

```bash
# IBM Quantum Configuration
QISKIT_IBM_TOKEN=your_ibm_quantum_token_here

# IBM Watsonx Configuration
WATSONX_API_URL=https://us-south.ml.cloud.ibm.com/ml/v1/text/chat?version=2023-05-29
WATSONX_API_KEY=your_watsonx_api_key_here
WATSONX_PROJECT_ID=your_watsonx_project_id_here

# Status Agent Model
OLLAMA_API_BASE=http://127.0.0.1:11434
STATUS_MODEL=ollama:granite4.2:8b

# Server Configuration
STATUS_HOST=127.0.0.1
STATUS_PORT=8002
```

### 3. Install Dependencies

Using uv (recommended):
```bash
uv venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
uv pip install -e .
```

Using pip:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -e .
```

### 4. Run the Agent

**Option A: Using the start script (recommended)**
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
python -m quantum_status_agent.agent
```

The agent will start on `http://127.0.0.1:8002`

## 🔧 Available Tools

### 1. IBM Quantum Status Tool

Lists all available quantum computers with their operational status.

**Parameters:**
- `only_hardware` (bool): If true, shows only real quantum hardware (no simulators)

**Example Query:**
```
"What quantum computers are available?"
"Which is the least busy backend?"
"Show me only real quantum hardware"
```

**Output:**
- Table with all backends
- Type (Hardware/Simulator)
- Number of qubits
- Operational status
- Jobs in queue
- Recommendation for least busy

### 2. IBM Quantum Info Tool

Gets detailed technical information about a specific backend.

**Parameters:**
- `backend_name` (str): Name of the backend (e.g., "ibm_brisbane")

**Example Query:**
```
"Give me detailed information about ibm_brisbane"
"What are the properties of ibm_kingston?"
"How many qubits does ibm_kyiv have?"
```

**Output:**
- Qubit properties (T1, T2, frequency)
- Quantum gate errors
- Connectivity topology rendered as an Agent Stack Canvas artifact
- Visual health summary with queue, calibration, readout error, two-qubit error, T1, and T2 medians
- Supported operations
- Processor configuration

Canvas is generated only when the request names exactly one `ibm_*` backend. Backend lists and job queries remain text responses.

### 3. IBM Quantum Job Tool

Queries the status and results of quantum jobs.

**Parameters:**
- `job_id` (str): Job ID to query, or empty to list all jobs
- `filter_status` (str): Filter by status ("all", "running", "queued", "done", "error")

**Example Query:**
```
"What is the status of job d671cklbujdc73cvbp30?"
"Show me my recent jobs"
"Show me my running jobs"
"List my completed jobs"
```

**Output:**
- Job status (QUEUED, RUNNING, DONE, ERROR)
- Measurement results (if completed)
- Probability distribution
- Visual histogram (PNG)
- Recent jobs table (if listing)

### 4. IBM Quantum Job Comparison Tool

Compares results from multiple quantum jobs side by side.

**Parameters:**
- `job_ids` (list): List of 2 to 5 Job IDs to compare

**Example Query:**
```
"Compare the results of jobs d6cd297g4t5c7385dh4g and d6cd2bknsg9c739a32p0"
"Compare jobs abc123 and xyz789"
"What is the difference between these jobs: job1, job2, job3?"
```

**Output:**
- Comparative table with results from each job
- Analysis of differences
- Identification of patterns
- Most probable states from each job

## 💬 Usage Examples

### Example 1: List Available Backends

**Query:**
```
What quantum computers are available?
```

**Response:**
```
🔬 **Available Quantum Computers on IBM Quantum**

| Backend | Type | Qubits | Status | Queue | Version |
|---------|------|--------|--------|-------|---------|
| ibm_brisbane | ⚛️ Hardware | 127 | 🟢 OK | 5 | 2 |
| ibm_kyoto | ⚛️ Hardware | 127 | 🟢 OK | 12 | 2 |
| ibm_osaka | ⚛️ Hardware | 127 | 🟢 OK | 8 | 2 |
| simulator_statevector | 💻 Simulator | 5000 | 🟢 OK | 0 | 1 |

💡 **Recommendation:** ibm_brisbane has the shortest queue (5 jobs)
```

### Example 2: Backend Technical Details

**Query:**
```
Give me detailed information about ibm_brisbane
```

**Response:**
```
⚛️ **IBM Brisbane - Technical Information**

**General:**
- Qubits: 127
- Status: 🟢 Operational
- Queue: 5 jobs
- Version: 2

**Qubit Properties (Average):**
- T1 (relaxation): 245.3 μs
- T2 (coherence): 189.7 μs
- Frequency: 4.85 GHz
- Readout error: 1.2%

**Gate Errors:**
- Single-qubit gates: 0.03%
- Two-qubit gates (CX): 0.8%

**Topology:** Heavy-hex lattice
**Max Circuits:** 300
**Max Shots:** 100,000
```

### Example 3: Job Status Query

**Query:**
```
What is the status of job d671cklbujdc73cvbp30?
```

**Response:**
```
📊 **Job Status: d671cklbujdc73cvbp30**

**Status:** ✅ DONE
**Backend:** ibm_brisbane
**Shots:** 1024
**Created:** 2024-03-05 14:23:15 UTC

**Results:**
| State | Counts | Probability |
|-------|--------|-------------|
| 100   | 963    | 94.04%      |
| 000   | 31     | 3.03%       |
| 101   | 18     | 1.76%       |
| 001   | 12     | 1.17%       |

[Histogram visualization]

🎯 **Interpretation:** Grover's algorithm successfully found the target state |100⟩ with 94% probability.
```

### Example 4: Compare Multiple Jobs

**Query:**
```
Compare the results of jobs d6cd297g4t5c7385dh4g and d6cd2bknsg9c739a32p0
```

**Response:**
```
🔄 **Job Comparison**

| State | Job 1 (d6cd297g...) | Job 2 (d6cd2bkn...) |
|-------|---------------------|---------------------|
| 00    | 512 (50.0%)        | 498 (48.6%)        |
| 11    | 498 (48.6%)        | 514 (50.2%)        |
| 01    | 8 (0.8%)           | 7 (0.7%)           |
| 10    | 6 (0.6%)           | 5 (0.5%)           |

**Analysis:**
- Both jobs show Bell state entanglement pattern
- Expected distribution: ~50% |00⟩ and ~50% |11⟩
- Small variations are due to quantum noise
- Results are consistent between executions
```

## 🐳 Docker Deployment

### Build Image

```bash
docker build -t quantum-status-agent .
```

### Run Container

```bash
docker run -d \
  --name quantum-status-agent \
  -p 8002:8002 \
  --env-file .env \
  quantum-status-agent
```

### Docker Compose

```yaml
version: '3.8'

services:
  quantum-status-agent:
    build: .
    ports:
      - "8002:8002"
    env_file:
      - .env
    restart: unless-stopped
```

## 🔗 A2A Integration

This agent can be invoked by other agents using the A2A (Agent-to-Agent) protocol.

### Example: Invoke from Lab Agent

```python
from agentstack_sdk.a2a.client import A2AClient

# Create A2A client
status_client = A2AClient(base_url="http://127.0.0.1:8002")

# Query backend status
response = await status_client.run(
    input="What quantum computers are available?",
    context=context
)
```

### Exposed Skills

The agent exposes the following skills via A2A:

1. **quantum-backend-status**: Backend availability queries
2. **quantum-backend-info**: Technical backend information
3. **quantum-job-status**: Job status and results
4. **quantum-job-comparison**: Multi-job comparison

## 📊 Agent Behavior

### Tool Selection Logic

The agent uses a ReAct (Reasoning and Acting) pattern to:

1. **Analyze** the user query
2. **Select** the appropriate tool
3. **Execute** the tool with correct parameters
4. **Format** the response with the tool output

### Response Format

All responses follow this structure:

1. **Tool Output**: Complete, unmodified data from the tool
2. **Context**: Brief explanation or interpretation
3. **Suggestions**: Next steps or related queries (optional)

### Critical Rules

- ✅ **Always use a tool** - Never respond without querying IBM Quantum
- ✅ **Show complete data** - Never summarize or omit information
- ✅ **Exact format** - Copy tool output exactly as returned
- ❌ **Never invent data** - All information must come from tools

## 🛠️ Development

### Project Structure

```
quantum-status-agent/
├── src/
│   └── quantum_status_agent/
│       ├── __init__.py
│       ├── agent.py              # Main agent logic
│       └── tools/
│           ├── __init__.py
│           ├── quantum_status_tool.py      # Backend listing
│           ├── quantum_info_tool.py        # Backend details
│           ├── quantum_job_tool.py         # Job queries
│           └── quantum_job_comparison_tool.py  # Job comparison
├── pyproject.toml               # Dependencies
├── .env.example                 # Environment template
├── .gitignore
├── Dockerfile
├── start.sh                     # Startup script
└── README.md
```

### Adding New Tools

1. Create a new tool class in `src/quantum_status_agent/tools/`
2. Inherit from `Tool` base class
3. Implement `inputSchema()` and `_run()` methods
4. Register in `tools/__init__.py`
5. Add to agent's tool list in `agent.py`

### Testing

```bash
# Install dev dependencies
uv pip install -e ".[dev]"

# Run tests
pytest

# Type checking
mypy src/
```

## 🔒 Security

- Never commit `.env` file with real credentials
- Use environment variables for all sensitive data
- Rotate API keys regularly
- Use HTTPS in production
- Implement rate limiting for public deployments

## 📝 Environment Variables Reference

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `QISKIT_IBM_TOKEN` | IBM Quantum API token | Yes | - |
| `WATSONX_API_URL` | Watsonx API endpoint | Yes | - |
| `WATSONX_API_KEY` | Watsonx API key | Yes | - |
| `WATSONX_PROJECT_ID` | Watsonx project ID | Yes | - |
| `STATUS_MODEL` | BeeAI provider-qualified model | No | ollama:granite4.2:8b |
| `STATUS_HOST` | Server host | No | 127.0.0.1 |
| `STATUS_PORT` | Server port | No | 8002 |

## 🐛 Troubleshooting

### Agent won't start

**Problem:** Missing environment variables

**Solution:**
```bash
# Check .env file exists
ls -la .env

# Verify all required variables are set
cat .env | grep -E "QISKIT_IBM_TOKEN|WATSONX_API_KEY|WATSONX_PROJECT_ID"
```

### IBM Quantum connection errors

**Problem:** Invalid token or network issues

**Solution:**
```bash
# Test IBM Quantum connection
python -c "from qiskit_ibm_runtime import QiskitRuntimeService; QiskitRuntimeService(token='YOUR_TOKEN').backends()"
```

### Tool execution failures

**Problem:** Backend not found or job ID invalid

**Solution:**
- Verify backend name is correct (use status tool to list available backends)
- Check job ID format (should be alphanumeric string)
- Ensure job belongs to your IBM Quantum account

## 🔗 Related Repositories

This agent is part of the Quantum Computing Multi-Agent System. Here are the related repositories:

- **[Quantum Computing Agent](https://github.com/BrUn3y/quantum-computing-agent)** - Circuit execution specialist
- **[Quantum Status Agent](https://github.com/BrUn3y/quantum-status-agent)** - Status monitoring and job tracking (this repository)
- **[Quantum Developer Agent](https://github.com/BrUn3y/quantum-developer-agent)** - Code generation and algorithm implementation
- **[Quantum Lab Agent System](https://github.com/BrUn3y/quantum_lab_agent)** - Main orchestrator coordinating all agents

## 📚 Additional Resources

- [IBM Quantum Documentation](https://docs.quantum.ibm.com/)
- [Qiskit Documentation](https://qiskit.org/documentation/)
- [BeeAI Framework](https://github.com/i-am-bee/bee-agent-framework)
- [AgentStack SDK](https://github.com/agentstack/agentstack-sdk)
- [A2A Protocol Specification](https://github.com/agentstack/a2a-spec)

## 📄 License

[Your License Here]

## 👥 Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

## 📧 Support

For issues and questions:
- Open an issue on GitHub
- Contact: [your-email@example.com]

---

**Built with ❤️ using BeeAI Framework, IBM Watsonx, and IBM Quantum**
