#based on Brent's schema
class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t|
      t.integer :patients_id, null: false
      t.string :vcf_version
      t.string :sequencing_date
      t.string :disease
      t.string :meddra_code

      t.timestamps
    end

    create_table :inclusion_scenerios do |t|
      t.string :description

      t.timestamps
    end

    create_table :exclusion_scenerios do |t|
      t.string :description

      t.timestamps
    end

    create_table :patient_scenerios do |t|
      t.integer :patients_id, null: false
      t.integer :inclusion_scenerios_id, null: false
      t.integer :exclusion_scenerios_id, null: false

      t.timestamps
    end

    create_table :arms do |t|
      t.integer :patient_scenerios_id, null: false
      t.string :arm, null: false
      t.string :selection_type, default: 'POTENTIAL', null: false

      t.timestamps
    end

    create_table :snv_mnv_indel do |t|
      t.integer :patients_id
      t.string :variant_id
      t.string :variant_type
      t.string :gene
      t.string :chromosome
      t.integer :position
      t.float :allele_frequency
      t.string :reference
      t.string :alternative
      t.string :oncomine_classification
      t.string :cdns
      t.string :classification
      t.string :protein
      t.string :ncbi_reference_number
    end

    create_table :cnv do |t|
      t.integer :patients_id
      t.string :gene
      t.string :chromosome
      t.integer :position
      t.integer :raw_copy_number
      t.integer :copy_number
      t.float :ci_5
      t.float :ci_95
    end

    create_table :fusion do |t|
      t.integer :patients_id
      t.string :fusion_id
      t.string :gene_1
      t.string :gene_2
      t.integer :read_depth_gene_1
      t.integer :read_depth_gene_2
    end

    create_table :ihc do |t|
      t.integer :patients_id
      t.string :gene
      t.string :result
    end
  end
end
