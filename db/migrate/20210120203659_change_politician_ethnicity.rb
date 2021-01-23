class ChangePoliticianEthnicity < ActiveRecord::Migration[6.1]
  def change
    remove_column :politicians, :ethnicity
    add_column :politicians, :ethnicity_id, :integer
    add_foreign_key :politicians, :ethnicities
  end
end
