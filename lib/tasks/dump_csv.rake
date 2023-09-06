namespace :crazy_dog do
  desc "Dumps all behavior data to a CSV from the beginning"
  task dump_csv: :environment do |task|
    require "csv"
    Rails.logger.tagged(task.name) do
      first_date = BehaviorOccurrence.select(:seen_on_date).distinct.order(seen_on_date: :asc).first.seen_on_date
      last_date = Date.yesterday
      Rails.logger.info("first_date=#{first_date.inspect} last_date=#{last_date.inspect}")

      behaviors = Behavior.order(name: :asc)
      behavior_csv = CSV.generate do |csv|
        csv << ["Date"] + behaviors.map(&:name)
        (first_date..last_date).each do |date|
          data = [date]
          # TODO: optimize query
          behaviors.each do |behavior|
            occurrence = BehaviorOccurrence.find_by(seen_on_date: date, behavior: behavior)
            data << occurrence&.amount || 0.0
          end
          csv << data
        end
      end
      File.write("#{last_date.iso8601}-behaviors.csv", behavior_csv)
    end
  end
end
