class GroupEvent < ActiveRecord::Base

  default_scope {where(deleted: false)}

  validates_numericality_of :duration, greater_than_or_equal_to: 0, if: Proc.new { |e| e.duration }, message: "Invalid value"

  validates_presence_of :name, :description, :location, :start_date, :end_date, :duration, if: "published?"

  validates_inclusion_of :status, in: :status_types, message: 'Invalid type'

  validate :end_date_is_after_start_date, if: Proc.new { |e| e.start_date && e.end_date }

  before_save :calculate_duration, if: Proc.new { |e| e.start_date && e.end_date }
  before_save :calculate_end_date, if: Proc.new { |e| e.duration && e.start_date && e.end_date.nil? }
  before_save :calculate_start_date, if: Proc.new { |e| e.duration && e.start_date.nil? && e.end_date }

  before_validation :print

  def calculate_duration
    self.duration = TimeDifference.between(start_date, end_date).in_days
  end

  def calculate_end_date
     self.end_date = self.start_date + duration.days
  end

  def calculate_start_date
    self.start_date = self.end_date - duration.days
  end


  def end_date_is_after_start_date
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

  def destroy
    self.update_attribute :deleted, true
  end

  def delete
    self.destroy
  end

end
