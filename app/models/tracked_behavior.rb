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
    Time.use_zone(zone) {
      seen_from(Time.current.beginning_of_day.change(hour: NEW_DAY_HOUR))
    }
  }
end
