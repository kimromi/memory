require 'pry'

require 'sqlite3'
require File.expand_path(__dir__) + '/function.rb'

db = SQLite3::Database.new('github-pull-request-score/github.db')
db.results_as_hash = true

personal = {}
db.execute('select * from pull_requests') do |row|
  personal[row['assignee']] ||= []
  personal[row['assignee']] << row

  # 開いてから閉じるまでに掛かった秒数
  calc_worktime_second(Time.parse(row['created_at']), Time.parse(row['closed_at']))
end

db.close
