require "#{File.expand_path(__dir__)}/singleton"
require 'minitest/autorun'

class TestSingleton < MiniTest::Test
  def test_get_instance
    object1 = Singleton.get_instance
    object2 = Singleton.get_instance
    assert_equal object1.object_id, object2.object_id
  end

  def test_uncallable_new
    assert_raises NoMethodError do
      Singleton.new
    end
  end

  def test_counter
    object1 = Singleton.get_instance
    assert_equal object1.counter, 0

    object2 = Singleton.get_instance
    object2.increment

    object3 = Singleton.get_instance
    assert_equal object3.counter, 1
  end
end
