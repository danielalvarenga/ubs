class CreateHealthBasicUnits < ActiveRecord::Migration[5.2]
  def change
    create_table :health_basic_units, id: :string, limit: 42 do |t|
      t.string :name

      t.timestamps
    end
  end
end
