require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.cron '00 01 * * *' do
  Task.generate_tasks
end
