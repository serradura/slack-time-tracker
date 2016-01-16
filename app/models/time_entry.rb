class TimeEntry < ActiveRecord::Base
  belongs_to :user

  validates :note, :date, :start, presence: true

  def now
    diff = TimeDiffer.from_now(start)

    "#{diff} - #{note}"
  end

  def to_display
    date = self.date.to_formatted_s(:long)
    start_time = start.strftime("%H:%M:%S")
    end_time   = (self.end || Time.current).try(:strftime, "%H:%M:%S")
    time_diff  = TimeDiffer.between(start, self.end || Time.current)

    "#{date}\t\t|\t#{start_time}\t\t|\t#{end_time}\t\t|\t#{time_diff}\t\t|\t#{note}"
  end
end
