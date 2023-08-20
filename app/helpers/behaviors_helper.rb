module BehaviorsHelper
  def modified_time_ago_in_words(from_time, options = {})
    default = time_ago_in_words(from_time, options)
    return default if default == "just now"

    "#{default} ago"
  end
end
