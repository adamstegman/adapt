json.behaviors @behaviors do |behavior|
  json.partial! "tracked_behaviors/behavior", behavior: behavior, count: @tracked_behavior_counts_by_behavior_id[behavior.id] || 0
end
