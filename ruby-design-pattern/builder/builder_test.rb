require 'minitest/autorun'

dir = File.expand_path(__dir__)
require "#{dir}/water_with_material_builder"
require "#{dir}/sugar_water"
require "#{dir}/salt_water"
require "#{dir}/director"

class TestBuilder < MiniTest::Test
  def test_suger_water
    builder = WaterWithMaterialBuilder.new(SugarWater)
    director = Director.new(builder)
    director.cook

    assert_equal 125, builder.result.sugar
    assert_equal 450, builder.result.water
  end

  def test_salt_water
    builder = WaterWithMaterialBuilder.new(SaltWater)
    director = Director.new(builder)
    director.cook

    assert_equal 125, builder.result.salt
    assert_equal 450, builder.result.water
  end
end
