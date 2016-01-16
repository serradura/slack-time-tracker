class TimeDiffer
  def self.diff(seconds)
    hours = seconds / 3600
    seconds -= hours * 3600

    minutes = seconds / 60
    seconds -= minutes * 60

    "#{format(hours)}:#{format(minutes)}:#{format(seconds)}"
  end

  def self.between(start_time, end_time)
    seconds = calc_seconds(start_time, end_time)

    diff(seconds)
  end

  def self.from_now(time)
    between(Time.current, time)
  end

  def self.format(number)
    number.to_s.rjust(2, "0".freeze)
  end

  def self.calc_seconds(start_time, end_time)
    (start_time - end_time).to_i.abs
  end
end
