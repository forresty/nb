require "redis"

module NaiveBayes
  module Backend
    class Redis
      class RedisHash
        def initialize(redis, hash_name)
          @redis = redis
          @hash_name = hash_name
        end

        def [](key)
          value = @redis.hget @hash_name, key
          value.to_f
        end

        def []=(key, value)
          @redis.hset @hash_name, key, value
        end

        def values
          @redis.hvals(@hash_name).map(&:to_f)
        end
      end

      attr_accessor :categories, :tokens_count

      def initialize(categories, options={})
        @redis = ::Redis.new(options)

        @redis.sadd "nb:set:categories", categories

        @tokens_count = {}

        categories.each do |category|
          @tokens_count[category] = Hash.new(0)
          self.categories_count[category] = 0
        end
      end

      def categories
        @redis.smembers("nb:set:categories").map(&:to_sym)
      end

      def categories_count
        @categories_count ||= RedisHash.new(@redis, "nb:hash:categories_count")
      end

      def train(category, *tokens)
        tokens.uniq.each do |token|
          @tokens_count[category][token] += 1
        end

        self.categories_count[category] += 1
      end

      def untrain(category, *tokens)
        tokens.uniq.each do |token|
          @tokens_count[category][token] -= 1
        end

        self.categories_count[category] -= 1
      end
    end
  end
end
