#based on Brent's schema
class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t|
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
      t.integer :inclusion_scenerio_id, null: false
      t.integer :exclusion_scenerio_id, null: false

      t.timestamps
    end

    create_table :arms do |t|
      t.integer :patient_scenerio_id, null: false
      t.string :arm, null: false
      t.string :selection_type, default: 'POTENTIAL', null: false
    end
  end
end
