# A Dog whose Behavior is being tracked.
# == Attributes
# === Required
# name:: the Dog's name.
class Dog < ApplicationRecord
  validates_presence_of :name

  has_many :tracked_behaviors

  def self.poppy
    Dog.first
  end
end
