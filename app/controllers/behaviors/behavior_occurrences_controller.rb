class Behaviors::BehaviorOccurrencesController < ApplicationController
  before_action :set_dog
  before_action :set_timezone
  before_action :set_behavior

  def index
    @today = Time.current.in_time_zone(@timezone).to_date
    @is_current_week = true
    # TODO: these page numbers are not persistent, so use dates instead?
    if (@page = params[:page].to_i) > 0
      @today = @page.weeks.before(@today)
      @is_current_week = false
    end
    earliest_date = 6.days.before(@today)
    behavior_occurrences = @dog.behavior_occurrences.where(
      behavior: @behavior,
      seen_on_date: earliest_date..@today,
    ).order(:seen_on_date).to_a
    @behavior_occurrences_by_date = (earliest_date..@today).each_with_object({}) do |date, acc|
      acc[date] = if behavior_occurrences[0]&.seen_on_date == date
        behavior_occurrences.shift
      else
        @dog.behavior_occurrences.build(behavior: @behavior, seen_on_date: date)
      end
    end
  end

  def create
    default_params = {seen_on_date: Time.current.in_time_zone(@timezone).to_date}
    @occurrence = @dog.behavior_occurrences.build(default_params.merge(behavior_occurrence_params).merge(behavior: @behavior))

    if @occurrence.save
      log("Created occurrence with #{behavior_occurrence_params.inspect}")
      redirect_to redirect_destination, notice: "Updated amount."
    else
      log("Could not create occurrence errors=#{@occurrence.errors.to_a.inspect}")
      redirect_to redirect_destination, error: "Could not update amount!"
    end
  end

  def update
    @occurrence = @dog.behavior_occurrences.find(params[:id])
    if @occurrence.update(behavior_occurrence_params)
      log("Updated occurrence to #{behavior_occurrence_params.inspect}")
      redirect_to redirect_destination, notice: "Updated amount."
    else
      log("Could not update occurrence errors=#{@occurrence.errors.to_a.inspect}")
      redirect_to redirect_destination, error: "Could not update amount!"
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def behavior_occurrence_params
    params.require(:behavior_occurrence).permit(:amount, :seen_on_date)
  end

  def set_behavior
    @behavior = Behavior.find(params[:behavior_id])
  end

  # Go back to the page you were on, whether #index or behaviors#index
  def redirect_destination
    # Root page has numbers as the submit button, so use that to figure out where we came from
    if params[:commit] =~ /\A[\d\.]+\z/
      dog_behaviors_path(@dog)
    else
      dog_behavior_behavior_occurrences_path(@dog, @behavior, page: params[:page].to_i)
    end
  end

  def log(msg)
    tags = [
      "dog_id=#{@dog&.id.inspect}",
      "behavior_id=#{@behavior&.id.inspect}",
    ]
    tags << "occurrence_id=#{@occurrence.id.inspect}" if @occurrence
    Rails.logger.tagged(tags) do
      Rails.logger.info(msg)
    end
  end
end
