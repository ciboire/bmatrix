class AddNotesToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :notes, :string
    add_column :plans, :modality, :string
  end
end
