class CountedBehaviors::CountedBehaviorOccurrencesController < ApplicationController
  before_action :set_dog
  before_action :set_behavior

  def index
    @timezone = DEFAULT_TIMEZONE
    current_time = Time.current.in_time_zone(@timezone)
    @is_current_week = true
    if (@page = params[:page].to_i) > 0
      current_time = @page.weeks.before(current_time)
      @is_current_week = false
    end
    earliest_time = CountedBehaviorOccurrence.beginning_of_day(6.days.before(current_time))
    latest_time = CountedBehaviorOccurrence.end_of_day(current_time)
    @latest_date = CountedBehaviorOccurrence.beginning_of_day(latest_time).to_date
    @behavior_counts_by_date = ((earliest_time.to_date)..@latest_date).each_with_object({}) do |date, acc|
      acc[date] = @dog.counted_behavior_occurrences.seen_on(date).where(counted_behavior: @behavior).count
    end
  end

  def update_count
    @timezone = DEFAULT_TIMEZONE
    date = Time.use_zone(@timezone) { Time.zone.parse(params[:date]).to_date }
    occurrences = @dog.counted_behavior_occurrences.seen_on(date).where(counted_behavior: @behavior)
    new_count = params[:count].to_i
    existing_count = occurrences.count
    if new_count < existing_count
      remove_count = existing_count - new_count
      occurrences.order(seen_at: :desc).limit(remove_count).destroy_all
    elsif new_count > existing_count
      new_occurrences = (new_count - existing_count).times.map {
        # Don't have a specific time for these, so put them at end of day,
        # so they would be removed if the count is changed to be lower
        @dog.counted_behavior_occurrences.build(
          counted_behavior: @behavior,
          seen_at: CountedBehaviorOccurrence.end_of_day(date),
        )
      }
      unless new_occurrences.map(&:save).all?
        respond_to do |format|
          format.html { redirect_to dog_counted_behavior_counted_behavior_occurrences_path(@dog, @behavior), error: "Could not count behaviors!" }
          format.json { render json: new_occurrences.map(&:errors), status: :unprocessable_entity }
        end
        return
      end
    end
    respond_to do |format|
      format.html { redirect_to dog_counted_behavior_counted_behavior_occurrences_path(@dog, @behavior), notice: "Updated behavior count." }
      format.json { render :show, status: :created, location: counted_behavior_occurrences_url }
    end
  end

  def destroy_latest
    @occurrence = @dog.counted_behavior_occurrences.where(counted_behavior: @behavior).order(seen_at: :desc).first

    respond_to do |format|
      if @occurrence&.destroy
        format.html { redirect_to dog_counted_behavior_counted_behavior_occurrences_path(@dog, @behavior), notice: "Removed count." }
        format.json { render :show, status: :no_content, location: counted_behavior_occurrences_url }
      else
        format.html { redirect_to dog_counted_behavior_counted_behavior_occurrences_path(@dog, @behavior), error: "Could not remove count!" }
        format.json { render json: @occurrence.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_behavior
    @behavior = CountedBehavior.find(params[:counted_behavior_id])
  end
end
