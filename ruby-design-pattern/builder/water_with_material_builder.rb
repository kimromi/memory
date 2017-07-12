class WaterWithMaterialBuilder
  def initialize(class_name)
    @water_with_material = class_name.new(0, 0)
  end

  def add_material(material_amount)
    @water_with_material.add_material(material_amount)
  end

  def add_water(water_amount)
    @water_with_material.water += water_amount
  end

  def result
    @water_with_material
  end
end
