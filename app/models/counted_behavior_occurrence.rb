# An instance of a CountedBehavior that was performed by a Dog.
# These occurrences of behavior are counted based on when they occur.
# == Attributes
# === Required
# seen_at:: when the CountedBehavior was observed.
class CountedBehaviorOccurrence < ApplicationRecord
  # Assume we may stay up past midnight, so start a "new day" at 4:00 AM
  NEW_DAY_HOUR = 4

  belongs_to :dog
  belongs_to :counted_behavior

  validates_presence_of :dog, :counted_behavior, :seen_at

  scope :seen_from, -> { where(seen_at: _1..) }
  scope :seen_to, -> { where(seen_at: .._1) }
  scope :seen_on, ->(date, in_time_zone:) {
    time = date.in_time_zone(in_time_zone).change(hour: NEW_DAY_HOUR, min: 1)
    where(seen_at: beginning_of_day(time)..end_of_day(time))
  }
  scope :seen_today_in_timezone, ->(zone) {
    seen_from(Time.current.in_time_zone(zone).beginning_of_day.change(hour: NEW_DAY_HOUR))
  }

  def self.beginning_of_day(time_or_date)
    if time_or_date.hour < NEW_DAY_HOUR
      beginning_of_day(1.day.before(time_or_date).end_of_day)
    else
      time_or_date.beginning_of_day.change(hour: NEW_DAY_HOUR)
    end
  end

  def self.end_of_day(time_or_date)
    if time_or_date.hour < NEW_DAY_HOUR
      time_or_date.beginning_of_day.change(hour: NEW_DAY_HOUR - 1, min: 59, sec: 59, usec: Rational(999999999, 1000))
    else
      end_of_day(1.day.after(time_or_date).beginning_of_day)
    end
  end
end
