require "#{File.expand_path(__dir__)}/abstract_factory"
require 'minitest/autorun'

class TestAbstractFactory < MiniTest::Test
  def test_frog_and_algae
    factory = FrogAndAlgaeFactory.new(4, 2)
    factory.get_animals.each_with_index do |animal, i|
      assert_equal "カエル 動物 #{i} は食事中です", animal.eat
    end
    factory.get_plants.each_with_index do |plant, i|
      assert_equal "藻 植物 #{i} は成長中です", plant.grow
    end
  end

  def test_duck_and_water_lily
    factory = DuckAndWaterLilyFactory.new(5, 3)
    factory.get_animals.each_with_index do |animal, i|
      assert_equal "アヒル 動物 #{i} は食事中です", animal.eat
    end
    factory.get_plants.each_with_index do |plant, i|
      assert_equal "スイレン 植物 #{i} は成長中です", plant.grow
    end
  end
end
