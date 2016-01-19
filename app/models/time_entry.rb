class TimeEntry < ActiveRecord::Base
  belongs_to :user

  validates :note, :date, :start, presence: true

  before_update :calculate_duration

  def now
    TimeDiffer.from_now(start)
  end

  private

  def calculate_duration
    return unless start.present? && self.end.present?

    self.duration = TimeDiffer.calc_seconds(self.end, start)
  end
end
