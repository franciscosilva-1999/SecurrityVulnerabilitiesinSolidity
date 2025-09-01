import subprocess
import re
import sys
import csv
import os

#read the Solidity file to find the pragma version
def set_solc_version(sol_file):
    try:
        with open(sol_file, "r") as f:
            solidity_code = f.read()
    except FileNotFoundError:
        print(f"Error: File '{sol_file}' not found.")
        sys.exit(1)
    filename = os.path.basename(sol_file)
    match = re.search(r"pragma solidity\s+([^;]+);", solidity_code)
    if match: 
        version = match.group(1).replace("^", "").strip()
        # Check if the version is installed if not install it
        try:    
            subprocess.run(["solc-select", "install", version], check=True)
        except subprocess.CalledProcessError as e:
            print(f"Error installing solc version {version}: {e}")
            sys.exit(3)
        # Active version
        subprocess.run(["solc-select", "use", version], check=True)
    else:
        print("No pragma found, using default solc version")
        sys.exit(2)

# Run Slither on the Solidity file(s) using the detected version
def run_slither(sol_file):
    set_solc_version(sol_file)

    cmd = ["slither", sol_file]
    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode == 0:
        status = "No vulnerabilities found"
        message = result.stdout.strip()
    elif result.returncode == 255:  # Slither error code for vulnerabilities found
        status = "Vulnerabilities found:"
        message = result.stderr.strip()
    elif result.returncode == 1:
        status = "Error analysing smart contract"
        message = result.stderr.strip()
    else:
        status = f"Unknown return code {result.returncode}"
        message = result.stderr.strip()

    output_csv="slither_analysis_results.csv"
 
    with open(output_csv, mode="a", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        writer.writerow([sol_file, status, message])
    print(f"Results saved to {output_csv}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("<path-to-solidity-file(s)> must be specified as second argument.")
    else:
        if sys.argv[1].endswith(".sol"):
            run_slither(sys.argv[1])
        else:
            directory = sys.argv[1]
            for file in os.listdir(directory):
                if file.endswith(".sol"):
                    run_slither(os.path.join(directory, file))