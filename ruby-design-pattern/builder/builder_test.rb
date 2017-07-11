require 'minitest/autorun'

dir = File.expand_path(__dir__)
require "#{dir}/sugar_water_builder"
require "#{dir}/director"

class TestBuilder < MiniTest::Test
  def test_builder
    builder = SugarWaterBuilder.new
    director = Director.new(builder)
    director.cook

    assert_equal 125, builder.result.sugar
    assert_equal 450, builder.result.water
  end
end
