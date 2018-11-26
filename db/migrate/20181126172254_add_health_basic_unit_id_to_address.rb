# frozen_string_literal: true

class AddHealthBasicUnitIdToAddress < ActiveRecord::Migration[5.2]

  def change
    add_column :addresses, :health_basic_unit_id, :string, limit: 42, foreign_key: true
  end

end
