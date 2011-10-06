class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :target
      t.string :lastname
      t.string :firstname
      t.string :status

      t.timestamps
    end
  end
end
