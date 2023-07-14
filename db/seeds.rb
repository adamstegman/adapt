# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Dog.find_or_create_by!(name: "Poppy")

CountedBehavior.find_or_initialize_by(name: "Stress Barking").update!(color: CountedBehavior.colors[:pink])
CountedBehavior.find_or_initialize_by(name: "Crazy Barking").update!(color: CountedBehavior.colors[:red])
CountedBehavior.find_or_initialize_by(name: "Bed Barking").update!(color: CountedBehavior.colors[:deep_orange])
CountedBehavior.find_or_initialize_by(name: "Stress Panting").update!(color: CountedBehavior.colors[:deep_purple])
CountedBehavior.find_or_initialize_by(name: "Pacing").update!(color: CountedBehavior.colors[:purple])
CountedBehavior.find_or_initialize_by(name: "Jumpy").update!(color: CountedBehavior.colors[:blue])
CountedBehavior.find_or_initialize_by(name: "Accident").update!(color: CountedBehavior.colors[:yellow])
CountedBehavior.find_or_initialize_by(name: "Refusing Food").update!(color: CountedBehavior.colors[:cyan])
