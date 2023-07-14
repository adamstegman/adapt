# A Dog whose behavior is being tracked.
# == Attributes
# === Required
# name:: the Dog's name.
class Dog < ApplicationRecord
  validates_presence_of :name

  has_many :counted_behavior_occurrences

  def self.poppy
    Dog.first
  end
end
