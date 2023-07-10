class Behaviors::TrackedBehaviorsController < ApplicationController
  before_action :set_dog
  before_action :set_behavior

  def index
    @timezone = DEFAULT_TIMEZONE
    # TODO: pagination, remove delete control on earlier pages
    current_time = Time.current.in_time_zone(@timezone)
    earliest_time = TrackedBehavior.beginning_of_day(6.days.before(current_time))
    latest_time = TrackedBehavior.end_of_day(current_time)
    @latest_date = TrackedBehavior.beginning_of_day(latest_time).to_date
    @is_current_date = true
    @tracked_behavior_counts_by_date = ((earliest_time.to_date)..@latest_date).each_with_object({}) do |date, acc|
      acc[date] = @dog.tracked_behaviors.seen_on(date).where(behavior: @behavior).count
    end
  end

  def update_count
    @timezone = DEFAULT_TIMEZONE
    date = Time.use_zone(@timezone) { Time.zone.parse(params[:date]).to_date }
    tracked_behaviors = @dog.tracked_behaviors.seen_on(date).where(behavior: @behavior)
    new_count = params[:count].to_i
    existing_count = tracked_behaviors.count
    if new_count < existing_count
      remove_count = existing_count - new_count
      tracked_behaviors.order(seen_at: :desc).limit(remove_count).destroy_all
    elsif new_count > existing_count
      new_tracked_behaviors = (new_count - existing_count).times.map {
        # Don't have a specific time for these, so put them at end of day,
        # so they would be removed if the count is changed to be lower
        @dog.tracked_behaviors.build(behavior: @behavior, seen_at: TrackedBehavior.end_of_day(date))
      }
      unless new_tracked_behaviors.map(&:save).all?
        respond_to do |format|
          format.html { redirect_to dog_behavior_tracked_behaviors_path(@dog, @behavior), error: "Could not add behaviors!" }
          format.json { render json: new_tracked_behavior.map(&:errors), status: :unprocessable_entity }
        end
        return
      end
    end
    respond_to do |format|
      format.html { redirect_to dog_behavior_tracked_behaviors_path(@dog, @behavior), notice: "Updated behavior count." }
      format.json { render :show, status: :created, location: tracked_behaviors_url }
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
    @behavior = Behavior.find(params[:behavior_id])
  end
end
