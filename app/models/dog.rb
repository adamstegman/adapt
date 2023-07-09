# A Dog whose behavior is being tracked.
# == Attributes
# === Required
# name:: the Dog's name.
class Dog < ApplicationRecord
  validates_presence_of :name
end
