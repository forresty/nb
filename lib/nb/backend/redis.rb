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

        def incr(key)
          @redis.hincrby @hash_name, key, 1
        end

        def decr(key)
          @redis.hdecrby @hash_name, key, 1
        end

        def values
          @redis.hvals(@hash_name).map(&:to_f)
        end

        def map
          out = []

          if block_given?
            @redis.hkeys(@hash_name).each { |k| out << yield(k, self.[](k)) }
          else
            out = to_enum :map
          end

          out
        end
      end

      def initialize(categories, options={})
        @redis = ::Redis.new(options)

        @_categories = categories

        setup
      end

      def categories
        @redis.smembers("nb:set:categories").map(&:to_sym)
      end

      def categories_count
        @categories_count ||= RedisHash.new(@redis, "nb:hash:categories_count")
      end

      def tokens_count
        @tokens_count ||= Hash.new
      end

      def clear!
        @redis.flushall

        setup

        categories.each do |category|
          self.categories_count[category] = 0
        end
      end

      def setup
        @redis.sadd "nb:set:categories", @_categories

        categories.each do |category|
          # @tokens_count[category] = Hash.new(0)
          self.tokens_count[category] = RedisHash.new(@redis, "nb:hash:tokens_count:#{category}")
        end
      end

      def train(category, *tokens)
        tokens.uniq.each do |token|
          self.tokens_count[category].incr(token)
        end

        self.categories_count.incr(category)
      end

      def untrain(category, *tokens)
        tokens.uniq.each do |token|
          self.tokens_count[category][token].decr(token)
        end

        self.categories_count.decr(category)
      end
    end
  end
end
