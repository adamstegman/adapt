# An instance of a Behavior that was performed by a Dog on a specific day.
# == Attributes
# === Required
# behavior:: belongs_to
# dog:: belongs_to
# amount:: the number of times or duration the Behavior was observed on this day.
# seen_on_date:: the day when the Behavior was observed.
class BehaviorOccurrence < ApplicationRecord
  belongs_to :dog
  belongs_to :behavior

  validates_presence_of :dog, :behavior, :seen_on_date, :amount
end
