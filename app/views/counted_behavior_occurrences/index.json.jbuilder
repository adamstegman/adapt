json.behaviors @counted_behaviors do |behavior|
  json.partial! "counted_behavior_occurrences/counted_behavior", counted_behavior: behavior, count: @behavior_counts_by_behavior_id[behavior.id] || 0
end
