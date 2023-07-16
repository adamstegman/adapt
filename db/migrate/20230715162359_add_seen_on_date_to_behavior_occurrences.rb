class AddSeenOnDateToBehaviorOccurrences < ActiveRecord::Migration[7.0]
  def change
    add_column :behavior_occurrences, :seen_on_date, :date
  end
end
