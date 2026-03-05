"""
Quantum Status Agent - Quantum Status Query Specialist

This agent specializes in:
- Querying available quantum computers on IBM Quantum
- Obtaining detailed technical information about backends
- Querying status and results of quantum jobs
- Listing user's recent jobs

Model: mistralai/mistral-small-3-1-24b-instruct-2503 (Watsonx)
Port: 8002
Type: AgentStack Server with A2A (ReActAgent with query tools)
"""

from .tools import (
    IBMQuantumStatusTool,
    IBMQuantumInfoTool,
    IBMQuantumJobTool,
    IBMQuantumJobComparisonTool,
)

__all__ = [
    "IBMQuantumStatusTool",
    "IBMQuantumInfoTool",
    "IBMQuantumJobTool",
    "IBMQuantumJobComparisonTool",
]
__version__ = "1.0.0"
__author__ = "Edgar Bruney"
