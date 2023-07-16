class AddAmountToBehaviorOccurrences < ActiveRecord::Migration[7.0]
  def change
    add_column :behavior_occurrences, :amount, :float, null: false, default: 0.0
  end
end
