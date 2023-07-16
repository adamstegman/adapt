class RemoveSeenAtFromBehaviorOccurrences < ActiveRecord::Migration[7.0]
  def change
    remove_column :behavior_occurrences, :seen_at, :datetime
  end
end
