class Plan < ActiveRecord::Base
  STATUS = ['Upcoming', 'Loaded', 'Needs Contours', 'Needs Plan', 'Needs Approval', 'Needs Finalizing', 'Finalized']
end
