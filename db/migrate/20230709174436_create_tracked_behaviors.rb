class CreateTrackedBehaviors < ActiveRecord::Migration[7.0]
  def change
    create_table :tracked_behaviors do |t|
      t.belongs_to :dog, null: false, foreign_key: true
      t.belongs_to :behavior, null: false, foreign_key: true
      t.datetime :seen_at

      t.timestamps
    end
  end
end
