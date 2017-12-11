# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
InclusionScenerio.find_or_create_by(description: 'dynamic amois and cnv/snv')
InclusionScenerio.find_or_create_by(description: 'cnv/snv')
InclusionScenerio.find_or_create_by(description: 'dynamic amois')
InclusionScenerio.find_or_create_by(description: 'standard')


ExclusionScenerio.find_or_create_by(description: 'no exclusions')
ExclusionScenerio.find_or_create_by(description: 'disease only exclusions')
ExclusionScenerio.find_or_create_by(description: 'drug only exclusions')
ExclusionScenerio.find_or_create_by(description: 'amoi only exclusions')
ExclusionScenerio.find_or_create_by(description: 'standard exclusions')
