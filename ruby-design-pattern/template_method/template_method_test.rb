require 'minitest/autorun'

dir = File.expand_path(__dir__)
require "#{dir}/html_report"
require "#{dir}/text_report"

class TestTemplateMethod < MiniTest::Test
  def setup
    @title = '月次報告'
    @results = %w(A B C)
  end

  def test_html
    report = HtmlReport.new(@title, @results)
    assert_equal report.output, <<~REPORT.strip
      <html>
      <head>
      <title>月次報告</title>
      </head>
      <body>
      <ul>
      <li>A</li>
      <li>B</li>
      <li>C</li>
      </ul>
      </body>
      </html>
    REPORT
  end

  def test_text
    report = TextReport.new(@title, @results)
    assert_equal report.output, <<~REPORT.strip
      ----- 月次報告 -----
      * A
      * B
      * C
    REPORT
  end

end
