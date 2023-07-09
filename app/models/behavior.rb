# A Behavior that can be performed by a Dog.
# == Attributes
# === Required
# name:: the name of the Behavior.
# TODO: these are counter behaviors, also need duration behaviors (Sleep, Rest)
class Behavior < ApplicationRecord
  enum(:color,
    amber: "amber",
    blue: "blue",
    blue_gray: "blue_gray",
    cyan: "cyan",
    deep_orange: "deep_orange",
    deep_purple: "deep_purple",
    green: "green",
    indigo: "indigo",
    light_blue: "light_blue",
    light_green: "light_green",
    lime: "lime",
    orange: "orange",
    pink: "pink",
    purple: "purple",
    red: "red",
    teal: "teal",
    yellow: "yellow",
  )

  validates_presence_of :name, :color
  before_validation :set_color

  private

  def set_color
    return if color.present?

    # pick a random color, least used by other behaviors
    used_color_counts = self.class.pluck(:color).tally
    unused_colors = self.class.colors.values - used_color_counts.keys
    if unused_colors.any?
      self.color = unused_colors.shuffle.first
    else
      smallest_count = used_color_counts.values.min
      least_used_colors = used_color_counts.select { |color, count| count == smallest_count }.keys
      self.color = least_used_colors.shuffle.first
    end
  end
end
