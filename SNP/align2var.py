#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Apr 25 9:57:02 2023

@author: sdy
"""

from Bio import SeqIO
from Bio.Data import CodonTable
import argparse

parser = argparse.ArgumentParser(add_help = False, usage = '\npython3 align2var.py -i [fa] -o [tsv] -t [1-33]')
required = parser.add_argument_group()
optional = parser.add_argument_group()
required.add_argument('-i', '--input', metavar = '[fa]', help = 'input file，fasta format', required = True)
required.add_argument('-t', '--table', type=int, help = 'translation table', required = True)
required.add_argument('-o', '--output', metavar = '[tsv]', help = 'output file，tsv format', required = True)
optional.add_argument('-h', '--help', action = 'help', help = 'help info')
args = parser.parse_args()


# 设置密码子的translation table为标准表
table = CodonTable.unambiguous_dna_by_id[args.table]

# 读取fasta文件，选择第一个序列作为参考序列
records = list(SeqIO.parse(args.input,"fasta"))
#records = list(SeqIO.parse("alignment.fasta", "fasta"))
ref_seq = records[0].seq
ref_length = len(ref_seq)

# 判断序列长度是否为3的倍数
if ref_length % 3 != 0:
    print("序列长度不为3的倍数")
else:
    # 打开输出文件
    with open(args.output, "w") as f:
        # 输出表头
        f.write("pos\trefbase\t")
        for record in records[1:]:
            f.write(record.id + "\t")
        f.write("\n")

        # 遍历每个位点
        for i in range(ref_length):
            ref_base = ref_seq[i]

            # 输出参考序列的碱基
            f.write(str(i+1) + "\t" + str(ref_base) + "\t")

            # 遍历每个序列，判断其突变类型
            for record in records[1:]:
                seq = record.seq[i]

                if seq == "-":
                    # gap
                    f.write("-\t")
                elif seq == ref_base:
                    # a
                    f.write("a\t")
                else:
                    # 非同义突变或同义突变
                    ref_codon = ref_seq[(i // 3) * 3 : (i // 3 + 1) * 3]
                    mut_codon = ref_codon[: i % 3] + seq + ref_codon[i % 3 + 1 :]
                    ref_aa = ref_codon.translate(table=table)
                    mut_aa = mut_codon.translate(table=table)
                    if ref_aa == mut_aa:
                        f.write("s\t")
                    else:
                        f.write("n\t")

            f.write("\n")
