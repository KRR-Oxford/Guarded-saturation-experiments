#!/usr/bin/env python3
import csv
import sys
import os

def main():
    if len(sys.argv) < 2:
        print("the first input is the result directory")
        sys.exit();

    dirname = sys.argv[1]
    stats_path = os.path.join(dirname, "output_stats.csv")

    with open(stats_path, 'w', encoding='UTF8') as stats_file:
        header = [ 'NAME', 'BODY_AVG', 'BODY_MAX', 'HEAD_AVG', 'HEAD_MAX', 'COUNT' ]
        writer = csv.writer(stats_file)
        writer.writerow(header)

        for rule_file in sorted(os.listdir(dirname)):
            if rule_file.endswith('.rul'):
                print(rule_file)
                rule_name = os.path.splitext(rule_file)[0]
                rule_lines = open(os.path.join(dirname, rule_file), 'r').readlines()
                count = 0
                body_sum_size=0
                body_max_size=0
                head_sum_size=0
                head_max_size=0
                for line in rule_lines:
                    impl_index = line.find(':-')
                    if impl_index == -1:
                        continue
                    body_size = line.count('),', impl_index) + line.count(').', impl_index)
                    head_size = line.count('),', 0, impl_index) + line.count('):', 0, impl_index + 1)
                    if head_size >= 2 :
                        print(line)
                    count+=1
                    body_sum_size += body_size
                    head_sum_size += head_size
                    body_max_size = max(body_size, body_max_size)
                    head_max_size = max(head_size, head_max_size)

                if count > 0:
                    row = [rule_name, body_sum_size/count, body_max_size, head_sum_size/count, head_max_size, count]
                    writer.writerow(row)
                    # print('body: ' + str(body_sum_size/count))
                    # print('head: ' + str(head_sum_size/count))
                    # print('max body: ' + str(body_max_size))
                    # print('max head: ' + str(head_max_size))
            else:
                continue
        
main()
