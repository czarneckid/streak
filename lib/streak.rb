require 'redis'
require 'streak/configuration'
require 'streak/collector'
require 'streak/version'

module Streak
  extend Configuration
  extend Collector
end
