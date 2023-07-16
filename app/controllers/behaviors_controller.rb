class BehaviorsController < ApplicationController
  NEW_DAY_HOUR = 4

  before_action :set_dog
  before_action :set_timezone

  def index
    # TODO: sorting
    @behaviors = Behavior.all
    current_time = Time.current.in_time_zone(@timezone)
    @today = if current_time.hour < NEW_DAY_HOUR
      1.day.before(current_time).to_date
    else
      current_time.to_date
    end
    behavior_occurrences_by_behavior_id = @dog.behavior_occurrences.where(seen_on_date: @today).group_by(&:behavior_id)
    @behavior_occurrence_by_behavior_id = @behaviors.each_with_object({}) do |behavior, acc|
      acc[behavior.id] = behavior_occurrences_by_behavior_id[behavior.id]&.[](0) ||
        @dog.behavior_occurrences.build(behavior: behavior, seen_on_date: @today)
    end
  end
end
