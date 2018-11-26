class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses, id: :string, limit: 42 do |t|
      t.string :street
      t.string :city
      t.string :neighborhood
      t.string :county_code
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
