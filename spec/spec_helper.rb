require 'rspec'
require 'streak'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before(:all) do
    Streak.configure do |configuration|
      redis = Redis.new(:db => 15)
      configuration.redis = redis
    end
  end

  config.before(:each) do
    Streak.redis.flushdb
  end

  config.after(:all) do
    Streak.redis.flushdb
    Streak.redis.quit
  end

  def streak_value_for(key, id)
    Streak.redis.get("#{Streak.namespace}::#{key}::#{id}").to_i
  end
end