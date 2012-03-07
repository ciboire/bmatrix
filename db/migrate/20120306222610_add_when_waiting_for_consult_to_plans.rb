class AddWhenWaitingForConsultToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :when_waiting_for_consult, :datetime
  end
end
