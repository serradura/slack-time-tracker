class TimeEntry < ActiveRecord::Base
  belongs_to :user

  validates :note, :date, :start, presence: true

  def now
    diff = TimeDiffer.from_now(start)

    "#{diff} - #{note}"
  end

  # time_entry.date.to_formatted_s(:long)
  # time_entry.start.strftime("%H:%M:%S")
  # TimeDiffer.between(time_entry.start, time_entry.end || Time.current)
  # time_entry.note
  def to_display
	entryDate = date.to_formatted_s(:long)
	entryStart = start.strftime("%H:%M:%S")
	entryEnd = (self.end || Time.current).try(:strftime, "%H:%M:%S")
	entryTimeRange = TimeDiffer.between(start, self.end || Time.current)
	entryNote = note
	"#{entryDate}\t\t|\t#{entryStart}\t\t|\t#{entryEnd}\t\t|\t#{entryTimeRange}\t\t|\t#{entryNote}"
  end
end
