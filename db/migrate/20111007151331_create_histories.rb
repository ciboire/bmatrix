class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :action
      t.integer :reference_id

      t.timestamps
    end
  end
end
