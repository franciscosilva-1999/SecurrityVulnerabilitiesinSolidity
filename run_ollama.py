import sys
import csv
import os
import subprocess

def run_ollama(sol_path):
    try:
        with open(sol_path, "r") as f:
            solidity_code = f.read()
    except FileNotFoundError:
        print(f"Error: File '{sol_path}' not found.")
        sys.exit(1)
    filename = os.path.basename(sol_path)
   
    prompt = f"You are a tool able to detect security vulnerabilities in Solidity code.By analysing the code below, identify if there are any vulnerabilities present.:\n'''{solidity_code}'''\nAnswer the question indicating the following information:\n Vulnerability name: <name> \nLine number(s): <numbers>"

    # Call Ollama with CodeLlama
    try:
        result = subprocess.run(
            ["ollama", "run", "codellama"],
            input=prompt,
            text=True,
            capture_output=True,
            check=True
        )
        response = result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print("Error running Ollama:", e.stderr)
        sys.exit(1)

    # Save to CSV (append mode so multiple runs accumulate results)

    output_file = "codellama_output.csv"
    filename = os.path.basename(sol_path)
    prompt_name= "Prompt Analysys for file:" + filename

    with open(output_file, mode="a", newline="", encoding="utf-8") as csv_file:
        writer = csv.writer(csv_file)
        writer.writerow([prompt_name, response])

    print(f" Output saved to {output_file}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("<path-to-solidity-file(s)> must be specified as second argument.")
    else:
        if sys.argv[1].endswith(".sol"):
            run_ollama(sys.argv[1])
        else:
            directory = sys.argv[1]
            for file in os.listdir(directory):
                if file.endswith(".sol"):
                    run_ollama(os.path.join(directory, file))
