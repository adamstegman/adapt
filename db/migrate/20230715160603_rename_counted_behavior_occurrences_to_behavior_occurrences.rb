class RenameCountedBehaviorOccurrencesToBehaviorOccurrences < ActiveRecord::Migration[7.0]
  def change
    rename_table :counted_behavior_occurrences, :behavior_occurrences
  end
end
