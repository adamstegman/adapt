class ApplicationController < ActionController::Base
  DEFAULT_TIMEZONE = "America/Chicago".freeze

  protected

  def set_dog
    # TODO: allow switching between dogs
    @dog = Dog.poppy
  end
end
