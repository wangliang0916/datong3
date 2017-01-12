require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

s.every '1m' do
  Task.generate_tasks
end
