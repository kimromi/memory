dir = File.expand_path(__dir__)
require "#{dir}/duck"
require "#{dir}/frog"
require "#{dir}/algae"
require "#{dir}/water_lily"

# 池の生態系を作る (Abstract Factory)
class OrganismFactory
  def initialize(number_animals, number_plants)
    @animals = []
    # 池の動物を定義する
    number_animals.times do |i|
      @animals << new_animal("動物 #{i}")
    end

    @plants = []
    # 池の植物を定義する
    number_plants.times do |i|
      @plants << new_plant("植物 #{i}")
    end
  end

  # 植物についてのオブジェクトを返す
  def get_plants
    @plants
  end

  # 動物についてのオブジェクトを返す
  def get_animals
    @animals
  end
end

# カエル(Frog)と藻(Algae)の生成を行う (Concrete Factory)
class FrogAndAlgaeFactory < OrganismFactory
  private

  def new_animal(name)
    Frog.new(name)
  end

  def new_plant(name)
    Algae.new(name)
  end
end

# アヒル(Duck)とスイレン(WaterLily)の生成を行う(Concrete Factory)
class DuckAndWaterLilyFactory < OrganismFactory
  private

  def new_animal(name)
    Duck.new(name)
  end

  def new_plant(name)
    WaterLily.new(name)
  end
end
