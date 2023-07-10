# An instance of Behavior that was performed by a Dog.
# == Attributes
# === Required
# seen_at:: when the Behavior was observed.
class TrackedBehavior < ApplicationRecord
  # Assume we may stay up past midnight, so start a "new day" at 4:00 AM
  NEW_DAY_HOUR = 4

  belongs_to :dog
  belongs_to :behavior

  validates_presence_of :dog, :behavior, :seen_at

  scope :seen_from, -> { where(seen_at: _1..) }
  scope :seen_to, -> { where(seen_at: .._1) }
  scope :seen_today_in_timezone, ->(zone) {
    seen_from(Time.current.in_time_zone(zone).beginning_of_day.change(hour: NEW_DAY_HOUR))
  }

  def self.beginning_of_day(time)
    if time.hour < NEW_DAY_HOUR
      beginning_of_day(1.day.before(time).end_of_day)
    else
      time.beginning_of_day.change(hour: NEW_DAY_HOUR)
    end
  end

  def self.end_of_day(time)
    if time.hour < NEW_DAY_HOUR
      time.beginning_of_day.change(hour: NEW_DAY_HOUR - 1, min: 59, sec: 59, usec: Rational(999999999, 1000))
    else
      end_of_day(1.day.after(time).beginning_of_day)
    end
  end
end
