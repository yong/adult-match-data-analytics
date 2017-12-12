# SELECT concat('DROP TABLE IF EXISTS ', table_name, ';') FROM information_schema.tables WHERE table_schema = 'match_da';
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS patient_scenerios;
DROP TABLE IF EXISTS inclusion_scenerios;
DROP TABLE IF EXISTS exclusion_scenerios;
DROP TABLE IF EXISTS arms;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE Patients (id int(10) NOT NULL, vcf_version varchar(10), sequencing_date varchar(10), disease varchar(255), meddra_code varchar(12), PRIMARY KEY(id));
CREATE TABLE inclusion_scenerios (id int(10) NOT NULL AUTO_INCREMENT, description varchar(255) NOT NULL UNIQUE, PRIMARY KEY (id));
CREATE TABLE exclusion_scenerios (id int(10) NOT NULL AUTO_INCREMENT, description varchar(255) NOT NULL UNIQUE, PRIMARY KEY (id));
CREATE TABLE patient_scenerios (id int(10) NOT NULL AUTO_INCREMENT, patients_id int(10) NOT NULL, inclusion_scenerios_id int(10) NOT NULL, exclusion_scenerios_id int(10) NOT NULL, PRIMARY KEY (id));
CREATE TABLE arms (id int(10) NOT NULL AUTO_INCREMENT, patient_scenerios_id int(10) NOT NULL, arm varchar(25) NOT NULL, selection_type varchar(255) DEFAULT 'POTENTIAL' NOT NULL, PRIMARY KEY (id));
CREATE TABLE snv_mnv_indel (id int(10) NOT NULL AUTO_INCREMENT, Patientsid int(10) NOT NULL, variant_id varchar(45), variant_type varchar(9) NOT NULL, gene varchar(10) NOT NULL, chromosome varchar(5), position int(15) NOT NULL, allele_frequency float NOT NULL, reference varchar(25), alternative varchar(25), oncomine_classification varchar(25), cdns varchar(50), classification varchar(25), protein varchar(50), ncbi_reference_number varchar(255), PRIMARY KEY (id), UNIQUE INDEX (id));
CREATE TABLE cnv (id int(10) NOT NULL AUTO_INCREMENT, Patientsid int(10) NOT NULL, gene varchar(10) NOT NULL, chromosome varchar(10) NOT NULL, position int(10) NOT NULL, raw_copy_number int(10) NOT NULL, copy_number int(10) NOT NULL, ci_5 float NOT NULL, ci_95 float NOT NULL, PRIMARY KEY (id), UNIQUE INDEX (id));
CREATE TABLE fusion (id int(10) NOT NULL AUTO_INCREMENT, Patientsid int(10) NOT NULL, fusion_id varchar(255) NOT NULL, gene_1 varchar(10) NOT NULL, gene_2 varchar(10) NOT NULL, read_depth_gene_1 int(10) NOT NULL, read_depth_gene_2 int(10) NOT NULL, PRIMARY KEY (id), UNIQUE INDEX (id));
CREATE TABLE ihc (id int(10) NOT NULL AUTO_INCREMENT, Patientsid int(10) NOT NULL, gene varchar(255) NOT NULL, result varchar(10) NOT NULL, PRIMARY KEY (id), UNIQUE INDEX (id), INDEX (gene));
ALTER TABLE patient_scenerios ADD INDEX FKpatient_sc636238 (patients_id), ADD CONSTRAINT FKpatient_sc636238 FOREIGN KEY (patients_id) REFERENCES Patients (id);
ALTER TABLE patient_scenerios ADD INDEX FKpatient_sc106423 (inclusion_scenerios_id), ADD CONSTRAINT FKpatient_sc106423 FOREIGN KEY (inclusion_scenerios_id) REFERENCES inclusion_scenerios (id);
ALTER TABLE patient_scenerios ADD INDEX FKpatient_sc36745 (exclusion_scenerios_id), ADD CONSTRAINT FKpatient_sc36745 FOREIGN KEY (exclusion_scenerios_id) REFERENCES exclusion_scenerios (id);
ALTER TABLE arms ADD INDEX FKarms785895 (patient_scenerios_id), ADD CONSTRAINT FKarms785895 FOREIGN KEY (patient_scenerios_id) REFERENCES patient_scenerios (id);
ALTER TABLE snv_mnv_indel ADD INDEX FKsnv_mnv_in521697 (Patientsid), ADD CONSTRAINT FKsnv_mnv_in521697 FOREIGN KEY (Patientsid) REFERENCES Patients (id);
ALTER TABLE cnv ADD INDEX FKcnv830797 (Patientsid), ADD CONSTRAINT FKcnv830797 FOREIGN KEY (Patientsid) REFERENCES Patients (id);
ALTER TABLE fusion ADD INDEX FKfusion480648 (Patientsid), ADD CONSTRAINT FKfusion480648 FOREIGN KEY (Patientsid) REFERENCES Patients (id);
ALTER TABLE IHC ADD INDEX FKIHC804582 (Patientsid), ADD CONSTRAINT FKIHC804582 FOREIGN KEY (Patientsid) REFERENCES Patients (id);

INSERT INTO inclusion_scenerios (description) VALUES ("dynamic amois and cnv/snv");
INSERT INTO inclusion_scenerios (description) VALUES ("cnv/snv");
INSERT INTO inclusion_scenerios (description) VALUES ("dynamic amois");
INSERT INTO inclusion_scenerios (description) VALUES ("standard");

INSERT INTO exclusion_scenerios (description) VALUES ("no exclusions");
INSERT INTO exclusion_scenerios (description) VALUES ("disease only exclusions");
INSERT INTO exclusion_scenerios (description) VALUES ("drug only exclusions");
INSERT INTO exclusion_scenerios (description) VALUES ("amoi only exclusions");
INSERT INTO exclusion_scenerios (description) VALUES ("standard exclusions");