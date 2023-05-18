import os
import sys

filename = "ffc.1.log"
current_dir = os.path.dirname(os.path.abspath(__file__))
file_path = os.path.join(current_dir, filename)
specific_string = "[I|ap]:[ADSP]tof_hpf"

if len(sys.argv) == 3: #e.g. python3 save_specificstr_line.py xxx.log xxx
    filename = sys.argv[1]
    specific_string = sys.argv[2]

with open(file_path, "r") as file:
    lines = file.readlines()
    save_lines = []
    for line in lines:
        line = line.strip()
        if line.find(specific_string) != -1:
            save_lines.append(line)


    output_file = os.path.splitext(filename)[0] + ".csv"
    output_path = os.path.join(current_dir, output_file)

with open(output_path, "w") as file:
    # file.write('print csv title\n')
    file.write("\n".join(save_lines))

print(f"Specific lines written to {output_file}")