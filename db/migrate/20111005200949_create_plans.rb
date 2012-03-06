class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :target
      t.string :lastname
      t.string :firstname
      t.string :status, :default => "Upcoming"
      t.datetime :when_upcoming
      t.datetime :when_needs_image_review
      t.datetime :when_needs_setup
      t.datetime :when_needs_preparation
      t.datetime :when_needs_md_contours
      t.datetime :when_needs_plan
      t.datetime :when_needs_approval
      t.datetime :when_needs_finalizing
      t.datetime :when_ready_for_treatment
      t.datetime :when_in_treatment
      t.datetime :when_finished_treatment
      t.boolean :is_active, :default => true
      t.timestamps
    end
  end
end
