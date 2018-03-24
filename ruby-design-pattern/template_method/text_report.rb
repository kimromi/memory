dir = File.expand_path(__dir__)
require "#{dir}/report"

class TextReport < Report
  def header
    "----- #{@title} -----"
  end

  def body
    @results.map{|r| "* #{r}" }.join("\n")
  end

  # フッタは何も出力しなくていいので実装していない
  # 基底クラスで実装を必須にしていないので書かなくてもよい
  # def footer
  # end
end

