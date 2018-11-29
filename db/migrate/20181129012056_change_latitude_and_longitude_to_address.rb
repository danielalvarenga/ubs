# frozen_string_literal: true

class ChangeLatitudeAndLongitudeToAddress < ActiveRecord::Migration[5.2]

  def change
    change_column :addresses, :latitude, :decimal, precision: 20, scale: 15
    change_column :addresses, :longitude, :decimal, precision: 20, scale: 15
  end

end
