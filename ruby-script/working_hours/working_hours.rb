# gem install working_hours
require 'working_hours'

WorkingHours::Config.working_hours = {
  :mon => {'09:00' => '13:00', '14:00' => '18:00'},
  :tue => {'09:00' => '13:00', '14:00' => '18:00'},
  :wed => {'09:00' => '13:00', '14:00' => '18:00'},
  :thu => {'09:00' => '13:00', '14:00' => '18:00'},
  :fri => {'09:00' => '13:00', '14:00' => '18:00'}
}

WorkingHours::Config.time_zone = 'Asia/Tokyo'

puts WorkingHours.working_time_between(Time.new(2017, 6, 23), Time.new(2017, 6, 24))
