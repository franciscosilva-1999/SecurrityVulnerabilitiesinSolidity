import re
import sys
import os

def refine_dataset(input_file, output_file):
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
    if len(sys.argv) != 2:
        print("<path-to-solidity-file(s)> must be specified as second argument.")
    else:
        if sys.argv[1].endswith(".sol"):
            input_file = sys.argv[1]
            base, ext = os.path.splitext(input_file)
            output_file = f"{base}_refined{ext}"
            refine_dataset(input_file, output_file)
        else:
            directory = sys.argv[1]
            for file in os.listdir(directory):
                if file.endswith(".sol"):
                     base, ext = os.path.splitext(file)
                     output_file = f"{base}_refined{ext}"
                     refine_dataset(os.path.join(directory, file), output_file)