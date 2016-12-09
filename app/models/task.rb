class Task < ActiveRecord::Base
  attr_accessible :content, :customer_mobile_phone, :customer_name, :notify_time, :user_id
  belongs_to :user
  def self.generate_tasks
    
  end
end
