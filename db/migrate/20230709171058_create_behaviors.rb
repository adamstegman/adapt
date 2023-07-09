class CreateBehaviors < ActiveRecord::Migration[7.0]
  def change
    create_table :behaviors do |t|
      t.string :name

      t.timestamps
    end
  end
end
