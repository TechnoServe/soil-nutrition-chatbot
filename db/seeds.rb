# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

cm_role = CmRole.find_or_create_by(name: 'Admin')

models = %w[User CmRole].freeze
models.each do |model|
  cm_model = CmAdmin::Model.find_by(name: model)
  next if cm_model.blank?

  available_actions = cm_model.available_actions.map(&:name)
  available_actions.each do |action|
    cm_role.cm_permissions.find_or_create_by(action_name: action, ar_model_name: model, scope_name: 'all')
  end
end

User.find_or_create_by(email: 'mahaveer@commutatus.com', first_name: 'Mahaveer', last_name: 'Soni', cm_role:)

stages = {
  'Chard' => [
    '01 - 07 DAYS Transplant and rooting',
    '07 - 15 DAYS Vegetative Development',
    '15 - 30 DAYS Rosette Growth',
    '30 - 45 DAYS Leaf Development',
    '45 - 60 DAYS Harvest'
  ],
  'Celery' => [
    '0 - 21 days Seedling',
    '22 - 30 days Transplant',
    '31 - 40 days True leaf formation',
    '41 - 90 days Growth',
    '91 - 100 days Harvest'
  ],
  'Beetroot' => [
    '0 - 45 days Seedling',
    '46 - 50 days Transplant',
    '51 - 61 days Formation of true leaves',
    '62 - 125 days Bulb formation',
    '126 - 135 days Harvest'
  ],
  'Broccoli' => [
    '0 - 45 days Transplant and rooting',
    '46 - 50 days Vegetative development',
    '51 - 60 days Floral induction',
    '61 - 70 days Rosette formation',
    '71 - 115 days Maturation and harvest'
  ],
  'Cocoa' => [
    'Post Harvest',
    'Pre-flowering',
    'Bloom',
    'Curdled',
    'Fruit growth'
  ],
  'Chives' => [
    '0 - 15 days Sowing',
    '16 - 25 days Formation of true leaves',
    '26 - 45 days bulb formation',
    '45 - 90 days bulb development',
    '90 - 120 days Harvest'
  ],
  'Chile' => [
    '0 - 20 DAYS Transplant and rooting',
    '21 - 40 DAYS Vegetative development',
    '41 - 60 DAYS Flowering',
    '61 - 80 DAYS fruiting',
    '81 - 100 DAYS Maturation',
    '101 - 140 DAYS Harvest'
  ],
  'Coriander' => [
    '0 - 20 days Sowing',
    '21 - 31 days Germination',
    '32 - 55 days Development',
    '56 - 60 days Harvest'
  ],
  'Cauliflower' => [
    '0 - 45 days Transplant and rooting',
    '46 - 50 days Vegetative development',
    '51 - 60 days Floral induction',
    '61 - 70 days Rosette formation',
    '71 - 115 days Maturation and harvest'
  ],
  'Peach/Plum' => [
    'Dormancy',
    'Pre-flowering (bud swelling)',
    'Bloom',
    'Fruit binding',
    'Filled with fruit',
    'Leaf abscission'
  ],
  'Spinach' => [
    '01 - 07 DAYS Transplant and rooting',
    '07 - 15 DAYS VEGETATIVE DEVELOPMENT',
    '15 - 30 DAYS ROSETTE GROWTH',
    '30 - 45 DAYS LEAF DEVELOPMENT',
    '45 - 60 DAYS HARVEST'
  ],
  'Tomato' => [
    '0 - 20 DAYS',
    '21 - 40 DAYS',
    '41 - 60 DAYS',
    '61 - 80 DAYS',
    '81 - 100 DAYS',
    '101 - 140 DAYS'
  ],
  'Mango' => [
    'Post Harvest',
    'Pre-flowering',
    'Bloom',
    'Curdled',
    'Fruit growth'
  ],
  'Orange' => [
    'Post Harvest (Dormancy)',
    'Pre-flowering',
    'bloom',
    'fruit set',
    'fruit filling'
  ],
  'Potato' => [
    '0 - 15 Days',
    '15 - 42 Days',
    '42 - 61 Days',
    '61 - 103 Days',
    '103 - 123 Days'
  ],
  'Parsley' => [
    '0 - 20 days Sowing',
    '21 - 31 days Germination',
    '32 - 55 days Development',
    '56 - 60 days Harvest'
  ],
  'Radish' => [
    '0 - 10 days Sowing',
    '11 - 15 days Formation of true leaf',
    '16 - 20 days Bulb formation',
    '21 - 26 days Bulb Development',
    '27 - 30 days Harvest'
  ],
  'Watermelon' => [
    '0 - 15 Days',
    '15 - 30 Days',
    '31 - 45 Days',
    '46 - 60 Days',
    '61 - 75 Days',
    '76 - 90 Days'
  ],
  'Persian Lemon' => [
    'Sprouting',
    'Floral Bud Development',
    'Mature Flower Bud',
    'Fruit Setting',
    'Fruit Filling'
  ],
  'Strawberry' => [
    'Plantation',
    'Vegetative development',
    'Bloom',
    'Fruit setting',
    'Filled with fruit'
  ]
}

puts '<------------------- Creating Constants -------------------->'
filepath = "#{Rails.root}/imports/constants.csv"
CSV.foreach(filepath, headers: true) do |row|
  parent = Constant.find_by(name: row['parent_name'])
  if row['name'].present?
    constant = Constant.find_or_create_by(name: row['name'], constant_type: row['constant_type'], parent:,
                                          slug: row['slug'])
    constant.update(carbon_content: row['carbon_content']) if row['carbon_content'].present?
    constant.update(stages: stages[constant.name]) if constant.crop?
  end
end

filepath = "#{Rails.root}/imports/crop_productions.csv"
CSV.foreach(filepath, headers: true) do |row|
  crop = Constant.find_by(name: row['crop'])
  desired_productivity = Constant.find_by(name: row['desired_productivity'])
  CropProduction.find_or_create_by(crop:, desired_productivity:, productivity: row['productivity']) if crop.present? && desired_productivity.present?
end

filepath = "#{Rails.root}/imports/crop_nutrient_demands.csv"
CSV.foreach(filepath, headers: true) do |row|
  crop = Constant.find_by(name: row['crop'])
  nutrient = Constant.find_by(name: row['nutrient'])
  cdn = CropNutrientDemand.find_or_create_by(crop:, nutrient:) if crop.present? && nutrient.present?
  cdn.update!(value: row['value']) if cdn.present?
end

filepath = "#{Rails.root}/imports/crop_nutrient_requirements.csv"
CSV.foreach(filepath, headers: true) do |row|
  nutrients = [{ name: 'N', unit: 'kg' }, { name: 'P2O5', unit: 'kg' }, { name: 'K2O', unit: 'kg' }, { name: 'CaO', unit: 'kg' },
               { name: 'MgO', unit: 'kg' }, { name: 'S', unit: 'kg' }, { name: 'Fe', unit: 'g' }, { name: 'Zn', unit: 'g' },
               { name: 'Mn', unit: 'g' }, { name: 'Cu', unit: 'g' }, { name: 'B', unit: 'g' }]
  crop = Constant.find_by(name: row['crop'])
  next if crop.blank?

  nutrients.each do |n_hash|
    nutrient = Constant.find_by(name: n_hash[:name])
    unit = Constant.find_by(slug: n_hash[:unit])
    crop_nutrient_requirement = CropNutrientRequirement.find_or_create_by(crop:, nutrient:, unit:)
    case row['concept']
    when 'requirement_per_ton'
      crop_nutrient_requirement.update(requirement_per_ton: row[nutrient.name])
    when 'performance'
      crop_nutrient_requirement.update(performance: row[nutrient.name])
    when 'total_requirement'
      crop_nutrient_requirement.update(total_requirement: row[nutrient.name])
    else
      stage = "stage#{row['concept']}"
      crop_nutrient_requirement.update(stage => row[nutrient.name])
    end
  end
end

crops_translation = {
  Chard: 'Acelga',
  Celery: 'Apio',
  Beetroot: 'Betabel',
  Broccoli: 'Brocoli',
  Cocoa: 'Cacao',
  Chives: 'Cebollin',
  Chile: 'Chile',
  Coriander: 'Cilantro',
  Cauliflower: 'Coliflor',
  'Peach/Plum': 'Durazno/Ciruela',
  Spinach: 'Espinaca',
  Tomato: 'Jitomate',
  Mango: 'Mango',
  Orange: 'Naranja',
  Potato: 'Papa',
  Parsley: 'Perejil',
  Radish: 'Rabano',
  Watermelon: 'Sandia',
  Banana: 'Plátano',
  'Persian Lemon': 'Limon Persa',
  Strawberry: 'Fresa'
}.with_indifferent_access

stages_translation = {
  'Acelga' => [
    '01 - 07 DIAS Trasplante y enraizamiento',
    '07 - 15 DIAS DESARROLLO VEGETATIVO',
    '15 - 30 DIASCRECIMIENTOS DE ROSETA',
    '30 - 45 DIAS DESARROLLO DE HOJAS ',
    '45 - 60 DIAS COSECHA '
  ],

  'Apio' => [
    '0 - 21 dias Plantula',
    '22 - 30 dias Trasplante',
    '31 - 40 dias Formacion de hojas verdadera',
    '41 - 90 dias Crecimiento',
    '91 - 100 dias Cosecha'
  ],

  'Betabel' => [
    '0 - 45 dias Plantula',
    '46 - 50 dias Trasplante',
    '51 - 61 dias Formacion de Hojas verdaderas',
    '62 - 125 dias Formacion de bulbo',
    '126 - 135 dias Cosecha'
  ],

  'Brocoli' => [
    '0 - 45 dias Trasplante y enraizamiento',
    '46 - 50 dias Desarrollo de vegetativo',
    '51 - 60 dias Induccion floral',
    '61 - 70 dias Formacion de la roseta',
    '71 - 115 dias Maduracion y cosecha'
  ],

  'Cacao' => [
    'Poscosecha',
    'Prefloración',
    'Floración',
    'Cuajado',
    'Crecimiento de fruto'
  ],

  'Cebollin' => [
    '0 - 15 dias Siembra',
    '16 - 25 dias Formacion de hojas verdadera',
    '26 - 45 dias formacion de bulbo',
    '45 - 90 dias desarrollo de bulbo',
    '90 - 120 dias Cosecha'
  ],

  'Chile' => [
    '0 - 20 DIAS Trasplante y enraizamiento',
    '21 - 40 DIAS Desarrollo de vegetativo',
    '41 - 60 DIAS Floracion',
    '61 - 80 DIAS fructificacion',
    '81 - 100 DIAS Maduracion',
    '101 - 140 DIAS Cosecha'
  ],

  'Cilantro' => [
    '0 - 20 dias Siembra',
    '21 - 31 dias Germinacion',
    '32 - 55 dias Desarrollo',
    '56 - 60 dias Cosecha'
  ],

  'Coliflor' => [
    '0 - 45 dias Trasplante y enraizamiento',
    '46 - 50 dias Desarrollo de vegetativo',
    '51 - 60 dias Induccion floral',
    '61 - 70 dias Formacion de la roseta',
    '71 - 115 dias Maduracion y cosecha'
  ],

  'Durazno/Ciruela' => [
    'Dormancia',
    'Prefloración (Hinchamiento de yema)',
    'Floración',
    'Amarre de fruto',
    'Llenado de fruto',
    'Absicion foliar'
  ],

  'Espinaca' => [
    '01 - 07 DIAS Trasplante y enraizamiento',
    '07 - 15 DIAS DESARROLLO VEGETATIVO',
    '15 - 30 DIAS CRECIMIENTOS DE ROSETA',
    '30 - 45 DIAS DESARROLLO DE HOJAS',
    '45 - 60 DIAS COSECHA'
  ],

  'Jitomate' => [
    '0 - 20 DIAS',
    '21 - 40 DIAS',
    '41 - 60 DIAS',
    '61 - 80 DIAS',
    '81 - 100 DIAS',
    '101 - 140 DIAS'
  ],

  'Mango' => [
    'Poscosecha',
    'Prefloración',
    'Floración',
    'Cuajado',
    'Crecimiento de fruto'
  ],

  'Naranja' => [
    'Poscosecha (Dormancia)',
    'Prefloración',
    'floración',
    'cuajado de fruto',
    'llenado de fruto'
  ],

  'Papa' => [
    '0 - 15 DIAS',
    '15 - 42 DIAS',
    '42 - 61 DIAS',
    '61 - 103 DIAS',
    '103 - 123 DIAS'
  ],

  'Perejil' => [
    '0 - 20 dias Siembra',
    '21 - 31 dias Germinacion',
    '32 - 55 dias Desarrollo',
    '56 - 60 dias Cosecha'
  ],

  'Rabano' => [
    '0 - 10 dias Siembra',
    '11 - 15 dias Formacion de hoja verdadera',
    '16 - 20 dias Formacion de bulbo',
    '21 - 26 dias Desarrollo de Bulbo',
    '27 - 30 dias Cosecha'
  ],

  'Sandia' => [
    '0 - 15 DIAS',
    '15 - 30 DIAS',
    '31 - 45 DIAS',
    '46 - 60 DIAS',
    '61 - 75 DIAS',
    '76 - 90 DIAS'
  ],

  'Limon Persa' => [
    'Brotacion',
    'Desarrollo Yema Floral',
    'Yema Floral Madura',
    'Cuajado De Fruto',
    'Llenado De Fruto'
  ],
  'Fresa' => [
    'Plantacion',
    'Desarrollo Vegetativo',
    'Floracion',
    'Cuajado De Frutos',
    'Llenado De Fruto'
  ]
}

amendments_translation = {
  'Agricultural lime' => 'Cal agrícola',
  'Dolomite lime' => 'Cal dolomita',
  'Organic matter' => 'Materia orgánica',
  'First year agricultural gypsum and second year dolomite lime' => 'Primer año yeso agrícola y segundo año cal dolomita',
  'First year agricultural gypsum and second year organic matter' => 'Primer año yeso agrícola y segundo año materia orgánica',
  'Agricultural Gypsum' => 'Yeso agrícola'
}.with_indifferent_access

organic_matters_translation = {
  'Bocashi' => 'Bocashi',
  'Compost' => 'Composta',
  'Goat manure' => 'Estiércol caprino',
  'Rabbit manure' => 'Estiércol de conejo',
  'Pig manure' => 'Estiércol porcino',
  'Cow manure' => 'Estiércol vacuno',
  'Chicken manure' => 'Gallinaza',
  'Lombricompost' => 'Lombricomposta',
  'Rice straw' => 'Paja de arroz',
  'Coffee pulp' => 'Pulpa de café',
  'Urban solid waste' => 'Residuos sólidos urbanos',
  'Vernicomposta' => 'Vernicomposta'
}.with_indifferent_access

desired_productivity_translation = {
  'Low' => 'Baja',
  'Average' => 'Media',
  'High' => 'Alta',
  'Very High' => 'Muy Alta',
  'Very Low' => 'Muy Baja'
}.with_indifferent_access

age_range_translation = {
  'From 16 to 29 years': 'De 16 a 29 años',
  'From 30 to 50 years': 'De 30 a 50 años',
  'From 50 to 65 years': 'De 50 a 65 años',
  'Above 65 years': 'Más de 65 años'
}.with_indifferent_access

gender_translation = {
  'Male': 'Masculino',
  'Female': 'Femenino'
}.with_indifferent_access

Constant.crop.each do |crop|
  crop_translation = crops_translation[crop.name]
  stage_translation = stages_translation[crop_translation]
  ct = crop.constant_translations.find_or_create_by(locale: 'es', name: crop_translation)
  ct.update(stages: stage_translation)
end

Constant.amendment.each do |amendment|
  amendment.constant_translations.find_or_create_by(locale: 'es', name: amendments_translation[amendment.name])
end

Constant.organic_matter.each do |organic_matter|
  organic_matter.constant_translations.find_or_create_by(locale: 'es', name: organic_matters_translation[organic_matter.name])
end

Constant.desired_productivity.each do |desired_productivity|
  desired_productivity.constant_translations.find_or_create_by(locale: 'es', name: desired_productivity_translation[desired_productivity.name])
end

Constant.gender.each do |gender|
  gender.constant_translations.find_or_create_by(locale: 'es', name: gender_translation[gender.name])
end

Constant.age_range.each do |age_range|
  age_range.constant_translations.find_or_create_by(locale: 'es', name: age_range_translation[age_range.name])
end
