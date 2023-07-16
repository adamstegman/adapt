# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Dog.find_or_create_by!(name: "Poppy")

Behavior.find_or_initialize_by(name: "Stress Barking").update!(color: Behavior.colors[:pink])
Behavior.find_or_initialize_by(name: "Crazy Barking").update!(color: Behavior.colors[:red])
Behavior.find_or_initialize_by(name: "Bed Barking").update!(color: Behavior.colors[:deep_orange])
Behavior.find_or_initialize_by(name: "Stress Panting").update!(color: Behavior.colors[:deep_purple])
Behavior.find_or_initialize_by(name: "Pacing").update!(color: Behavior.colors[:purple])
Behavior.find_or_initialize_by(name: "Jumpy").update!(color: Behavior.colors[:blue])
Behavior.find_or_initialize_by(name: "Accident").update!(color: Behavior.colors[:yellow])
Behavior.find_or_initialize_by(name: "Refusing Food").update!(color: Behavior.colors[:cyan])
Behavior.find_or_initialize_by(name: "Sleep").update!(color: Behavior.colors[:light_blue])
Behavior.find_or_initialize_by(name: "Rest").update!(color: Behavior.colors[:light_green])
Behavior.find_or_initialize_by(name: "Night Waking").update!(color: Behavior.colors[:orange])
