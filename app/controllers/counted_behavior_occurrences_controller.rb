class CountedBehaviorOccurrencesController < ApplicationController
  before_action :set_dog

  def index
    @timezone = DEFAULT_TIMEZONE
    # TODO: sorting
    @counted_behaviors = CountedBehavior.all
    # TODO: timeframe query parameters, or define timeframe by behavior
    @behavior_counts_by_behavior_id = @dog.counted_behavior_occurrences.where(
      counted_behavior: @counted_behaviors,
    ).seen_today_in_timezone(@timezone).group(:counted_behavior_id).count
  end

  def create
    @occurrence = @dog.counted_behavior_occurrences.build(counted_behavior_occurrence_params.merge(seen_at: Time.current))

    respond_to do |format|
      if @occurrence.save
        format.html { redirect_to dog_counted_behavior_occurrences_path(@dog), notice: "Counted behavior." }
        format.json { render :show, status: :created, location: counted_behavior_occurrences_url }
      else
        format.html { redirect_to dog_counted_behavior_occurrences_path(@dog), error: "Could not count behavior!" }
        format.json { render json: @occurrence.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def counted_behavior_occurrence_params
    params.require(:counted_behavior_occurrence).permit(:counted_behavior_id)
  end
end
