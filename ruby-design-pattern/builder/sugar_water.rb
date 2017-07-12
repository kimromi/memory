class SugarWater
  attr_accessor :water, :sugar

  def initialize(water, sugar)
    @water = water
    @sugar = sugar
  end

  def add_material(sugar_amount)
    @sugar += sugar_amount
  end
end
