class BehaviorsController < ApplicationController
  before_action :set_dog
  before_action :set_timezone

  def index
    # TODO: sorting
    @behaviors = Behavior.all
    # FIXME: utility method to determine date if before 4AM
    @today = Time.current.in_time_zone(@timezone).to_date
    behavior_occurrences_by_behavior_id = @dog.behavior_occurrences.where(seen_on_date: @today).group_by(&:behavior_id)
    @behavior_occurrence_by_behavior_id = @behaviors.each_with_object({}) do |behavior, acc|
      acc[behavior.id] = behavior_occurrences_by_behavior_id[behavior.id]&.[](0) ||
        @dog.behavior_occurrences.build(behavior: behavior, seen_on_date: @today)
    end
  end
end
