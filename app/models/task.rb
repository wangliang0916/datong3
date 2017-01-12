class Task < ActiveRecord::Base
  attr_accessible :content, :customer_mobile_phone, :customer_name, :notify_time, :notify_date 
  belongs_to :user

  default_scope order: 'notify_date DESC, notify_time DESC'

  def self.generate_tasks
    now = Time.now
    #puts "hello, it's #{now}"
    year = now.year.to_s
    month = sprintf("%02d", now.month)
    day = sprintf("%02d", now.day)
    notify_date = "#{year}-#{month}-#{day}"
    OnceNotify.where("date=?","#{year}-#{month}-#{day}").order('time asc').each do |notify|
      generate_task(notify, notify_date)
    end

    EveryYearNotify.where("date=?","#{month}-#{day}").order('time asc').each do |notify|
      generate_task(notify, notify_date)
    end

    EveryMonthNotify.where("date=?","#{day}").order('time asc').each do |notify|
      generate_task(notify, notify_date)
    end

  end

private
  def self.generate_task(notify, notify_date)
    notify.customer.users.each do |user|
      t = Task.new
      t.user = user
      t.customer_name = notify.customer.name
      t.customer_mobile_phone = notify.customer.mobile_phone
      t.notify_date = notify_date
      t.notify_time = notify.time
      t.content = notify.content
      t.save
    end
  end
end
