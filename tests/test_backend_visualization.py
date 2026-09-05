import asyncio
import os
import unittest
from datetime import datetime, timezone
from types import SimpleNamespace

from qiskit.transpiler import CouplingMap

from quantum_status_agent.agent import _create_backend_canvas, _create_job_results_canvas
from quantum_status_agent.backend_visualization import (
    BACKEND_CANVAS_MARKER,
    canvas_marker,
    render_backend_dashboard,
)


class FakeBackend:
    name = "ibm_test"
    num_qubits = 5
    coupling_map = CouplingMap([(0, 1), (1, 2), (2, 3), (3, 4)])

    def status(self):
        return SimpleNamespace(operational=True, pending_jobs=2)

    def properties(self):
        qubits = [
            [
                SimpleNamespace(name="T1", value=100 + index),
                SimpleNamespace(name="T2", value=80 + index),
                SimpleNamespace(name="readout_error", value=0.01 + index / 1000),
            ]
            for index in range(5)
        ]
        gates = [
            SimpleNamespace(
                qubits=[0, 1],
                parameters=[SimpleNamespace(name="gate_error", value=0.002)],
            )
        ]
        return SimpleNamespace(
            qubits=qubits,
            gates=gates,
            last_update_date=datetime.now(timezone.utc),
        )


class BackendVisualizationTests(unittest.TestCase):
    def test_dashboard_is_a_nonempty_png(self):
        path = render_backend_dashboard(FakeBackend())
        try:
            with open(path, "rb") as image:
                content = image.read()
            self.assertTrue(content.startswith(b"\x89PNG\r\n\x1a\n"))
            self.assertGreater(len(content), 20_000)
        finally:
            os.unlink(path)

    def test_canvas_is_not_created_without_internal_marker(self):
        text, artifact = asyncio.run(_create_backend_canvas("ordinary status response", "ibm_test"))
        self.assertEqual(text, "ordinary status response")
        self.assertIsNone(artifact)

    def test_marker_round_trip(self):
        marker = canvas_marker("/tmp/quantum_lab_pngs/example.png")
        self.assertEqual(BACKEND_CANVAS_MARKER.search(marker).group(1), "/tmp/quantum_lab_pngs/example.png")

    def test_single_job_histogram_creates_canvas_with_local_query_time(self):
        artifact = _create_job_results_canvas(
            "![Job Results](agentstack://12345678-1234-1234-1234-123456789abc)",
            "test-job",
        )
        self.assertEqual(artifact.name, "Job test-job results")
        self.assertIn("Consulted locally:", artifact.parts[0].root.text)


if __name__ == "__main__":
    unittest.main()
