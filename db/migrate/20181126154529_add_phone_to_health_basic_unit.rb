class AddPhoneToHealthBasicUnit < ActiveRecord::Migration[5.2]
  def change
    add_column :health_basic_units, :phone, :string
  end
end
