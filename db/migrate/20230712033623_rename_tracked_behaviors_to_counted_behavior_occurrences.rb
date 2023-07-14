class RenameTrackedBehaviorsToCountedBehaviorOccurrences < ActiveRecord::Migration[7.0]
  def change
    rename_table :tracked_behaviors, :counted_behavior_occurrences
  end
end
