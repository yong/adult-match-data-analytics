class AddReadDepthToSnv < ActiveRecord::Migration[5.1]
  def change
    add_column :snv_mnv_indel, :read_depth, :integer
  end
end
