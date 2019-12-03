# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
#
# midnight by default
every 1.day, at: '23pm' do
  runner 'Services::DailyDigest.new.send_digest'
end
# Sphinx search reindex
every 20.minutes do
  rake "ts:index"
end

# Learn more: http://github.com/javan/whenever
