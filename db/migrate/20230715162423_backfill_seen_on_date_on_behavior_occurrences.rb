class BackfillSeenOnDateOnBehaviorOccurrences < ActiveRecord::Migration[7.0]
  DEFAULT_TIMEZONE = "America/Chicago".freeze
  NEW_DAY_HOUR = 4

  disable_ddl_transaction!

  class MigrationBehaviorOccurrence < ApplicationRecord
    self.table_name = "behavior_occurrences"
  end

  def up
    MigrationBehaviorOccurrence.where(seen_on_date: nil).find_each do |occurrence|
      time = occurrence.seen_at.in_time_zone(DEFAULT_TIMEZONE)
      date = date_from_time(time)
      occurrence.update!(seen_on_date: date)
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
end
