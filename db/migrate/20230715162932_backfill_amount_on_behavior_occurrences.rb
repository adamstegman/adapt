class BackfillAmountOnBehaviorOccurrences < ActiveRecord::Migration[7.0]
  DEFAULT_TIMEZONE = "America/Chicago".freeze
  NEW_DAY_HOUR = 4

  disable_ddl_transaction!

  class MigrationBehaviorOccurrence < ApplicationRecord
    self.table_name = "behavior_occurrences"
  end

  def up
    MigrationBehaviorOccurrence.reset_column_information
    dates = MigrationBehaviorOccurrence.pluck(:seen_at).map { date_from_time(_1.in_time_zone(DEFAULT_TIMEZONE)) }.uniq
    dates.each do |date|
      Behavior.pluck(:id).each do |behavior_id|
        occurrences = MigrationBehaviorOccurrence.where(behavior_id: behavior_id, seen_at: beginning_of_day(date)..end_of_day(date))
        saved_occurrence = occurrences.first
        next if saved_occurrence.nil? || saved_occurrence.amount > 0.0

        MigrationBehaviorOccurrence.transaction do
          saved_occurrence.update!(amount: occurrences.count)
          occurrences[1..-1].each(&:destroy!)
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def date_from_time(time)
    if time.hour < NEW_DAY_HOUR
      1.day.before(time).to_date
    else
      time.to_date
    end
  end

  def beginning_of_day(date)
    date.in_time_zone(DEFAULT_TIMEZONE).change(hour: NEW_DAY_HOUR)
  end

  def end_of_day(date)
    1.day.after(date.in_time_zone(DEFAULT_TIMEZONE)).change(
      hour: NEW_DAY_HOUR - 1,
      min: 59,
      sec: 59,
      usec: Rational(999999999, 1000),
    )
  end
end
