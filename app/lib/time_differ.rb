# frozen_string_literal: true

class TimeDiffer
  def initialize(start_time, end_time)
    @seconds = (start_time - end_time).to_i.abs
  end

  def self.between(start_time, end_time)
    new(start_time, end_time).value
  end

  def self.from_now(time)
    between(Time.current, time)
  end

  def value
    "#{format(@hours)}:#{format(@minutes)}:#{format(@seconds)}"
  end

  private

  def parse_hours
    @hours = @seconds / 3600
    @seconds -= @hours * 3600
  end

  def parse_minutes
    @minutes = @seconds / 60
    @seconds -= @minutes * 60
  end

  def format(number)
    number.to_s.rjust(2, "0")
  end
end
