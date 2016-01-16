class TimeDiffer
  def self.between(start_time, end_time)
    seconds = seconds_diff(start_time, end_time)

    hours = seconds / 3600
    seconds -= hours * 3600

    minutes = seconds / 60
    seconds -= minutes * 60

    "#{format(hours)}:#{format(minutes)}:#{format(seconds)}"
  end

  def self.from_now(time)
    between(Time.current, time)
  end

  def self.format(number)
    number.to_s.rjust(2, "0".freeze)
  end

  def self.seconds_diff(start_time, end_time)
    (start_time - end_time).to_i.abs
  end
end
