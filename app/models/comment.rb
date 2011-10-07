class Comment < ActiveRecord::Base
  has_one :plan
end
