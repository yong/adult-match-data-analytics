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
ALTER TABLE patient_scenerios ADD INDEX FKpatient_sc636238 (patients_id), ADD CONSTRAINT FKpatient_sc636238 FOREIGN KEY (patients_id) REFERENCES Patients (id);
ALTER TABLE patient_scenerios ADD INDEX FKpatient_sc106423 (inclusion_scenerios_id), ADD CONSTRAINT FKpatient_sc106423 FOREIGN KEY (inclusion_scenerios_id) REFERENCES inclusion_scenerios (id);
ALTER TABLE patient_scenerios ADD INDEX FKpatient_sc36745 (exclusion_scenerios_id), ADD CONSTRAINT FKpatient_sc36745 FOREIGN KEY (exclusion_scenerios_id) REFERENCES exclusion_scenerios (id);
ALTER TABLE arms ADD INDEX FKarms785895 (patient_scenerios_id), ADD CONSTRAINT FKarms785895 FOREIGN KEY (patient_scenerios_id) REFERENCES patient_scenerios (id);


INSERT INTO inclusion_scenerios (description) VALUES ("dynamic amois and cnv/snv");
INSERT INTO inclusion_scenerios (description) VALUES ("cnv/snv");
INSERT INTO inclusion_scenerios (description) VALUES ("dynamic amois");
INSERT INTO inclusion_scenerios (description) VALUES ("standard");

INSERT INTO exclusion_scenerios (description) VALUES ("no exclusions");
INSERT INTO exclusion_scenerios (description) VALUES ("disease only exclusions");
INSERT INTO exclusion_scenerios (description) VALUES ("drug only exclusions");
INSERT INTO exclusion_scenerios (description) VALUES ("amoi only exclusions");
INSERT INTO exclusion_scenerios (description) VALUES ("standard exclusions");