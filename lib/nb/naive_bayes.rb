require "yaml"

class NaiveBayes
  attr_accessor :categories, :tokens_count, :categories_count

  def initialize(*categories)
    @categories = categories
    @tokens_count = {}
    @categories_count = {}

    categories.each do |category|
      @tokens_count[category] = Hash.new(0)
      @categories_count[category] = 0
    end
  end

  def train(category, *tokens)
    tokens.uniq.each do |token|
      @tokens_count[category][token] += 1
    end
    @categories_count[category] += 1
  end

  def classify(*tokens)
    classifications(*tokens).first
  end

  def classifications(*tokens)
    scores = {}
    @categories.each do |category|
      scores[category] = probability_of_tokens_given_a_category(tokens, category) * probability_of_a_category(category)
    end
    scores.sort_by { |k, v| -v }
  end

  def top_tokens_of_category(category, count=20)
    tokens_count[category].map { |k, v| [k, v, probability_of_a_token_in_category(k, category)] }.sort_by { |i| -i.last }.first(count)
  end

  def probability_of_a_token_in_category(token, category)
    probability_of_a_token_given_a_category(token, category) / @categories.inject(0.0) { |r, c| r + probability_of_a_token_given_a_category(token, c) }
  end

  def probability_of_a_token_given_a_category(token, category)
    return assumed_probability if @tokens_count[category][token] == 0

    @tokens_count[category][token].to_f / @categories_count[category]
  end

  def probability_of_tokens_given_a_category(tokens, category)
    tokens.inject(1.0) do |product, token|
      product * probability_of_a_token_given_a_category(token, category)
    end
  end

  def probability_of_a_category(category)
    @categories_count[category].to_f / total_number_of_items
  end

  # def total_number_of_tokens
  #   @tokens_count.values.inject(0) { |sum, hash| sum + hash.values.inject(&:+) }
  # end

  def total_number_of_items
    @categories_count.values.inject(&:+)
  end

  # If we have only trained a little bit a class may not have had a feature yet
  # give it a probability of 0 may not be true so we produce a assumed probability
  # which gets smaller more we train
  def assumed_probability
    0.5 / (total_number_of_items.to_f / 2)
  end

  def data
    {
      :categories => @categories,
      :tokens_count => @tokens_count,
      :categories_count => @categories_count
    }
  end

  def save(yaml_file)
    File.write(yaml_file, data.to_yaml)
  end

  class << self
    def load_yaml(yaml_file)
      data = YAML.load_file(yaml_file)

      new.tap do |bayes|
        bayes.categories = data[:categories]
        bayes.tokens_count = data[:tokens_count]
        bayes.categories_count = data[:categories_count]
      end
    end
  end
end
