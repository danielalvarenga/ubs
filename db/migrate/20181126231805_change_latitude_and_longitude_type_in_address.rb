# frozen_string_literal: true

class ChangeLatitudeAndLongitudeTypeInAddress < ActiveRecord::Migration[5.2]

  def change
    change_column :addresses, :latitude, :float
    change_column :addresses, :longitude, :float
  end

end
