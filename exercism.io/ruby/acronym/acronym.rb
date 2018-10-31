class Acronym
  def self.abbreviate(sentence)
    sentence.split(/[\s-]/).delete_if(&:empty?).map{|word| word[0].upcase }.join
  end
end
