class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :target
      t.string :lastname
      t.string :firstname
      t.string :status, :default => "Upcoming"
      t.string :attending
      t.datetime :when_upcoming
      t.datetime :when_loaded
      t.datetime :when_needs_contours
      t.datetime :when_needs_plan
      t.datetime :when_needs_approval
      t.datetime :when_needs_finalizing
      t.datetime :when_finalized
      t.boolean :is_active, :default => true
      t.text :maillist, :default => "brian.thorndyke@coloradocyberknife.com"
      t.timestamps
    end
  end
end
