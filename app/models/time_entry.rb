class TimeEntry < ActiveRecord::Base
  belongs_to :user

  validates :note, :date, :start, presence: true

  before_update :calculate_duration

  def now
    TimeDiffer.from_now(start)
  end

  private

  def calculate_duration
    self.duration = self.end - start if start.present? && self.end.present?
  end
end
