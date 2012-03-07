class AddAttendingMdToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :attending_md, :string
  end
end
