class TimeEntry < ActiveRecord::Base
  belongs_to :user

  validates :note, :date, :start, presence: true

  def now
    diff = TimeDiffer.from_now(start)

    "#{diff} - #{note}"
  end
end
