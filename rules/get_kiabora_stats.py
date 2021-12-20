#!/usr/bin/env python3
import csv
import sys
import os

def main():
    if len(sys.argv) < 2:
        print("the first input is the result directory")
        sys.exit();

    dirname = os.path.join(sys.argv[1], 'kiabora')
    stats_path = os.path.join(dirname, "stats.csv")

    with open(stats_path, 'w', encoding='UTF8') as stats_file:
        header = [ 'NAME', 'FES']
        writer = csv.writer(stats_file)
        writer.writerow(header)

        for kia_file in sorted(os.listdir(dirname)):
            if kia_file.endswith('.txt'):
                kia_name = os.path.splitext(kia_file)[0]
                kia_lines = open(os.path.join(dirname, kia_file), 'r').readlines()
                print(kia_name)

                line_count = 0

                while  (line_count < len(kia_lines)) and (kia_lines[line_count] != '===== PROPERTIES =====\n'):
                    if kia_lines[line_count] == '!!!TIMEOUT!!!\n':
                        row = [kia_name, 'TIMEOUT']
                        writer.writerow(row)
                        break;
                    line_count+=1

                if (line_count == len(kia_lines)) or kia_lines[line_count] != '===== PROPERTIES =====\n':
                    continue;

                keys = kia_lines[line_count + 4 ].split('|')
                values = kia_lines[line_count + 2 ].split('|')

                key_count = 0

                while (key_count < len(keys)) and (keys[key_count].strip() != 'fes') :
                    key_count+=1

                if key_count == len(keys):
                    continue;

                row = [kia_name, values[key_count]]
                writer.writerow(row)
            else:
                continue
        
main()
