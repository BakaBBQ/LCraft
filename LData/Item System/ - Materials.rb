material_properties = [
  :hardness,
  :toughness,
  :food,
  :toxicity,

  
  :icon_index,
  :density,
  :label
]
Material = Struct.new(*material_properties)