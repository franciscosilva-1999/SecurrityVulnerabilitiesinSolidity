import re
import sys
import os

def refine_solidity_file(input_file, output_file):
    with open(input_file, "r") as f:
        code = f.read()

    # Remove single-line comments
    code = re.sub(r"//.*", "", code)

    # Remove multi-line comments
    code = re.sub(r"/\*[\s\S]*?\*/", "", code)

    # Replace contract name with xpto
    code = re.sub(r"\bcontract\s+\w+", "contract xpto", code)

    with open(output_file, "w") as f:
        f.write(code)



if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Use: python refine_solidity_file.py <path-to-solidity-file>")
        sys.exit(1)

    input_file = sys.argv[1]
    base, ext = os.path.splitext(input_file)
    output_file = f"{base}_refined{ext}"

    refine_solidity_file(input_file, output_file)
