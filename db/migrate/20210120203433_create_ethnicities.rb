class CreateEthnicities < ActiveRecord::Migration[6.1]
  def change
    create_table :ethnicities do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
