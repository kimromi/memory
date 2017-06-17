require 'pry'

require 'holiday_jp'
require 'active_support/core_ext/integer/time'

def calc_worktime_second(created_at, closed_at)
  (0..(closed_at.to_date-created_at.to_date)).inject(0) do |sum, diff_date|
    d = created_at + diff_date.days

    if d.to_date.sunday? || d.to_date.saturday? || !!HolidayJp.holiday?(d.to_date)
      sum += 0
    elsif diff_date == 0 && d.day == closed_at.day
      sum += (closed_at - created_at).to_i                             # 1日で終わった場合は開始と終了の差を加算
    elsif diff_date == 0 && d <= Time.new(d.year, d.month, d.day, 19)
      sum += (Time.new(d.year, d.month, d.day, 19) - d).to_i           # 初日は19時までの時間を加算
    elsif d.day == closed_at.day
      sum += (closed_at - Time.new(d.year, d.month, d.day, 9)).to_i    # 最終日は9時から終了時間までを加算
    else
      sum += 60 * 60 * 9                                               # それ以外は9〜19時(昼休み除く)の9時間を加算
    end
  end
end

def format_duration(duration_seconds)
  day = duration_seconds / 86400
  hour = (duration_seconds % 86400) / 3600
  minute = (duration_seconds % 3600) / 60
  second = (duration_seconds % 60)
  formatted = ''
  formatted += "#{day}日" if day > 0
  formatted += "#{hour}時間" if hour > 0
  formatted += "#{minute}分" if minute > 0
  formatted += "#{second}秒"
  formatted
end
