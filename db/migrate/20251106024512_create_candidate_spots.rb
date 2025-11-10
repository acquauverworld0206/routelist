# frozen_string_literal: true

class CreateCandidateSpots < ActiveRecord::Migration[7.1]
  def change
    create_table :candidate_spots do |t|
      t.references :group, null: false, foreign_key: true
      t.references :spot, null: false, foreign_key: true
      t.references :added_by, null: false, foreign_key: { to_table: :users }
      t.text :votes
      t.boolean :is_decided, null: false, default: false
      t.integer :decided_order

      t.timestamps
    end
  end
end