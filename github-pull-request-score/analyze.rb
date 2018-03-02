require 'pry'

require 'sqlite3'
require File.expand_path(__dir__) + '/function.rb'

db = SQLite3::Database.new('github.db')
db.results_as_hash = true

year_x_changed_files = {}
month_x_changed_files = {}
db.execute('select * from pull_requests') do |row|
  # 開いてから閉じるまでに掛かった秒数
  seconds = calc_worktime_second(Time.parse(row['created_at']), Time.parse(row['closed_at']))
  month = Time.parse(row['created_at']).strftime('%Y/%m')
  year = Time.parse(row['created_at']).strftime('%Y')

  month_x_changed_files[month] ||= []
  month_x_changed_files[month] << row['changed_files']

  year_x_changed_files[year] ||= []
  year_x_changed_files[year] << row['changed_files']
end

year_x_changed_files.sort.each do |year, changed_files|
  puts "#{year}\t#{changed_files.sum/changed_files.size.to_f}"
end
month_x_changed_files.sort.each do |month, changed_files|
  #puts "#{month}\t#{changed_files.sum/changed_files.size.to_f}"
end

db.close
