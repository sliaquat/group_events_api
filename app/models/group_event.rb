class GroupEvent < ActiveRecord::Base

  validates_presence_of :name, :description, :location, :start_date, :end_date, :duration, if: "published?"

  validates_inclusion_of :status, in: :status_types, message: 'Invalid status type'

  validate :start_end_date_after_start_date, if: 'start_date && end_date'

  before_save :calculate_duration, if: 'duration.nil? && start_date && end_date'

  def calculate_duration
    self.duration = TimeDifference.between(start_date, end_date).in_days
  end

  def start_end_date_after_start_date
    if start_date > end_date
      errors.add(:end_date, 'must be after start_date')
    end
  end

  def published?
    self.status == 'published'
  end

  def status_types
    ["draft", "published"]
  end
end
