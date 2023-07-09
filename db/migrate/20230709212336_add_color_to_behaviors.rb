class AddColorToBehaviors < ActiveRecord::Migration[7.0]
  def change
    add_column :behaviors, :color, :string
  end
end
