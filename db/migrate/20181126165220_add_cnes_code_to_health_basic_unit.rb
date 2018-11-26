class AddCnesCodeToHealthBasicUnit < ActiveRecord::Migration[5.2]
  def change
    add_column :health_basic_units, :cnes_code, :string
  end
end
