namespace :crazy_dog do
  desc "Loads behavior data from a CSV with all behaviors in it, exported from Numbers"
  task :load_csv, [:csv_filename] => :environment do |task, args|
    require "csv"
    BEHAVIOR_NAMES_BY_HEADER ||= {
      accidents: "Accident",
      bed_barking: "Bed Bark",
      crazy_barking: "Crazy Bark",
      jumpy: "Jumpy",
      night_waking: "Night Wake",
      pacing: "Pacing",
      refusing_food: "Refuse Food",
      rest: "Rest",
      sleep: "Sleep",
      stress_barking: "Stress Bark",
      stress_panting: "Stress Pant",
    }.freeze
    Rails.logger.tagged(task.name, "filename=#{args[:csv_filename].inspect}") do
      # TODO: multi-dog support
      dog = Dog.poppy
      contents = File.read(args[:csv_filename])
      # Numbers exports all tables in the file, so parse them out
      tables = contents.split(/(\r\n){2,}/).map { |table|
        CSV.parse(table, headers: true, header_converters: :symbol)
      }
      Rails.logger.info("Found #{tables.size} tables")

      last_columns = []
      year = 2021
      tables.each do |table|
        behaviors_by_column = table.headers.inject({}) { |acc, column|
          behavior_name = BEHAVIOR_NAMES_BY_HEADER[column]
          if behavior_name
            behavior = Behavior.find_by(name: behavior_name) || raise("No behavior found with name=#{behavior_name.inspect} for column=#{column.inspect}")
            acc.merge(column => behavior)
          else
            acc
          end
        }
        Rails.logger.info("behaviors=#{behaviors_by_column.keys.inspect} rows=#{table.size} headers=#{table.headers.inspect}")
        next if behaviors_by_column.empty?

        # start year over at 2021 for every new set of behaviors
        if behaviors_by_column.keys != last_columns
          last_columns = behaviors_by_column.keys
          year = 2022
        end
        table.each do |row|
          seen_on_date = row[:date] || row[nil] # date column (first column) can be unlabeled
          parsed_seen_on_date = Time.zone.parse(seen_on_date)
          if parsed_seen_on_date.month == 1 && parsed_seen_on_date.day == 1
            year += 1
          end
          parsed_seen_on_date = parsed_seen_on_date.change(year: year)
          behaviors_by_column.each do |column, behavior|
            amount = row[column].to_f
            if amount && amount > 0.0
              occurrence = BehaviorOccurrence.find_by(
                dog: dog,
                behavior: behavior,
                seen_on_date: parsed_seen_on_date,
              )
              if occurrence
                Rails.logger.warn("BehaviorOccurrence id=#{occurrence.id} already found for behavior_id=#{behavior.id} seen_on_date=#{parsed_seen_on_date.inspect}; old_amount=#{occurrence.amount.inspect}")
              end
              occurrence ||= BehaviorOccurrence.new(
                dog: dog,
                behavior: behavior,
                seen_on_date: parsed_seen_on_date,
              )
              Rails.logger.info("Updating! behavior=#{behavior.name} seen_on_date=#{parsed_seen_on_date.inspect} amount=#{amount.inspect}")
              occurrence.update!(amount: amount)
            else
              Rails.logger.warn("Nothing. amount=#{amount.inspect} on row date=#{parsed_seen_on_date.inspect} column=#{column}")
            end
          end
        rescue => e
          backtrace = e.backtrace.select { _1.include?(Rails.root.to_s) }.join("\n")
          Rails.logger.error("#{e.class.name}: #{e.message}. row=#{row.inspect}\n#{backtrace}")
        end
      end
    end
  end
end
