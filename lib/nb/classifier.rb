require "yaml"

module NaiveBayes
  class Classifier
    attr_accessor :default_category
    attr_accessor :backend

    def initialize(*categories)
      if categories.last.is_a?(Hash)
        options = categories.pop
      else
        options = {}
      end

      options[:backend] ||= :memory

      case options[:backend]
      when :memory
        @backend = Backend::Memory.new(categories)
      when :redis
        options[:host] ||= 'localhost'
        options[:port] ||= 6379

        @backend = Backend::Redis.new(categories, host: options[:host], port: options[:port])
      else
        raise "unsupported backend: #{options[:backend]}"
      end

      @default_category = categories.first
    end

    def train(category, *tokens)
      backend.train(category, *tokens)
    end

    def untrain(category, *tokens)
      backend.untrain(category, *tokens)
    end

    def classify(*tokens)
      result = classifications(*tokens).first

      if result.last == 0.0
        [@default_category, 0.0]
      else
        result
      end
    end

    def classifications(*tokens)
      scores = {}
      backend.categories.each do |category|
        scores[category] = probability_of_tokens_given_a_category(tokens, category) * probability_of_a_category(category)
      end
      scores.sort_by { |k, v| -v }
    end

    def top_tokens_of_category(category, count=20)
      backend.tokens_count[category].map { |k, v| [k, v, probability_of_a_token_in_category(k, category)] }.sort_by { |i| -i.last }.first(count)
    end

    def probability_of_a_token_in_category(token, category)
      probability_of_a_token_given_a_category(token, category) / backend.categories.inject(0.0) { |r, c| r + probability_of_a_token_given_a_category(token, c) }
    end

    def probability_of_a_token_given_a_category(token, category)
      return assumed_probability if backend.tokens_count[category][token] == 0

      backend.tokens_count[category][token].to_f / backend.categories_count[category]
    end

    def probability_of_tokens_given_a_category(tokens, category)
      tokens.inject(1.0) do |product, token|
        product * probability_of_a_token_given_a_category(token, category)
      end
    end

    def probability_of_a_category(category)
      backend.categories_count[category].to_f / total_number_of_items
    end

    # def total_number_of_tokens
    #   @tokens_count.values.inject(0) { |sum, hash| sum + hash.values.inject(&:+) }
    # end

    def total_number_of_items
      backend.categories_count.values.inject(&:+)
    end

    # If we have only trained a little bit a class may not have had a feature yet
    # give it a probability of 0 may not be true so we produce a assumed probability
    # which gets smaller more we train
    def assumed_probability
      0.5 / (total_number_of_items.to_f / 2)
    end

    def data
      {
        :categories => backend.categories,
        :tokens_count => backend.tokens_count,
        :categories_count => backend.categories_count
      }
    end

    def save(yaml_file)
      raise 'only memory backend can save' unless backend == :memory

      File.write(yaml_file, data.to_yaml)
    end

    class << self
      # will load into a memory-backed classifier
      def load_yaml(yaml_file)
        data = YAML.load_file(yaml_file)

        new(data[:categories], backend: :memory).tap do |classifier|
          classifier.tokens_count = data[:tokens_count]
          classifier.categories_count = data[:categories_count]
        end
      end
    end
  end
end
