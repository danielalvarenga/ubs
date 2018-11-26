# frozen_string_literal: true

class CreateScores < ActiveRecord::Migration[5.2]

  def change
    create_table :scores, id: :string, limit: 42 do |t|
      t.integer :size
      t.integer :adaptation_for_seniors
      t.integer :medical_equipment
      t.integer :medicine
      t.string :health_basic_unit_id, limit: 42, foreign_key: true

      t.timestamps
    end
  end

end
