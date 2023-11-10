#!/usr/bin/env python3

import sys

def clean_sequence(sequence):
    cleaned_sequence = ''.join(['N' if c not in 'ATGCN-' else c for c in sequence])
    return cleaned_sequence

if len(sys.argv) != 3:
    print("Usage: {} input.fasta output.fasta".format(sys.argv[0]))
    sys.exit(1)

input_file = sys.argv[1]
output_file = sys.argv[2]

with open(input_file, 'r', encoding='utf-8') as in_fasta, open(output_file, 'w') as out_fasta:
    for line in in_fasta:
        if line.startswith('>'):
            out_fasta.write(line)
        else:
            cleaned_sequence = clean_sequence(line.strip())
            out_fasta.write(cleaned_sequence + '\n')

print("FASTA file cleaned and saved to", output_file)
