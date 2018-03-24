dir = File.expand_path(__dir__)
require "#{dir}/report"

class HtmlReport < Report
  def header
    <<~HTML.strip
      <html>
      <head>
      <title>#{@title}</title>
      </head>
      <body>
    HTML
  end

  def body
    <<~HTML.strip
      <ul>
      #{@results.map{|r| "<li>#{r}</li>" }.join("\n")}
      </ul>
    HTML
  end

  def footer
    <<~HTML.strip
      </body>
      </html>
    HTML
  end
end

