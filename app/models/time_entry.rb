class TimeEntry < ActiveRecord::Base
  belongs_to :user

  validates :note, :date, :start, presence: true

  def now
    time = (Time.current - start).to_formatted_s(:time)

    "#{time} - #{note}"
  end
end
