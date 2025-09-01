import subprocess
import unittest
import os
import sys
import re

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "analysis")))

from run_ollama import run_ollama
from run_slither import run_slither, set_solc_version


class TestRunOllama(unittest.TestCase):
    def test_nonexistent_file_exits_with_code_1(self):
        with self.assertRaises(SystemExit) as cm:
            run_ollama("nonexistent_file.sol")
        self.assertEqual(cm.exception.code, 1)


class TestRunSlither(unittest.TestCase):
    def test_nonexistent_file_exits_with_code_1(self):
        with self.assertRaises(SystemExit) as cm:
            run_slither("nonexistent_file.sol")
        self.assertEqual(cm.exception.code, 1)

    def test_nonexistent_pragma_with_code_2(self):
        sol_file = os.path.join(os.path.dirname(__file__), "nopragama.sol")
        with self.assertRaises(SystemExit) as cm:
            set_solc_version(sol_file)
        self.assertEqual(cm.exception.code, 2)

class TestSolcVersionSafe(unittest.TestCase):

    def test_version_matches_file(self):
        sol_file = os.path.join(os.path.dirname(__file__), "contract1.sol")

        with open(sol_file, "r") as f:
            code = f.read()
        match = re.search(r"pragma solidity\s+([^;]+);", code)

        expected_version = match.group(1).replace("^", "").strip()
        set_solc_version(sol_file)

         # Check the currently active solc version
        result = subprocess.run(["solc", "--version"], capture_output=True, text=True, check=True)
        current_version = result.stdout.strip().split()[-1].split("+")[0] 
        self.assertEqual(current_version, expected_version)
      

if __name__ == "__main__":
    unittest.main()
