class RenameBehaviorsToCountedBehaviors < ActiveRecord::Migration[7.0]
  def change
    rename_table :behaviors, :counted_behaviors
    rename_column :tracked_behaviors, :behavior_id, :counted_behavior_id
  end
end
