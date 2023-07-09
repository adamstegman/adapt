class TrackedBehaviorsController < ApplicationController
  DEFAULT_TIMEZONE = "America/Chicago".freeze

  before_action :set_dog

  def index
    @timezone = DEFAULT_TIMEZONE
    # TODO: sorting
    @behaviors = Behavior.all
    # TODO: timeframe query parameters, or define timeframe by behavior
    @tracked_behavior_counts_by_behavior_id = @dog.tracked_behaviors.seen_today_in_timezone(@timezone).group(:behavior_id).count
  end

  def create
    # TODO: historical data entry (Sleep, Rest, Night Waking)
    @tracked_behavior = @dog.tracked_behaviors.build(tracked_behavior_params.merge(seen_at: Time.current))

    respond_to do |format|
      if @tracked_behavior.save
        format.html { redirect_to dog_tracked_behaviors_path(@dog), notice: "Added behavior." }
        format.json { render :show, status: :created, location: tracked_behaviors_url }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tracked_behavior.errors, status: :unprocessable_entity }
      end
    end
  end

  # TODO: destroy last entry if added by mistake

  private

  def set_dog
    # TODO: allow switching between dogs
    @dog = Dog.poppy
  end

  # Only allow a list of trusted parameters through.
  def tracked_behavior_params
    params.require(:tracked_behavior).permit(:behavior_id)
  end
end
