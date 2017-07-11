dir = File.expand_path(__dir__)
require "#{dir}/sugar_water"

class SugarWaterBuilder
  def initialize
    @sugar_water = SugarWater.new(0, 0)
  end

  def add_sugar(sugar_amount)
    @sugar_water.sugar += sugar_amount
  end

  def add_water(water_amount)
    @sugar_water.water += water_amount
  end

  def result
    @sugar_water
  end
end
