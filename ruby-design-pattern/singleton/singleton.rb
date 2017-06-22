# rubyで実装されているが独自で実装してみる
# require 'singleton'

class Singleton
  class << self
    def get_instance
      @@instance ||= new
    end

    private

    # 外からnewを呼べないようにする
    def new
      super
    end
  end
end

