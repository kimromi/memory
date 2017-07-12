class SaltWater
  attr_accessor :water, :salt

  def initialize(water, salt)
    @water = water
    @salt = salt
  end

  def add_material(salt_amount)
    @salt += salt_amount
  end
end
