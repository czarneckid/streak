module Streak
  module Configuration
    # Redis instance.
    attr_accessor :redis

    # streak namespace for Redis.
    attr_writer :namespace
    
    # Yield self to be able to configure Streak with block-style configuration.
    #
    # Example:
    #
    #   Streak.configure do |configuration|
    #     configuration.redis = Redis.new
    #     configuration.namespace = 'streak'
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
  end
end
