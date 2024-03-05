# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 /path/to/requirements.txt /path/to/shell.nix"
    exit 1
fi

# Assign arguments to variables
input_file="$1"
output_file="$2"

# Check if the input file (requirements.txt) exists
if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found!"
    exit 1
fi

# Start the shell.nix file content
echo "let
  pkgs = import <nixpkgs> {};
in pkgs.mkShell {
  packages = [
    (pkgs.python3.withPackages (python-pkgs: [" > "$output_file"

# Read each line from the requirements.txt and add it to the shell.nix file
while IFS= read -r line; do
    echo "      python-pkgs.$line" >> "$output_file"
done < "$input_file"

# Finish the shell.nix file content
echo "    ]))
  ];
}" >> "$output_file"

echo "shell.nix file has been created at $output_file."
