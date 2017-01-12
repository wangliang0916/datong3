require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.cron '5 0 * * *' do
  Task.generate_tasks
end
