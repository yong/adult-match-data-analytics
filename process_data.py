#!/usr/bin/env python3
import logging
import psycopg2
import psycopg2.extras
import argparse
import csv
import os
import re

# def write_file(file_lines, output_file):
#     max_arms = 0
#     max_arms_selected = 0
#     with open(output_file, 'w', newline='') as csvfile:
#         # fieldnames = file_lines[0].keys()
#         # writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
#         # writer.writeheader()
#         for line in file_lines:
#             num_arms = len(line["arms_matching_amois"])
#             max_arms = (num_arms if num_arms > max_arms else max_arms)
#
#             num_arms = len(line["selected_arms"])
#             max_arms_selected = (num_arms if num_arms > max_arms_selected else max_arms_selected)
#
#         print(f"max_arms: {max_arms}")
#         print(f"max_arms_selected: {max_arms_selected}")

def filename_to_ids(basename):
    r = []
    if basename.find("dynamic_amois_and_cnv_snv_match_filters") >= 0:
        iid = 1
    elif basename.find("cnv_snv_match_filters") >= 0:
        iid = 2
    elif basename.find("dynamic_amois_match_filters") >= 0:
        iid = 3
    elif basename.find("standard_match_filters") >= 0:
        iid = 4
    else:
        raise ValueError('check your input file name')

    if basename.find("no_exclusions") >= 0:
        eid = 1
    elif basename.find("disease_only_exclusions") >= 0:
        eid = 2
    elif basename.find("drugs_only_exclusions") >= 0:
        eid = 3
    elif basename.find("amoi_only_exclusions") >= 0:
        eid = 4
    elif basename.find("standard_exclusions") >= 0:
        eid = 5
    else:
        raise ValueError('check your input file name')

    return [iid, eid]

#ICCPTENs -> PTEN
def chop_ICC_and_s(gene):
    s = re.sub(r"^ICC", "", gene)
    return re.sub(r"s$", "", s)

def truncate_then_load_table(table_name, keys, values, cnx, cursor):
    print(values)
    cursor.execute('truncate ' + table_name)
    insert_query = 'insert into {} ({}) values %s'.format(table_name, keys)
    psycopg2.extras.execute_values(cursor, insert_query, values, template=None, page_size=100)
    cnx.commit()

def process_variants_file(input_file, cnx, cursor):
    ihc = []
    fusion = []
    cnv = []
    snv_mnv_indel = []
    with open(input_file, 'r') as f:
        reader = csv.reader(f)
        current_line = 0
        for row in reader:
            current_line += 1
            print("****line {}".format(current_line))

            if row[1] == 'NO_SEQUENCING_DATA':
                continue
            elif row[1] == 'ihc':
                #10009,ihc,ICCPTENs(chop of ICC and s at the end!!!!),POSITIVE
                ihc.append((row[0], chop_ICC_and_s(row[2]), row[3]))
            elif row[1] == 'fusion':
                #10011,fusion,TMPRSS2-ERG.T1E4.COSF38(id),ERG(gene1),100732(read depeth),TMPRSS2(2),100732(read depth2),COSF38(useless)
                fusion.append((row[0], row[2], row[3], row[4], row[5], row[6]))
            elif row[1] == 'cnv':
                #10004,cnv,CCND1,chr11,69456941,7.99999,8.0,7.60182,8.44006
                cnv.append((row[0], row[2], row[3], row[4], row[5], row[6], row[7], row[8]))
            elif row[1] == 'snv' or row[1] == 'mnv' or row[1] == 'indel':
                #10007,snv,COSM10704,chr17,7577094(position),G(ref),A(atl),0.868934(allel ),TP53(gene),Hotspot(oncomine),8,missense(classification),c.844C>T(cdns id),1999(read_depth!!!!),NM_000546.5(ncbi ),p.Arg282Trp(protein)
                snv_mnv_indel.append((row[0], row[2], row[1], row[8], row[3], row[4], row[7], row[5], row[6], row[9], row[11], row[10], row[13], row[15], row[14]))
    truncate_then_load_table("ihc", "patients_id, gene, result", ihc, cnx, cursor)
    truncate_then_load_table("fusion", "patients_id, fusion_id, gene_1, read_depth_gene_1, gene_2, read_depth_gene_2", fusion, cnx, cursor)
    #TODO float?
    #truncate_then_load_table("cnv", "patients_id, gene, chromosome, position, raw_copy_number, copy_number, ci_5, ci_95", cnv, cnx, cursor)
    truncate_then_load_table("snv_mnv_indel", "patients_id, variant_id, variant_type, gene, chromosome, position, allele_frequency, reference, alternative, oncomine_classification, cdns, classification, read_depth, protein, ncbi_reference_number", snv_mnv_indel, cnx, cursor)

def process_input_file(input_file, cnx, cursor, ids):
    with open(input_file, 'r') as f:
        reader = csv.reader(f)
        current_line = 0
        for row in reader:
            current_line += 1
            print("****line {}".format(current_line))

            arms = []
            for arm in row[5].split(';'):
                arms.append({"name":arm, "type":"POTENTIAL"})

            for arm in row[6].split(';'):
                arms.append({"name": arm, "type": "SELECTED"})

            for idx, element in enumerate(row):
                row[idx] = (None if element == "-" else element)

            patient_query = f"SELECT count(*) FROM patients WHERE id = '{row[0]}';"
            print(patient_query)
            cursor.execute(patient_query)

            if cursor.fetchone()[0] < 1:
                add_patient = f"INSERT INTO patients (patients_id, meddra_code, disease, vcf_version, sequencing_date, created_at, updated_at) " \
                              f"VALUES ({row[0]}, '{row[1]}', '{row[2]}', '{row[3]}', '{row[4]}', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);"
                print(add_patient)
                cursor.execute(add_patient)
                cnx.commit()

            add_patient_scenerios = f"INSERT INTO patient_scenerios (patients_id, inclusion_scenerios_id, " \
                                    f"exclusion_scenerios_id, created_at, updated_at) VALUES({row[0]},{ids[0]},{ids[1]}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);"
            print(add_patient_scenerios)
            cursor.execute(add_patient_scenerios)
            patient_scenerio_id = cursor.lastrowid

            for arm in arms:
                name = arm["name"]
                s_type = arm["type"]
                add_arm = f"INSERT INTO arms (patient_scenerios_id, arm, selection_type, created_at, updated_at) " \
                          f"VALUES ({patient_scenerio_id}, '{name}', '{s_type}', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);"
                print(add_arm)
                cursor.execute(add_arm)

            cnx.commit()

def process_files(input_files):
    cnx = psycopg2.connect(user=os.environ['REDSHIFT_USERNAME'], password=os.environ['REDSHIFT_PASSWORD'], database=os.environ['REDSHIFT_DB'], port=5439, host=os.environ['REDSHIFT_HOST'])
    cursor = cnx.cursor()

    for input_file in input_files:
        basename = os.path.basename(input_file)
        if basename.find('variants') == 0:
            process_variants_file(input_file, cnx, cursor)
        else:
            ids = filename_to_ids(basename)
            process_input_file(input_file, cnx, cursor, ids)

    cursor.close()
    cnx.close()

def get_file_names():
    parser = argparse.ArgumentParser(description='Input Files to Process.')
    parser.add_argument('-input_files', type=str, nargs='+', required=True, help='List of file names to process')

    return parser.parse_args()


# Main Code starts here
if __name__ == '__main__':
    process_files(get_file_names().input_files)
