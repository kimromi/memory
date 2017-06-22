# rubyで実装されているが独自で実装してみる
# require 'singleton'

class Singleton
  class << self
    def instance
      @@instance ||= new
    end

    private

    # 外からnewを呼べないようにする
    def new
      super
    end
  end

  attr_reader :counter

  def initialize
    @counter = 0
  end

  def increment
    @counter = @counter + 1
  end
end

