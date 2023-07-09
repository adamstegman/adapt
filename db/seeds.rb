# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Dog.find_or_create_by!(name: "Poppy")

Behavior.find_or_create_by!(name: "Sleep")
Behavior.find_or_create_by!(name: "Rest")
Behavior.find_or_create_by!(name: "Night Waking")
Behavior.find_or_create_by!(name: "Stress Barking")
Behavior.find_or_create_by!(name: "Crazy Barking")
Behavior.find_or_create_by!(name: "Bed Barking")
Behavior.find_or_create_by!(name: "Stress Panting")
Behavior.find_or_create_by!(name: "Pacing")
Behavior.find_or_create_by!(name: "Jumpy")
Behavior.find_or_create_by!(name: "Accident")
Behavior.find_or_create_by!(name: "Refusing Food")
