class TrackedBehaviorsController < ApplicationController
  before_action :set_dog

  def index
    @timezone = DEFAULT_TIMEZONE
    # TODO: sorting
    @behaviors = Behavior.all
    # TODO: timeframe query parameters, or define timeframe by behavior
    @tracked_behavior_counts_by_behavior_id = @dog.tracked_behaviors.seen_today_in_timezone(@timezone).group(:behavior_id).count
  end

  def create
    @tracked_behavior = @dog.tracked_behaviors.build(tracked_behavior_params.merge(seen_at: Time.current))

    respond_to do |format|
      if @tracked_behavior.save
        format.html { redirect_to dog_tracked_behaviors_path(@dog), notice: "Added behavior." }
        format.json { render :show, status: :created, location: tracked_behaviors_url }
      else
        format.html { redirect_to dog_tracked_behaviors_path(@dog), error: "Could not add behavior!" }
        format.json { render json: @tracked_behavior.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def tracked_behavior_params
    params.require(:tracked_behavior).permit(:behavior_id)
  end
end
