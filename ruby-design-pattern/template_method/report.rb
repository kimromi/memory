class Report
  def initialize(title, results)
    @title = title
    @results = results
  end

  def output
    [
      header,
      body,
      footer
    ].join("\n").strip
  end

  protected

  def header
  end

  def body
    raise NotImplementedError, 'must implemant'
  end

  def footer
  end
end

