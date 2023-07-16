class RenameCountedBehaviorsToBehaviors < ActiveRecord::Migration[7.0]
  def change
    rename_table :counted_behaviors, :behaviors
    rename_column :counted_behavior_occurrences, :counted_behavior_id, :behavior_id
  end
end
