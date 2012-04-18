module Streak
  module Configuration
    # Redis instance.
    attr_accessor :redis

    # streak namespace for Redis.
    attr_writer :namespace

    # Key used in Redis for tracking positive.
    attr_writer :positive_key

    # Key used in Redis for tracking positive total.
    attr_writer :positive_total_key

    # Key used in Redis for tracking positive streak.
    attr_writer :positive_streak_key

    # Key used in Redis for tracking negative.
    attr_writer :negative_key

    # Key used in Redis for tracking negative total.
    attr_writer :negative_total_key

    # Key used in Redis for tracking negative streak.
    attr_writer :negative_streak_key

    # Key used in Redis for tracking total.
    attr_writer :total_key
    
    # Yield self to be able to configure Streak with block-style configuration.
    #
    # Example:
    #
    #   Streak.configure do |configuration|
    #     configuration.redis = Redis.new
    #     configuration.namespace = 'streak'
    #     configuration.positive_key = 'wins'
    #     configuration.positive_total_key = 'wins_total'
    #     configuration.positive_streak_key = 'wins_streak'
    #     configuration.negative_key = 'losses'
    #     configuration.negative_total_key = 'losses_total'
    #     configuration.negative_streak_key = 'losses_streak'
    #     configuration.total_key = 'total'
    #   end
    def configure
      yield self
    end

    # streak namespace for Redis.
    #
    # @return the streak namespace or the default of 'streak' if not set.
    def namespace
      @namespace ||= 'streak'
    end

    # Key used in Redis for tracking positive.
    #
    # @return the key used in Redis for tracking positive or the default of 'wins' if not set.
    def positive_key
      @positive_key ||= 'wins'
    end

    # Key used in Redis for tracking positive total.
    #
    # @return the key used in Redis for tracking positive total or the default of 'wins_total' if not set.
    def positive_total_key
      @positive_total_key ||= 'wins_total'
    end

    # Key used in Redis for tracking positive streak.
    #
    # @return the key used in Redis for tracking positive streak or the default of 'wins_streak' if not set.
    def positive_streak_key
      @positive_streak_key ||= 'wins_streak'
    end

    # Key used in Redis for tracking negative.
    # 
    # @return the key used in Redis for tracking negative or the default of 'losses' if not set.
    def negative_key
      @negative_key ||= 'losses'
    end

    # Key used in Redis for tracking negative total.
    #
    # @return the key used in Redis for tracking negative total or the default of 'losses_total' if not set.
    def negative_total_key
      @negative_total_key ||= 'losses_total'
    end

    # Key used in Redis for tracking negative streak.
    #
    # @return the key used in Redis for tracking negative streak or the default of 'losses_streak' if not set.
    def negative_streak_key
      @negative_streak_key ||= 'losses_streak'
    end

    # Key used in Redis for tracking totals.
    #
    # @return the key used in Redis for tracking total or the default of 'total' if not set.
    def total_key
      @total_key ||= 'total'
    end
  end
end
