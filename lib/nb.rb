class NaiveBayes
  VERSION = "0.0.1"

  def initialize(categories = [])
    @categories = []
  end

  def train(category, *features)
    raise 'not implemented yet'
  end

  def save
    raise 'not implemented yet'
  end

  class << self
    def load_yaml(yaml_file)
      raise 'not implemented yet'
    end
  end
end
