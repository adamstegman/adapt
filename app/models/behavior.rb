# A Behavior that can be performed by a Dog.
# == Attributes
# === Required
# name:: the name of the Behavior.
class Behavior < ApplicationRecord
  validates_presence_of :name
end
