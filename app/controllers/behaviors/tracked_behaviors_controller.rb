class Behaviors::TrackedBehaviorsController < ApplicationController
  before_action :set_dog
  before_action :set_behavior

  def index
    @timezone = DEFAULT_TIMEZONE
    @behavior = Behavior.find(params[:behavior_id])
    # TODO: pagination, remove delete control on earlier pages
    current_time = Time.current.in_time_zone(@timezone)
    earliest_time = TrackedBehavior.beginning_of_day(6.days.before(current_time))
    latest_time = TrackedBehavior.end_of_day(current_time)
    @latest_date = TrackedBehavior.beginning_of_day(latest_time).to_date
    @is_current_date = true
    @tracked_behavior_counts_by_date = ((earliest_time.to_date)..@latest_date).each_with_object({}) do |date, acc|
      acc[date] = 0
    end
    @dog.tracked_behaviors.seen_from(earliest_time).seen_to(latest_time).where(behavior: @behavior).each_with_object(@tracked_behavior_counts_by_date) do |tracked_behavior, acc|
      original_seen_at = tracked_behavior.seen_at.in_time_zone(@timezone)
      seen_at_date = TrackedBehavior.beginning_of_day(original_seen_at).to_date
      acc[seen_at_date] += 1
    end
  end

  def create
    # TODO: historical data entry (Sleep, Rest, Night Waking)
    @tracked_behavior = @dog.tracked_behaviors.build(behavior: @behavior, seen_at: Time.current)

    respond_to do |format|
      if @tracked_behavior.save
        format.html { redirect_to dog_behavior_tracked_behaviors_path(@dog, @behavior), notice: "Added behavior." }
        format.json { render :show, status: :created, location: tracked_behaviors_url }
      else
        format.html { redirect_to dog_behavior_tracked_behaviors_path(@dog, @behavior), error: "Could not add behavior!" }
        format.json { render json: @tracked_behavior.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_latest
    @tracked_behavior = @dog.tracked_behaviors.where(behavior: @behavior).order(seen_at: :desc).first

    respond_to do |format|
      if @tracked_behavior&.destroy
        format.html { redirect_to dog_behavior_tracked_behaviors_path(@dog, @behavior), notice: "Removed behavior." }
        format.json { render :show, status: :no_content, location: tracked_behaviors_url }
      else
        format.html { redirect_to dog_behavior_tracked_behaviors_path(@dog, @behavior), error: "Could not remove behavior!" }
        format.json { render json: @tracked_behavior.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_behavior
    @behavior = Behavior.find(params[:behavior_id]) if params[:behavior_id]
  end
end
